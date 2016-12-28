// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:html/parser.dart';
import 'package:htmlwhitelist/htmlwhitelist.dart';
import 'package:htmlwhitelist/src/impl/cleanerimpl.dart';
import 'package:htmlwhitelist/src/impl/extra.dart';
import 'package:htmlwhitelist/src/impl/tag.dart';

class WhitelistImpl implements Whitelist {
  static final AttributeGenerator _noOp = (t, a, g) {};

  static final Whitelist none = new WhitelistImpl._(const [], const []);

  Iterable<Tag> _tags;
  Iterable<Extra> _extra;
  Cleaner _cleaner;

  WhitelistImpl._(this._tags, this._extra);

  @override
  Whitelist tags(dynamic tags, {Filter when}) => _copy
    .._tags =
        (new List.from(_tags)..add(new Tag(_toMatcher(tags), when ?? always)));

  @override
  Whitelist attributes(dynamic tags, dynamic attributes, {Filter when}) =>
      extraAttributes(
          tags, _attributeCopier(_toMatcher(attributes), when ?? always));

  @override
  Whitelist extraAttributes(dynamic tags, AttributeGenerator generator,
          {Filter when}) =>
      _copy
        .._extra = (new List.from(_extra)
          ..add(
              new Extra(_toMatcher(tags), generator ?? _noOp, when ?? always)));

  @override
  String safeCopy(String contents) {
    return cleaner.safeCopy(parseFragment(contents)).outerHtml;
  }

  @override
  Cleaner get cleaner {
    if (_cleaner == null) {
      _cleaner = new CleanerImpl(_tags, _extra);
    }
    return _cleaner;
  }

  Matcher _toMatcher(dynamic matcher) {
    if (matcher is Matcher) {
      return matcher;
    }
    if (matcher is String) {
      return (s) => matcher == s;
    }
    if (matcher is Iterable) {
      var copy = new List.from(matcher);
      copy.forEach((s) {
        if (s is! String) {
          throw new ArgumentError(
              "unsupported type in iterable: ${s.runtimeType}");
        }
      });
      return copy.contains;
    }
    throw new ArgumentError("unsupported type ${matcher.runtimeType}");
  }

  AttributeGenerator _attributeCopier(Matcher attributes, Filter when) =>
      (String tag, Map<String, String> originalAttributes, AddAttribute adder) {
        originalAttributes.forEach((k, v) {
          if (attributes(k) && when(tag, originalAttributes)) {
            adder(k, v);
          }
        });
      };

  WhitelistImpl get _copy {
    return new WhitelistImpl._(_tags, _extra);
  }
}
