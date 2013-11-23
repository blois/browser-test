
import 'dart:async';

import 'package:unittest/unittest.dart' as unittest;
export 'package:unittest/matcher.dart';

import 'src/browser_config.dart';
import 'src/platform_status.dart';
import 'src/test.dart';

export 'src/platform_status.dart' show PASS, FAIL;

final Group _root = new Group('_root');
List<Group> _groupStack = <Group>[_root];
final Map<int, Test> _idToTest = <int, Test>{};
final _config = new BrowserConfiguration();


BrowserConfiguration useBrowserConfiguration() {
  // Change the group separator to something we can find.
  unittest.groupSep = '\u2023';
  unittest.unittestConfiguration = _config;

  _config.testResult.listen((testCase) {

    var test = _idToTest[testCase.id];
    if (testCase.passed && !test.canPass) {
     testCase.fail('Expected not to pass: ${test.platformConstraints}');
    } else if (testCase.result == unittest.FAIL && test.canFail) {
      testCase.pass();
    }
  });
}

group(String description, void body()) {
  _groupStack.add(new Group(description));

  unittest.group(description, body);

  _groupStack.removeLast();
}

test(String description, body(), {status}) {
  if (status is PlatformStatus) {
    status = [status];
  }
  var test = new Test(description, body, status);
  _groupStack.last.tests.add(test);

  unittest.test(description, test.execute);

  test.testCase = unittest.testCases.last;
  _idToTest[test.id] = test;
}

void setUp(body()) {
  unittest.setUp(body);
}

void tearDown(body()) {
  unittest.tearDown(body);
}

Future<Group> get onStart => _config.start.first.then((_) => _root);
Stream<Test> get onTestStart => _config.testStart.map((testCase) => _idToTest[testCase.id]);
Stream<Test> get onTestResult => _config.testResult.map((testCase) => _idToTest[testCase.id]);
Stream<Test> get onTestResultChanged => _config.testResultChanged.map((testCase) => _idToTest[testCase.id]);
Future<Group> get onDone => _config.start.first.then((_) => _root);


PlatformStatus ie({int version, int lessThan, should}) {
  return _status(Platform.ie, version, lessThan, should);
}

PlatformStatus chrome({int version, int lessThan, should}) {
  return _status(Platform.chrome, version, lessThan, should);
}

PlatformStatus firefox({int version, int lessThan, should}) {
  return _status(Platform.firefox, version, lessThan, should);
}

PlatformStatus safari({int version, int lessThan, should}) {
  return _status(Platform.safari, version, lessThan, should);
}

PlatformStatus dartium({int version, int lessThan, should}) {
  return _status(Platform.dartium, version, lessThan, should);
}

PlatformStatus _status(Platform platform, int version, int lessThan, should) {
  if (version != null && lessThan != null) {
    throw new ArgumentError('version and lessThan cannot both be specified');
  }
  if (version != null) {
    return new PlatformStatus(new PlatformConstraint.version(platform, version), should);
  } else if (lessThan != null) {
    return new PlatformStatus(new PlatformConstraint.lessThan(platform, lessThan), should);
  } else {
    return new PlatformStatus(new PlatformConstraint.any(platform), should);
  }
}
