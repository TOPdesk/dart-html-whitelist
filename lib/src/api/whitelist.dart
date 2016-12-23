// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:html/dom.dart';
import 'package:htmlwhitelist/src/api/typedefs.dart';
import 'package:htmlwhitelist/src/impl/whitelistimpl.dart';

abstract class Whitelist {
  /// No tags allowed, only text nodes.
  static final Whitelist none = WhitelistImpl.none;

  /// Allow only simple text tags.
  ///
  /// The following tags are allowed:
  /// `b`, `em`, `i`, `strong` and `u`.
  static final Whitelist simpleText =
      none.tags(['b', 'em', 'i', 'strong', 'u']);

  /// Allow only basic tags.
  ///
  /// The following tags are allowed: `a`, `b`, `blockquote`, `br`,
  /// `cite`, `code`, `em`, `dd`, `dl`, `dt`, `i`, `kbd`, `li`, `ol`, `p`,
  /// `pre`, `q`, `samp`, `small`, `span`, `strike`, `strong`, `sub`, `sup`,
  /// `u`, `ul` and `var`.
  ///
  /// `blockquote` and `q` allow the `cite` attribute.
  ///
  /// `a` allows the `href` attribute, and will add `rel="nofollow"` for
  /// href values that do not start with a `#` symbol.
  static final Whitelist basic = none
      .tags([
        'a',
        'b',
        'blockquote',
        'br',
        'cite',
        'code',
        'em',
        'dd',
        'dl',
        'dt',
        'i',
        'kbd',
        'li',
        'ol',
        'p',
        'pre',
        'q',
        'samp',
        'small',
        'span',
        'strike',
        'strong',
        'sub',
        'sup',
        'u',
        'ul',
        'var',
      ])
      .attributes(['blockquote', 'q'], 'cite')
      .attributes('a', 'href')
      .extraAttributes('a', forceAttribute('rel', 'nofollow'), when: (t, a) {
        var href = a['href'];
        return href != null && !href.startsWith('#');
      });

  /// Allow only basic text tags and the image tag.
  ///
  /// In addition to the tags from [basic], the `img` tag is also
  /// allowed.
  ///
  /// Allowed attributes for the `img` tag are: `align`, `alt`, `height`,
  /// `src`, `title` and `width`.
  static final Whitelist basicWithImages = basic
      .tags('img')
      .attributes('img', ['align', 'alt', 'height', 'src', 'title', 'width']);

  Whitelist._();

  /// Creates a new Whitelist with additional allowed [tags].
  ///
  /// The [tags] can be one of the following types:
  ///
  /// - a [String] containing a tag name;
  /// - a [Matcher];
  /// - an [Iterable] that contains Strings or Matchers.
  Whitelist tags(dynamic tags);

  /// Creates a new Whitelist with additional allowed [attributes] for the
  /// given [tags].
  ///
  /// The [tags] and [attributes] can be one of the following types:
  ///
  /// - a [String] containing a tag name;
  /// - a [Matcher];
  /// - an [Iterable] that contains Strings or Matchers.
  Whitelist attributes(dynamic tags, dynamic attributes);

  /// Creates a new Whitelist with generated attributes for the
  /// given [tags].
  ///
  /// The [tags] can be one of the following types:
  ///
  /// - a [String] containing a tag name;
  /// - a [Matcher];
  /// - an [Iterable] that contains Strings or Matchers.
  ///
  /// For each tag that matches [tags], the [generator] will be invoked to
  /// generate new attributes if necessary.
  ///
  /// If [when] is provided, the generator will only be invoked if [wnen]
  /// applies.
  Whitelist extraAttributes(dynamic tags, AttributeGenerator generator,
      {Filter when});

  /// Returns a new DocumentFragment that contains a copy of the [node] after
  /// applying the rules of this Whitelist.
  DocumentFragment safeCopy(Node node);
}
