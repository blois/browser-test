library browser_test.mocha_group;

import 'dart:html';
import 'mocha_result.dart';

class MochaGroup {
  final String _name;
  final Element _root = new LIElement();
  final Map<String, MochaGroup> _children = <String, MochaGroup>{};

  MochaGroup(this._name);

  void render(Element host) {
    host.append(_root);
    _root.classes.add('suite');
    _root.append(new HeadingElement.h1()
          ..append(new AnchorElement()
              ..href = '?grep=$_name'
              ..text = _name))
      ..append(new UListElement());
  }
  void addResult(MochaResult result) {
    result.render(_root.querySelector('ul'));
  }

  MochaGroup operator[](String groupName) {
    var group = _children[groupName];
    if (group == null) {
      group = new MochaGroup(groupName);
      _children[groupName] = group;
      group.render(_root.querySelector('ul'));
    }
    return group;
  }
}
