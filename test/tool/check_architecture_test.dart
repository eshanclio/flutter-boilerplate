import 'package:flutter_test/flutter_test.dart';

import '../../tool/check_architecture.dart';

void main() {
  group('layerOf', () {
    test('reads the layer from the first folder under lib/', () {
      expect(layerOf('lib/services/todo_service.dart'), 'services');
      expect(
        layerOf('lib/views/todo_list/components/todo_item_tile.dart'),
        'views',
      );
    });

    test('treats lib/main.dart as the main layer', () {
      expect(layerOf('lib/main.dart'), 'main');
    });

    test('returns null only for paths outside lib/', () {
      expect(layerOf('tool/check_architecture.dart'), isNull);
      expect(layerOf('test/tool/check_architecture_test.dart'), isNull);
    });

    test('returns the filename for a loose file under lib/', () {
      // Not a declared layer, so findViolations reports it rather than
      // treating it as exempt.
      expect(layerOf('lib/some_loose_file.dart'), 'some_loose_file.dart');
    });
  });

  group('extractPackageImports', () {
    test('collects own-package imports and exports as lib/ paths', () {
      const source = '''
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/models/todo.dart';
export 'package:flutter_boilerplate/services/todo_service.dart';
''';
      expect(extractPackageImports(source), [
        'lib/models/todo.dart',
        'lib/services/todo_service.dart',
      ]);
    });

    test('ignores part directives and aliased third-party imports', () {
      const source = '''
part 'todo.freezed.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
''';
      expect(extractPackageImports(source), isEmpty);
    });
  });

  group('findViolations', () {
    test('flags a service importing another service', () {
      expect(
        findViolations({
          'lib/services/a_service.dart': ['lib/services/b_service.dart'],
        }),
        [
          'lib/services/a_service.dart imports lib/services/b_service.dart: '
              'services must not import services',
        ],
      );
    });

    test('flags an orchestrator importing an adapter', () {
      expect(
        findViolations({
          'lib/orchestrators/todo_list_orchestrator.dart': [
            'lib/adapters/todo_storage_adapter.dart',
          ],
        }),
        [
          'lib/orchestrators/todo_list_orchestrator.dart imports '
              'lib/adapters/todo_storage_adapter.dart: '
              'orchestrators must not import adapters',
        ],
      );
    });

    test('flags state importing an adapter', () {
      expect(
        findViolations({
          'lib/state/todo_list_provider.dart': [
            'lib/adapters/todo_storage_adapter.dart',
          ],
        }),
        hasLength(1),
      );
    });

    test('flags a view importing a service, an orchestrator, or a route', () {
      expect(
        findViolations({
          'lib/views/todo_list/todo_list_view.dart': [
            'lib/services/todo_service.dart',
            'lib/orchestrators/todo_list_orchestrator.dart',
            'lib/routes/app_router.dart',
          ],
        }),
        hasLength(3),
      );
    });

    test('flags a model importing anything above it', () {
      expect(
        findViolations({
          'lib/models/todo.dart': ['lib/adapters/todo_storage_adapter.dart'],
        }),
        [
          'lib/models/todo.dart imports lib/adapters/todo_storage_adapter.dart: '
              'models must not depend on the higher layer adapters',
        ],
      );
    });

    test('flags a cross-cutting folder importing another layer', () {
      expect(
        findViolations({
          'lib/theme/app_theme.dart': ['lib/models/todo.dart'],
        }),
        [
          'lib/theme/app_theme.dart imports lib/models/todo.dart: '
              'theme is cross-cutting and must not import models',
        ],
      );
    });

    test('allows the sanctioned downward dependencies', () {
      expect(
        findViolations({
          'lib/models/todo.dart': ['lib/models/todo_id.dart'],
          'lib/adapters/todo_storage_adapter.dart': ['lib/models/todo.dart'],
          'lib/services/todo_service.dart': [
            'lib/adapters/todo_storage_adapter.dart',
            'lib/models/todo.dart',
          ],
          'lib/orchestrators/todo_list_orchestrator.dart': [
            'lib/services/todo_service.dart',
            'lib/models/todo.dart',
          ],
          'lib/state/todo_list_provider.dart': [
            'lib/orchestrators/todo_list_orchestrator.dart',
            'lib/services/todo_service.dart',
          ],
          'lib/views/todo_list/todo_list_view.dart': [
            'lib/state/todo_list_provider.dart',
            'lib/models/todo.dart',
          ],
          'lib/routes/app_router.dart': [
            'lib/routes/todo_list_route.dart',
            'lib/views/todo_list/todo_list_view.dart',
          ],
          'lib/main.dart': [
            'lib/routes/app_router.dart',
            'lib/theme/app_theme.dart',
          ],
        }),
        isEmpty,
      );
    });

    test('flags main importing anything but routes and cross-cutting', () {
      expect(
        findViolations({
          'lib/main.dart': [
            'lib/adapters/todo_storage_adapter.dart',
            'lib/services/todo_service.dart',
            'lib/state/todo_list_provider.dart',
          ],
        }),
        [
          'lib/main.dart imports lib/adapters/todo_storage_adapter.dart: '
              'main must not import adapters',
          'lib/main.dart imports lib/services/todo_service.dart: '
              'main must not import services',
          'lib/main.dart imports lib/state/todo_list_provider.dart: '
              'main must not import state',
        ],
      );
    });

    test('flags an unrecognized folder on either side of an import', () {
      expect(
        findViolations({
          'lib/views/todo_list/todo_list_view.dart': [
            'lib/utils/string_utils.dart',
          ],
        }),
        [
          'lib/views/todo_list/todo_list_view.dart imports '
              'lib/utils/string_utils.dart: utils is not a recognized layer '
              'or cross-cutting folder',
        ],
      );
      expect(
        findViolations({
          'lib/utils/string_utils.dart': ['lib/models/todo.dart'],
        }),
        [
          'lib/utils/string_utils.dart imports lib/models/todo.dart: '
              'utils is not a recognized layer or cross-cutting folder',
        ],
      );
    });

    test('flags a loose file under lib/ on either side of an import', () {
      expect(
        findViolations({
          'lib/views/todo_list/todo_list_view.dart': ['lib/app_state.dart'],
        }),
        [
          'lib/views/todo_list/todo_list_view.dart imports lib/app_state.dart: '
              'app_state.dart is not a recognized layer or cross-cutting '
              'folder',
        ],
      );
      expect(
        findViolations({
          'lib/app_state.dart': ['lib/models/todo.dart'],
        }),
        [
          'lib/app_state.dart imports lib/models/todo.dart: app_state.dart is '
              'not a recognized layer or cross-cutting folder',
        ],
      );
    });

    test('flags an adapter importing another adapter', () {
      expect(
        findViolations({
          'lib/adapters/a_adapter.dart': ['lib/adapters/b_adapter.dart'],
        }),
        [
          'lib/adapters/a_adapter.dart imports lib/adapters/b_adapter.dart: '
              'adapters must not import adapters',
        ],
      );
    });

    test('flags an orchestrator importing another orchestrator', () {
      expect(
        findViolations({
          'lib/orchestrators/a_orchestrator.dart': [
            'lib/orchestrators/b_orchestrator.dart',
          ],
        }),
        [
          'lib/orchestrators/a_orchestrator.dart imports '
              'lib/orchestrators/b_orchestrator.dart: '
              'orchestrators must not import orchestrators',
        ],
      );
    });

    test('flags a model importing a cross-cutting folder', () {
      expect(
        findViolations({
          'lib/models/todo.dart': ['lib/theme/tokens.dart'],
        }),
        [
          'lib/models/todo.dart imports lib/theme/tokens.dart: '
              'models must not import theme',
        ],
      );
    });

    test('allows any layer except models to import cross-cutting folders', () {
      expect(
        findViolations({
          'lib/views/todo_list/todo_list_view.dart': [
            'lib/theme/tokens.dart',
            'lib/responsive/responsive_layout.dart',
            'lib/l10n/l10n_extension.dart',
          ],
          'lib/services/todo_service.dart': ['lib/l10n/l10n_extension.dart'],
        }),
        isEmpty,
      );
    });

    test('allows a cross-cutting folder to import within itself', () {
      expect(
        findViolations({
          'lib/theme/app_theme.dart': ['lib/theme/tokens.dart'],
          'lib/l10n/l10n_extension.dart': [
            'lib/l10n/generated/app_localizations.dart',
          ],
        }),
        isEmpty,
      );
    });

    test('reports violations in a stable, sorted order', () {
      final violations = findViolations({
        'lib/views/b_view.dart': ['lib/services/todo_service.dart'],
        'lib/views/a_view.dart': ['lib/services/todo_service.dart'],
      });
      expect(violations, hasLength(2));
      expect(violations.first, startsWith('lib/views/a_view.dart'));
    });
  });
}
