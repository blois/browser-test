library browser_test.mocha_result;

import 'dart:html';

import 'test.dart';

const MEDIUM_TEST_DURATION = const Duration(milliseconds: 100);
const SLOW_TEST_DURATION = const Duration(milliseconds: 1000);

class MochaResult {
  final Test _test;
  final Element _root = new LIElement();

  MochaResult(this._test);

  void render(Element host) {
    host.append(_root);
    _root.classes.add('test');

    var title = new HeadingElement.h2()
      ..text = _test.description;//.split(groupSep).last;
    _root.append(title);

    var url = _test.path;//.replaceAll(groupSep, '/');
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

    if (_test.passed) {
      _root.classes.add('pass');
      _root.querySelector('h2').append(
          new SpanElement()
              ..classes.add('duration')
              .. text = '${_test.runningTime.inMilliseconds}ms');
    } else {
      _root.classes.add('fail');
      var errorElement = _root.querySelector('pre.error');
      if (errorElement == null) {
        errorElement = new Element.tag('pre')
            ..classes.add('error');
        _root.append(errorElement);
      }

      errorElement.text = _test.message + _test.stackTrace.toString();
    }
    if (_test.runningTime > SLOW_TEST_DURATION) {
      _root.classes.add('slow');
    } else if (_test.runningTime > MEDIUM_TEST_DURATION) {
      _root.classes.add('medium');
    }
  }
}
