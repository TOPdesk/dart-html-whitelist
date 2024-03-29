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
  CleanerImpl(this._tags, this._attributes);

  final List<Tag> _tags;
  final List<Attribute> _attributes;

  @override
  DocumentFragment safeCopy(Node node) {
    var document = Document();
    var safeCopy = document.createDocumentFragment();
    _filter(document, safeCopy, node);
    return safeCopy;
  }

  void _filter(Document document, Node target, Node source) {
    for (var node in source.nodes) {
      if (node is Element) {
        var newTarget = target;
        var originalAttributes =
            Map<String, String>.unmodifiable(_toStringMap(node.attributes));
        var tag = node.localName!;
        if (_tagAllowed(tag, originalAttributes)) {
          newTarget = _copy(document, tag, originalAttributes);
          target.append(newTarget);
        }
        _filter(document, newTarget, node);
      } else if (node is Text) {
        target.append(Text(node.text));
      }
    }
  }

  Map<String, String> _toStringMap(Map<dynamic, String> original) {
    var result = <String, String>{};
    original.forEach((dynamic k, v) {
      result[k.toString()] = v;
    });
    return result;
  }

  bool _tagAllowed(String tag, Map<String, String> attributes) =>
      _tags.any((t) => t.allowed(tag, attributes));

  Element _copy(
      Document document, String tag, Map<String, String> originalAttributes) {
    var collector = Collector();

    for (final a in _attributes) {
      a.generate(tag, originalAttributes, collector);
    }

    return collector.fill(document.createElement(tag));
  }
}
