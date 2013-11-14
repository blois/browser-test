library mocha_style_test.test_group;

import 'dart:html';
import 'test_result.dart';

class TestGroup {
  final String _name;
  final Element _root = new LIElement();
  final Map<String, TestGroup> _children = <String, TestGroup>{};

  TestGroup(this._name);

  void render(Element host) {
    host.append(_root);
    _root.classes.add('suite');
    _root.append(new HeadingElement.h1()
          ..append(new AnchorElement()
              ..href = '?grep=$_name'
              ..text = _name))
      ..append(new UListElement());
  }
  void addResult(TestResult result) {
    result.render(_root.querySelector('ul'));
  }

  TestGroup operator[](String groupNam) {
    var group = _children[groupName];
    if (group == null) {
      group = new TestGroup(groupName);
      _children[group] = group;
      group.render(_root.querySelector('ul'));
    }
    return group;
  }
}
