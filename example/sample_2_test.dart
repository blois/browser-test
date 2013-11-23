// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library other_tests;

import 'dart:async';
import 'dart:html';

import 'package:browser_test/browser_test.dart';

main() {
  test('zero', () {
    return new Future.delayed(new Duration(milliseconds: 100));
  });

  group('counting', () {
    test('one', () {
      return new Future.delayed(new Duration(milliseconds: 100));
    });

    test('two', () {
      return new Future.delayed(new Duration(milliseconds: 100));
    });

    test('three', () {
      return new Future.delayed(new Duration(milliseconds: 100));
    });

    test('four', () {
      return new Future.delayed(new Duration(milliseconds: 100));
    });

    test('five', () {
      return new Future.delayed(new Duration(milliseconds: 100));
    });

    test('six', () {
      return new Future.delayed(new Duration(milliseconds: 100));
    });

    test('seven', () {
      expect(true, false);
    });

    test('eight', () {
      return new Future.delayed(new Duration(milliseconds: 400));
    });

    test('userAgent firefox', () {
      expect(window.navigator.userAgent, matches('Firefox'));
    },
    status: chrome(should: [FAIL]));
  });
}
