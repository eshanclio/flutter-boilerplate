// A deliberate riverpod_lint violation, kept so CI can prove the plugin is
// actually loading.
//
// riverpod_lint is declared under `plugins:` in analysis_options.yaml rather
// than as a pubspec dependency. If that constraint ever stops resolving, the
// plugin simply stops contributing diagnostics — and `dart analyze` still
// exits 0, so every riverpod rule would silently vanish with CI staying green.
// The "Verify riverpod_lint is active" step analyzes this file by name and
// fails unless `missing_provider_scope` is reported.
//
// This directory is excluded from the project-wide analyze in
// analysis_options.yaml, so this violation does not fail normal runs. Do not
// "fix" the missing ProviderScope below — the violation is the point.
import 'package:flutter/material.dart';

void main() => runApp(const Placeholder());
