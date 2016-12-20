// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/src/api/cleaner.dart';
import 'package:htmlwhitelist/src/api/typedefs.dart';
import 'package:htmlwhitelist/src/api/whitelist.dart';
import 'package:htmlwhitelist/src/impl/cleanerimpl.dart';
import 'package:htmlwhitelist/src/impl/extra.dart';
import 'package:htmlwhitelist/src/impl/attribute.dart';

class WhitelistImpl extends Whitelist {
  Matcher _tags = noMatcher;
  Iterable<Attribute> _attributes = const [];
  Iterable<Extra> _extra = const [];

  WhitelistImpl();

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
  Cleaner cleaner() => new CleanerImpl(_tags, _attributes, _extra);

  Matcher _matchers(dynamic matchers, [Matcher previous]) {
    if (matchers is Matcher) {
      return _listMatcher([previous, matchers]);
    }
    if (matchers is String) {
      return _listMatcher([previous, (t) => t == matchers]);
    }
    var collected = [previous];
    if (matchers is List) {
      var strings = [];
      for (var matcher in matchers) {
        if (matcher is String) {
          strings.add(matcher);
        } else if (matcher is Matcher) {
          collected.add(matcher);
        } else {
          throw new ArgumentError(
              "unsupported type list ${matchers.runtimeType}");
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
    return new WhitelistImpl()
      .._tags = _tags
      .._attributes = _attributes
      .._extra = _extra;
  }
}
