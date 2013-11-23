library browser_test.test;

import 'dart:async';

import 'package:unittest/unittest.dart' as unittest;

import 'platform_status.dart';

class Group {
  final String description;
  final List<Test> tests = <Test>[];

  Group(this.description);
}

class Test {
  final String description;
  final Function _body;
  final Iterable<PlatformStatus> _statuses;
  unittest.TestCase _testCase;

  Test(this.description, this._body, this._statuses);

  void set testCase(unittest.TestCase testCase) {
    if (_testCase != null) {
      throw new StateError('testCase already set.');
    }
    _testCase = testCase;
  }

  execute() {
    return _body();
  }

  bool get canPass {
    if (_statuses == null) {
      return true;
    }
    var active = _statuses.where((s) => s.isActive);
    return active.length == 0 || _statuses.any((s) => s.canPass);
  }

  bool get canFail {
    if (_statuses == null) {
      return false;
    }
    return _statuses.any((s) => s.canFail);
  }

  String get platformConstraints {
    if (_statuses == null) {
      return '';
    }
    return _statuses.where((s) => s.isActive).join(',');
  }

  int get id => _testCase.id;
  bool get passed => _testCase.passed;
  Duration get runningTime => _testCase.runningTime;
  String get path => _testCase.description.replaceAll(unittest.groupSep, '/');
  String get message => _testCase.message;
  StackTrace get stackTrace => _testCase.stackTrace;
}
