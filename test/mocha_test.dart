// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library js_tests;

import 'dart:async';
import 'dart:html';

import 'package:mocha_style_test/mocha.dart';
import 'package:unittest/unittest.dart';

main() {
  useMochaConfiguration();

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
      expect(true, false);
    });

    test('eight', () {
      return new Future.delayed(new Duration(milliseconds: 200));
    });
  });
}
