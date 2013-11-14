library mocha_style.mocha;

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js' as js;

import 'package:unittest/unittest.dart';

import 'src/test_group.dart';
import 'src/test_result.dart';
import 'src/test_stats.dart';

void useMochaConfiguration() {
  // Change the group separator to something we can find.
  groupSep = '\u2023';
  unittestConfiguration = _singleton;
}

final _singleton = new MochaConfiguration();


class MochaConfiguration extends SimpleConfiguration {
  Element _display;
  Element _testRoot;
  final Map<int, TestResult> _results = <int, TestResult>{};
  final Map<String, TestGroup> _groups = <String, TestGroup>{};
  final TestStats _stats = new TestStats();


  MochaConfiguration() {
    _display = document.querySelector('#mocha');
    if (_display != null) {
      _stats.render(_display);
      _testRoot = new UListElement()
        ..id = 'mocha-report';
      _display.append(_testRoot);
    }
  }

  StreamSubscription<Event> _onErrorSubscription;
  StreamSubscription<Event> _onMessageSubscription;

  void _installHandlers() {
    if (_onErrorSubscription == null) {
      _onErrorSubscription = window.onError.listen(
        (e) {
          // Some tests may expect this and have no way to suppress the error.
          if (js.context['testExpectsGlobalError'] != true) {
            handleExternalError(e, '(DOM callback has errors)');
          }
        });
    }
    if (_onMessageSubscription == null) {
      _onMessageSubscription = window.onMessage.listen(
        (e) => processMessage(e));
    }
  }

  void _uninstallHandlers() {
    if (_onErrorSubscription != null) {
      _onErrorSubscription.cancel();
      _onErrorSubscription = null;
    }
    if (_onMessageSubscription != null) {
      _onMessageSubscription.cancel();
      _onMessageSubscription = null;
    }
  }

  void processMessage(e) {
    if ('unittest-suite-external-error' == e.data) {
      handleExternalError('<unknown>', '(external error detected)');
    }
  }

  void onInit() {
    // For Dart internal tests, we want to turn off stack frame
    // filtering, which we do with this meta-header.
    var meta = query('meta[name="dart.unittest"]');
    filterStacks = meta == null ? true :
       !meta.content.contains('full-stack-traces');
    _installHandlers();
    window.postMessage('unittest-suite-wait-for-done', '*');
  }

  void onStart() {
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
          filter = filter.replaceAll('>', groupSep);
          filterTests('^$filter');
        }
      }
    }
    super.onStart();
    if (_stats != null) {
      _stats.onStart();
    }
  }

  void onTestStart(TestCase test) {
    super.onTestStart(test);

    var result = findResult(test);
    if (result == null) {
      return;
    }

    result.started();
  }

  void onTestResult(TestCase test) {
    super.onTestResult(test);

    var result = findResult(test);
    if (result == null) {
      return;
    }
    result.completed();
    _stats.onTestResult(test);
  }

  TestResult findResult(TestCase test) {
    var result = _results[test.id];
    if (result == null && _display != null) {
      var path = test.description.split(groupSep);
      result = new TestResult(test);
      if (path.length > 1) {
        var group = _groups[path[0]];
        if (group == null) {
          group = new TestGroup(path[0]);
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

  void onDone(bool success) {
    _uninstallHandlers();
    window.postMessage('unittest-suite-done', '*');
  }
}
