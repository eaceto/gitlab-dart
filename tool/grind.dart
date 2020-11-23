import 'dart:async';
import 'dart:io';

import 'package:grinder/grinder.dart';
import 'package:logging/logging.dart';
import 'package:grind_publish/grind_publish.dart' as grind_publish;

const _lineLength = 80;

void main(List<String> args) {
  Logger.root.onRecord.listen((record) => log(record.message));
  grind(args);
}

@Task('Runs all tests required to pass')
@Depends(analyze, unitTest, checkFormat)
bool test() => true;

@Task('Runs the unit tests for this library')
Future unitTest() => new TestRunner().testAsync(concurrency: 4);

@Task('Runs dartanalyzer and makes sure there are no warnings or lint proplems')
Future<Null> analyze() async {
  await runAsync('dartanalyzer',
      arguments: ['.', '--fatal-hints', '--fatal-warnings', '--fatal-lints']);
}

@Task()
void checkFormat() {
  if (DartFmt.dryRun(new Directory('.'), lineLength: _lineLength))
    fail('Code is not properly formatted. Run `grind format`');
}

@Task()
void format() => DartFmt.format(new Directory('.'), lineLength: _lineLength);

@Task()
Future autoPublish() => grind_publish.autoPublish(
    'gitlab', grind_publish.Credentials.fromEnvironment());
