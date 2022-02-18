// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:html/parser.dart';
import 'package:htmlwhitelist/htmlwhitelist.dart';

import 'attribute.dart';
import 'cleanerimpl.dart';
import 'tag.dart';

class WhitelistImpl implements Whitelist {
  WhitelistImpl._(this._tags, this._attributes);

  void _noOp(String tag, Map<String, String> originalAttributes,
      AttributeCollector collector) {}

  static final Whitelist none = WhitelistImpl._(const [], const []);

  final List<Tag> _tags;
  final List<Attribute> _attributes;
  Cleaner? _cleaner;

  @override
  Whitelist tags(dynamic tags, {Filter? when}) => WhitelistImpl._(
      (List.from(_tags)..add(Tag(_toMatcher(tags), when ?? always))),
      _attributes);

  @override
  Whitelist attributes(dynamic tags, dynamic attributes, {Filter? when}) =>
      extraAttributes(
          tags, _attributeCopier(_toMatcher(attributes), when ?? always));

  @override
  Whitelist extraAttributes(dynamic tags, AttributeGenerator? generator,
          {Filter? when}) =>
      WhitelistImpl._(
          _tags,
          (List.from(_attributes)
            ..add(Attribute(
                _toMatcher(tags), generator ?? _noOp, when ?? always))));

  @override
  String safeCopy(String contents) {
    return cleaner.safeCopy(parseFragment(contents)).outerHtml;
  }

  @override
  Cleaner get cleaner {
    return _cleaner ??= CleanerImpl(_tags, _attributes);
  }

  Matcher _toMatcher(dynamic matcher) {
    if (matcher is Matcher) {
      return matcher;
    }
    if (matcher is String) {
      return (s) => matcher == s;
    }
    if (matcher is Iterable) {
      var copy = List<dynamic>.from(matcher);
      for (var s in copy) {
        if (s is! String) {
          throw ArgumentError("unsupported type in iterable: ${s.runtimeType}");
        }
      }
      return copy.contains;
    }
    throw ArgumentError("unsupported type ${matcher.runtimeType}");
  }

  AttributeGenerator _attributeCopier(Matcher attributes, Filter when) =>
      (String tag, Map<String, String> originalAttributes,
          AttributeCollector collector) {
        originalAttributes.forEach((k, v) {
          if (attributes(k) && when(tag, originalAttributes)) {
            collector[k] = v;
          }
        });
      };
}
