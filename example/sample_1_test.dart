// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library browser_tests;

import 'dart:async';
import 'dart:html';

import 'package:browser_test/browser_test.dart';

main() {
  test('zero', () {
    return new Future.delayed(new Duration(milliseconds: 10));
  });

  group('counting', () {
    test('one', () {
      return new Future.delayed(new Duration(milliseconds: 10));
    });

    test('two', () {
      return new Future.delayed(new Duration(milliseconds: 10));
    });

    test('three', () {
      return new Future.delayed(new Duration(milliseconds: 10));
    });

    test('four', () {
      return new Future.delayed(new Duration(milliseconds: 10));
    });

    test('five', () {
      return new Future.delayed(new Duration(milliseconds: 10));
    });

    test('six', () {
      return new Future.delayed(new Duration(milliseconds: 10));
    });

    test('seven', () {
      return new Future.delayed(new Duration(milliseconds: 10));
    });

    test('eight', () {
      return new Future.delayed(new Duration(milliseconds: 200));
    }, status: [
      ie(version: 9, should: FAIL),
      chrome(lessThan: 31, should: FAIL),
      dartium(should: [PASS, FAIL])
    ]);
  });
}
