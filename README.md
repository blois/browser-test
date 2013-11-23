Dart unittest wrapper tailored for browser-based tests
===================

A wrapper for the Dart unittest library which extends the syntax to allow specifying platform-specific test expectations.

For complex browser applications, not all platforms will support all functionality. This test framework is intended to
make it easy to specify when functionality is expected to not work on specific browsers.

This library is just a wrapper around the existing `package:unittest` framework, so all existing test runners are intended to continue to work.

It follows the same `package:unittest` syntax, including using the same expectation library.

    test('userAgent firefox', () {
      expect(window.navigator.userAgent, matches('Firefox'));
    },
    status: chrome(should: [FAIL], reason: 'Chrome is not Firefox'));
    
More complicated expectations can also be expressed, including browser version dependencies:

    test('eight', () {
      // Some test logic
    }, status: [
      ie(version: 9, should: FAIL),
      chrome(lessThan: 31, should: FAIL),
      dartium(should: [PASS, FAIL], reason: 'Issue 9402, timing is flaky')
    ]);
    
In addition, this test configuration separates the execution of your tests (the test configuration), from the display
of the test results. By default, only the standart test controller output will be rendered, but nicer rendering can be used by specifying a display:

    new MochaDisplay(dom.querySelector("#mocha"));
    
The display also makes it easy to filter down execution to specific tests.
