library browser_test.browser_config;

import 'dart:async';
import 'dart:html' as dom;
import 'dart:js' as js;

import 'package:unittest/unittest.dart' as unittest;

import 'test.dart';

class BrowserConfiguration extends unittest.SimpleConfiguration {
  StreamSubscription<dom.Event> _onErrorSubscription;
  StreamSubscription<dom.Event> _onMessageSubscription;
  final StreamController _start = new StreamController.broadcast(sync: true);
  final StreamController<unittest.TestCase> _testStart =
      new StreamController<unittest.TestCase>.broadcast(sync: true);
  final StreamController<unittest.TestCase> _testResult =
      new StreamController<unittest.TestCase>.broadcast(sync: true);
  final StreamController<unittest.TestCase> _testResultChanged =
      new StreamController<unittest.TestCase>.broadcast(sync: true);
  final StreamController _done = new StreamController.broadcast(sync: true);

  BrowserConfiguration() {
  }

  Stream get start => _start.stream;
  Stream<unittest.TestCase> get testStart => _testStart.stream;
  Stream<unittest.TestCase> get testResult => _testResult.stream;
  Stream<unittest.TestCase> get testResultChanged => _testResultChanged.stream;
  Stream get done => done.stream;

  void _installHandlers() {
    if (_onErrorSubscription == null) {
      _onErrorSubscription = dom.window.onError.listen(
        (e) {
          // Some tests may expect this and have no way to suppress the error.
          if (js.context['testExpectsGlobalError'] != true) {
            unittest.handleExternalError(e, '(DOM callback has errors)');
          }
        });
    }
    if (_onMessageSubscription == null) {
      _onMessageSubscription = dom.window.onMessage.listen(
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
      unittest.handleExternalError('<unknown>', '(external error detected)');
    }
  }

  void onInit() {
    // For Dart internal tests, we want to turn off stack frame
    // filtering, which we do with this meta-header.
    var meta = dom.querySelector('meta[name="dart.unittest"]');
    unittest.filterStacks = meta == null ? true :
       !meta.content.contains('full-stack-traces');
    _installHandlers();
    dom.window.postMessage('unittest-suite-wait-for-done', '*');
  }

  void onStart() {
    _start.add(this);
    super.onStart();
  }

  void onTestStart(unittest.TestCase test) {
    super.onTestStart(test);
    _testStart.add(test);
  }

  void onTestResult(unittest.TestCase test) {
    super.onTestResult(test);
    _testResult.add(test);
  }

  void onTestResultChanged(unittest.TestCase test) {
    super.onTestResultChanged(test);
    _testResultChanged.add(test);
  }

  void onDone(bool success) {
    _uninstallHandlers();
    _done.add(this);

    dom.window.postMessage('unittest-suite-done', '*');
  }
}
