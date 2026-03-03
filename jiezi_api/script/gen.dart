/// Code generation script.
///
/// Runs `dart run openapi_gen` followed by `dart run build_runner build -d`
/// in the package root directory.
///
/// Usage:
///   dart run script/gen.dart
library;

import 'dart:io';

Future<void> main() async {
  // Resolve the package root: the directory that contains this script's
  // grandparent (script/ -> <package_root>).
  final packageRoot = File(Platform.script.toFilePath()).parent.parent.path;

  await _run('dart', ['run', 'openapi_gen'], workingDirectory: packageRoot);

  await _run('dart', [
    'run',
    'build_runner',
    'build',
    '-d',
  ], workingDirectory: packageRoot);
}

/// Runs [executable] with [arguments] inside [workingDirectory].
///
/// Inherits stdout / stderr so all output is streamed directly to the
/// terminal.  Exits the process with the child's exit code on failure.
Future<void> _run(
  String executable,
  List<String> arguments, {
  required String workingDirectory,
}) async {
  stdout.writeln('\n\$ $executable ${arguments.join(' ')}');

  final process = await Process.start(
    executable,
    arguments,
    workingDirectory: workingDirectory,
    // Let the child process inherit the parent's stdin/stdout/stderr.
    mode: ProcessStartMode.inheritStdio,
  );

  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    stderr.writeln(
      'Command "$executable ${arguments.join(' ')}" '
      'failed with exit code $exitCode.',
    );
    exit(exitCode);
  }
}
