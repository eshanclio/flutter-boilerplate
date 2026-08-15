// Enforces the layered architecture described in AGENTS.md and
// docs/superpowers/specs/2026-08-13-flutter-boilerplate-ddd-design.md.
//
// Run from the repo root:  dart run tool/check_architecture.dart
//
// This file lives outside lib/ so the app never depends on it. Its logic is
// split into pure functions (layerOf, extractPackageImports, findViolations)
// that are unit-tested without touching the filesystem, plus a thin main()
// that walks the tree.
import 'dart:io';

/// The package name, used to recognise own-package imports.
const packageName = 'flutter_boilerplate';

const _packagePrefix = 'package:$packageName/';

/// Layers ordered lowest to highest. A file may import its own layer or any
/// lower layer, never a higher one.
const layerOrder = <String>[
  'models',
  'adapters',
  'services',
  'orchestrators',
  'state',
  'views',
  'routes',
  'main',
];

/// Folders any layer may import, and which may only import within themselves.
const crossCuttingLayers = <String>{'theme', 'responsive', 'l10n'};

/// Prohibitions the layer ordering alone does not express — cases where a
/// lower layer exists but must be reached indirectly.
const forbiddenImports = <String, Set<String>>{
  // Spec §3: adapters may import models only, so no adapter-to-adapter reuse.
  'adapters': {'adapters'},
  // No service-to-service calls.
  'services': {'services'},
  // Spec §3: orchestrators may import models and services only. One
  // orchestrator composing another hides the real dependency from its route.
  'orchestrators': {'adapters', 'orchestrators'},
  'state': {'adapters'},
  // Must go through state.
  'views': {'adapters', 'services', 'orchestrators'},
  'routes': {'adapters', 'services', 'orchestrators'},
  // The entrypoint wires up routing and app-level config only. `routes` stays
  // allowed via the layer-order check, as do the cross-cutting folders.
  'main': {'models', 'adapters', 'services', 'orchestrators', 'state', 'views'},
};

/// Layers that may not import a cross-cutting folder. `models` is a pure,
/// dependency-free leaf: it holds data and validates its own shape, so it has
/// no need for theming, breakpoints, or localization.
const crossCuttingForbiddenFrom = <String>{'models'};

/// The layer a `lib/`-relative path belongs to, or `null` if the path is not
/// under `lib/` at all.
///
/// `lib/main.dart` maps to the synthetic `main` layer so the entrypoint's
/// imports are checked rather than silently skipped. Any other file directly
/// under `lib/` returns its own filename: a filename can never match a
/// declared layer, so it is reported as unrecognized rather than silently
/// exempted. Without this, `lib/app_state.dart` could import every layer and
/// be imported by every layer with no diagnostic — the same hole that
/// unrecognized *folders* used to slip through.
String? layerOf(String libPath) {
  final parts = libPath.split('/');
  if (parts.length < 2 || parts.first != 'lib') return null;
  if (parts.length == 2) return parts[1] == 'main.dart' ? 'main' : parts[1];
  return parts[1];
}

/// The `lib/`-relative targets of every own-package `import` or `export` in
/// [source]. `part` directives are ignored — generated parts are always
/// relative and belong to their own library.
List<String> extractPackageImports(String source) {
  final pattern = RegExp(
    r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''',
    multiLine: true,
  );

  return [
    for (final match in pattern.allMatches(source))
      if (match.group(1)!.startsWith(_packagePrefix))
        'lib/${match.group(1)!.substring(_packagePrefix.length)}',
  ];
}

/// Whether [layer] is declared in [layerOrder] or [crossCuttingLayers].
bool _isKnownLayer(String layer) =>
    layerOrder.contains(layer) || crossCuttingLayers.contains(layer);

/// One human-readable message per disallowed import in [importsByFile], which
/// maps a `lib/`-relative file path to the `lib/`-relative paths it imports.
///
/// Pure: no filesystem access, so it is directly unit-testable. Output is
/// sorted by importing file so CI failures are stable and diffable.
List<String> findViolations(Map<String, List<String>> importsByFile) {
  final violations = <String>[];
  final files = importsByFile.keys.toList()..sort();

  for (final file in files) {
    final from = layerOf(file);
    if (from == null) continue;

    for (final imported in importsByFile[file]!) {
      final to = layerOf(imported);
      if (to == null) continue;

      // A folder nobody declared is not implicitly exempt: it would otherwise
      // slip past every rule below in both directions.
      if (!_isKnownLayer(from)) {
        violations.add(
          '$file imports $imported: $from is not a recognized layer or '
          'cross-cutting folder',
        );
        continue;
      }
      if (!_isKnownLayer(to)) {
        violations.add(
          '$file imports $imported: $to is not a recognized layer or '
          'cross-cutting folder',
        );
        continue;
      }

      if (crossCuttingLayers.contains(from)) {
        if (to != from) {
          violations.add(
            '$file imports $imported: $from is cross-cutting and must not '
            'import $to',
          );
        }
        continue;
      }

      // Any layer except models may import a cross-cutting folder.
      if (crossCuttingLayers.contains(to)) {
        if (crossCuttingForbiddenFrom.contains(from)) {
          violations.add('$file imports $imported: $from must not import $to');
        }
        continue;
      }

      if (forbiddenImports[from]?.contains(to) ?? false) {
        violations.add('$file imports $imported: $from must not import $to');
        continue;
      }

      final fromIndex = layerOrder.indexOf(from);
      final toIndex = layerOrder.indexOf(to);

      if (toIndex > fromIndex) {
        violations.add(
          '$file imports $imported: $from must not depend on the higher '
          'layer $to',
        );
      }
    }
  }

  return violations;
}

/// Generated files are not hand-written, so their imports are not the
/// author's choice and are excluded from the check.
bool isGenerated(String libPath) =>
    libPath.endsWith('.g.dart') ||
    libPath.endsWith('.freezed.dart') ||
    libPath.startsWith('lib/l10n/generated/');

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln(
      'check_architecture: no lib/ directory found — run from the repo root.',
    );
    exit(2);
  }

  final importsByFile = <String, List<String>>{};

  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! File) continue;
    final path = entity.path.replaceAll(r'\', '/');
    if (!path.endsWith('.dart') || isGenerated(path)) continue;
    importsByFile[path] = extractPackageImports(entity.readAsStringSync());
  }

  final violations = findViolations(importsByFile);

  if (violations.isEmpty) {
    stdout.writeln(
      'check_architecture: no layer violations found '
      '(${importsByFile.length} files checked).',
    );
    return;
  }

  stderr.writeln(
    'check_architecture: found ${violations.length} violation(s):',
  );
  for (final violation in violations) {
    stderr.writeln('  - $violation');
  }
  exit(1);
}
