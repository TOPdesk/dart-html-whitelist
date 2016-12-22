// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:html/dom.dart';
import 'package:htmlwhitelist/src/api/typedefs.dart';
import 'package:htmlwhitelist/src/impl/extra.dart';
import 'package:htmlwhitelist/src/impl/attribute.dart';

class Cleaner {
  final Matcher _tags;
  final Iterable<Attribute> _attributes;
  final Iterable<Extra> _extra;

  Cleaner(this._tags, this._attributes, this._extra);

  DocumentFragment safeCopy(Node node) {
    var document = new Document();
    var safeCopy = document.createDocumentFragment();
    _filter(document, safeCopy, node);
    return safeCopy;
  }

  _filter(Document document, Node target, Node source) {
    for (var node in source.nodes) {
      if (node is Element) {
        var newTarget = target;
        if (_tagAllowed(node)) {
          newTarget = _copy(document, node);
          target.append(newTarget);
        }
        _filter(document, newTarget, node);
      } else if (node is Text) {
        target.append(new Text(node.text));
      }
    }
  }

  bool _tagAllowed(Element element) => _tags(element.localName);
  bool _attributeAllowed(String tag, String attribute) =>
      _attributes.any((a) => a.allowed(tag, attribute));

  Element _copy(Document document, Element element) {
    var tag = element.localName;
    var copy = document.createElement(tag);

    element.attributes.forEach((k, v) {
      var name = k.toString();
      if (_attributeAllowed(tag, name)) {
        copy.attributes[name] = v;
      }
    });

    var a = new Map.from(copy.attributes);
    for (var extra in _extra) {
      extra.generate(
          tag, a, (attribute, value) => copy.attributes[attribute] = value);
    }
    return copy;
  }
}
