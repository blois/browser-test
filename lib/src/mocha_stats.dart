library browser_test.mocha_stats;

import 'dart:html';

import 'test.dart';

class TestStats {
  Element _root;
  int _passes = 0;
  int _failures = 0;
  final Stopwatch _stopwatch = new Stopwatch();

  void render(Element host) {
    _root = new UListElement()
      ..id = 'mocha-stats';
    host.append(_root);
    _root.append(new LIElement()
        ..classes.add('progress'));
    _root.append(new LIElement()
        ..classes.add('passes')
        ..append(new AnchorElement()
            ..href = '#'
            ..text = 'passes:')
        ..append(new Element.tag('em')
            ..text = '0'));
    _root.append(new LIElement()
        ..classes.add('failures')
        ..append(new AnchorElement()
            ..href = '#'
            ..text = 'failures:')
        ..append(new Element.tag('em')
            ..text = '0'));
    _root.append(new LIElement()
        ..classes.add('duration')
        ..append(new AnchorElement()
            ..href = '#'
            ..text = 'duration:')
        ..append(new Element.tag('em')
            ..text = '0')
        ..append(new Text('s')));
  }

  void onStart() {
    _stopwatch.start();
  }

  void onTestResult(Test test) {
    if (test.passed) {
      ++_passes;
      _root.querySelector('.passes em').text = '$_passes';
    } else {
      ++_failures;
      _root.querySelector('.failures em').text = '$_failures';
    }
    _root.querySelector('.duration em').text =
        '${_stopwatch.elapsed.inSeconds}';
  }
}
