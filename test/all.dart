import "dart:html" as dom;

import "package:browser_test/browser_test.dart";
import "package:browser_test/mocha_display.dart";

import "sample_1_test.dart" as test0;
import "sample_2_test.dart" as test1;

main() {
  useBrowserConfiguration();

  if (dom.querySelector('#mocha') != null) {
    new MochaDisplay(dom.querySelector("#mocha"));
  }
  group('sample_1_test.dart', () {
    test0.main();
  });
  group('sample_2_test.dart', () {
    test1.main();
  });
}
