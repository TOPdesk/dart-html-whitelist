// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:html/dom.dart';
import 'package:htmlwhitelist/src/api/typedefs.dart';
import 'package:htmlwhitelist/src/api/whitelist.dart';
import 'package:htmlwhitelist/src/impl/cleaner.dart';
import 'package:htmlwhitelist/src/impl/extra.dart';
import 'package:htmlwhitelist/src/impl/attribute.dart';

class WhitelistImpl implements Whitelist {
  static final AttributeGenerator noOp = (t, a, g) {};
  static final Matcher noMatcher = (t) => false;

  static final Whitelist none =
      new WhitelistImpl._(noMatcher, const [], const []);

  Matcher _tags;
  Iterable<Attribute> _attributes;
  Iterable<Extra> _extra;
  Cleaner _cleaner;

  WhitelistImpl._(this._tags, this._attributes, this._extra);

  @override
  Whitelist tags(dynamic tags) => _copy.._tags = _matchers(tags, _tags);

  @override
  Whitelist attributes(dynamic tags, dynamic attributes) => _copy
    .._attributes = (new List.from(_attributes)
      ..add(new Attribute(_matchers(tags), _matchers(attributes))));

  @override
  Whitelist extraAttributes(dynamic tags, AttributeGenerator generator) => _copy
    .._extra = (new List.from(_extra)
      ..add(new Extra(_matchers(tags), generator ?? noOp)));

  @override
  DocumentFragment safeCopy(Node node) {
    if (_cleaner == null) _cleaner = new Cleaner(_tags, _attributes, _extra);
    return _cleaner.safeCopy(node);
  }

  Matcher _matchers(dynamic matchers, [Matcher previous]) {
    if (matchers is Matcher) {
      return _listMatcher([previous, matchers]);
    }
    if (matchers is String) {
      return _listMatcher([previous, (t) => t == matchers]);
    }
    var collected = [previous];
    if (matchers is Iterable) {
      var strings = [];
      for (var matcher in matchers) {
        if (matcher is String) {
          strings.add(matcher);
        } else if (matcher is Matcher) {
          collected.add(matcher);
        } else {
          throw new ArgumentError(
              "unsupported type in iterable: ${matchers.runtimeType}");
        }
      }
      if (strings.isNotEmpty) {
        collected.add(strings.contains);
      }
      return _listMatcher(collected);
    }
    throw new ArgumentError("unsupported type ${tags.runtimeType}");
  }

  Matcher _listMatcher(Iterable<Matcher> matchers) {
    var list = new List.from(matchers);
    list.remove(null);
    list.remove(noMatcher);
    if (list.isEmpty) {
      return noMatcher;
    }
    return (String tag) => list.any((m) => m(tag));
  }

  WhitelistImpl get _copy {
    return new WhitelistImpl._(_tags, _attributes, _extra);
  }
}
