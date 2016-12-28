// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:html/dom.dart';
import 'package:htmlwhitelist/htmlwhitelist.dart';
import 'package:htmlwhitelist/src/impl/extra.dart';
import 'package:htmlwhitelist/src/impl/tag.dart';

class CleanerImpl implements Cleaner {
  final Iterable<Tag> _tags;
  final Iterable<Extra> _extra;

  CleanerImpl(this._tags, this._extra);

  @override
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
        var originalAttributes = new Map.from(node.attributes);
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
    var copy = document.createElement(tag);

    for (var extra in _extra) {
      extra.generate(tag, originalAttributes,
          (attribute, value) => copy.attributes[attribute] = value);
    }
    return copy;
  }
}
