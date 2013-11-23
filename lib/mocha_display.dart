library mocha_style.mocha;

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js' as js;

import 'package:unittest/unittest.dart' as unittest;

import 'src/mocha_group.dart';
import 'src/mocha_result.dart';
import 'src/mocha_stats.dart';
import 'src/test.dart';

import 'browser_test.dart' as browser_test;

class MochaDisplay {
  Element _testRoot;
  final Map<int, MochaResult> _results = <int, MochaResult>{};
  final Map<String, MochaGroup> _groups = <String, MochaGroup>{};
  final TestStats _stats = new TestStats();
  final Element _display;


  MochaDisplay(this._display) {
    _stats.render(_display);
    _testRoot = new UListElement()
      ..id = 'mocha-report';
    _display.append(_testRoot);

    var style = new LinkElement();
    style.rel = 'stylesheet';
    style.href = 'packages/browser_test/mocha.css';
    document.head.append(style);

    browser_test.onStart.then((_) {
      // If the URL has a #testFilter=testName then filter tests to that.
      // This is used to make it easy to run a single test- but is only intended
      // for interactive debugging scenarios.
      var search = window.location.search;
      if (search != null && search.length > 1) {
        var params = search.substring(1).split('&');
        for (var param in params) {
          var parts = param.split('=');
          if (parts.length == 2 && parts[0] == 'grep') {
            var filter = Uri.decodeQueryComponent(parts[1]);
            filter = filter.replaceAll('/', unittest.groupSep);
            unittest.filterTests('^$filter');
          }
        }
      }
      _stats.onStart();
    });

    browser_test.onTestStart.listen((test) {
      findResult(test).started();
    });
    browser_test.onTestResult.listen((test) {
      var result = findResult(test);
      result.completed();
      _stats.onTestResult(test);
    });

    browser_test.onTestResultChanged.listen((test) {
      var result = findResult(test);
      result.completed();
      _stats.onTestResult(test);
    });
  }

  MochaResult findResult(Test test) {
    var result = _results[test.id];
    if (result == null) {
      var path = test.path.split('/');
      result = new MochaResult(test);
      if (path.length > 1) {
        var group = _groups[path[0]];
        if (group == null) {
          group = new MochaGroup(path[0]);
          group.render(_testRoot);
          _groups[path[0]] = group;
        }

        for (var i = 1; i < path.length - 1; ++i) {
          group = group[path[i]];
        }
        group.addResult(result);
      } else {
        result.render(_testRoot);
      }
      _results[test.id] = result;
    }
    return result;
  }
}
