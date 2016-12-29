// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:html/dom.dart';
import 'package:htmlwhitelist/htmlwhitelist.dart';

import 'attribute.dart';
import 'collector.dart';
import 'tag.dart';

class CleanerImpl implements Cleaner {
  final List<Tag> _tags;
  final List<Attribute> _attributes;

  CleanerImpl(this._tags, this._attributes);

  @override
  DocumentFragment safeCopy(Node node) {
    var document = new Document();
    var safeCopy = document.createDocumentFragment();
    _filter(document, safeCopy, node);
    return safeCopy;
  }

  void _filter(Document document, Node target, Node source) {
    for (var node in source.nodes) {
      if (node is Element) {
        var newTarget = target;
        var originalAttributes =
            new Map.unmodifiable(new LinkedHashMap.from(node.attributes));
        var tag = node.localName;
        if (_tagAllowed(tag, originalAttributes)) {
          newTarget = _copy(document, tag, originalAttributes);
          target.append(newTarget);
        }
        _filter(document, newTarget, node);
      } else if (node is Text) {
        target.append(new Text(node.text));
      }
    }
  }

  bool _tagAllowed(String tag, Map<String, String> attributes) =>
      _tags.any((t) => t.allowed(tag, attributes));

  Element _copy(
      Document document, String tag, Map<String, String> originalAttributes) {
    var collector = new Collector();

    _attributes.forEach((a) => a.generate(tag, originalAttributes, collector));

    return collector.fill(document.createElement(tag));
  }
}
