library mocha_style_test.test_group;

import 'dart:html';
import 'package:unittest/unittest.dart';

const MEDIUM_TEST_DURATION = const Duration(milliseconds: 100);
const SLOW_TEST_DURATION = const Duration(milliseconds: 1000);

class TestResult {
  final TestCase _testCase;
  final Element _root = new LIElement();

  TestResult(this._testCase);

  void render(Element host) {
    host.append(_root);
    _root.classes.add('test');

    var title = new HeadingElement.h2()
      ..text = _testCase.description.split(groupSep).last;
    _root.append(title);

    var url = _testCase.description.replaceAll(groupSep, '>');
    title.append(new AnchorElement()
        ..classes.add('replay')
        ..href = '?grep=$url'
        ..text = '\u2023');
  }

  void started() {
    _root.classes.add('pending');
  }

  void completed() {
    _root.classes.remove('pending');

    if (_testCase.passed) {
      _root.classes.add('pass');
      _root.querySelector('h2').append(
          new SpanElement()
              ..classes.add('duration')
              .. text = '${_testCase.runningTime.inMilliseconds}ms');
    } else {
      _root.classes.add('fail');
      _root.append(
          new Element.tag('pre')
            ..classes.add('error')
            ..text = _testCase.message + _testCase.stackTrace.toString());
    }
    if (_testCase.runningTime > SLOW_TEST_DURATION) {
      _root.classes.add('slow');
    } else if (_testCase.runningTime > MEDIUM_TEST_DURATION) {
      _root.classes.add('medium');
    }
  }
}
