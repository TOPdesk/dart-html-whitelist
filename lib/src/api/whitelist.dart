// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/htmlwhitelist.dart';

import '../impl/whitelistimpl.dart';

/// Defines the rules for what tags, attribute names and attribute values
/// are allowed in a piece of HTML.
abstract class Whitelist {
  /// No tags allowed, only text nodes.
  static final Whitelist none = WhitelistImpl.none;

  /// Allow only simple text tags.
  ///
  /// The following tags are allowed:
  /// `b`, `em`, `i`, `strong` and `u`.
  static final Whitelist simpleText =
      none.tags(['b', 'em', 'i', 'strong', 'u']);

  /// Allow only basic text tags.
  ///
  /// The following tags are allowed: `a`, `b`, `blockquote`, `br`,
  /// `cite`, `code`, `em`, `dd`, `dl`, `dt`, `i`, `kbd`, `li`, `ol`, `p`,
  /// `pre`, `q`, `samp`, `small`, `span`, `strike`, `strong`, `sub`, `sup`,
  /// `u`, `ul` and `var`.
  ///
  /// `blockquote` and `q` allow the `cite` attribute if it contains a valid
  /// <i>uri</i> and its scheme is blank, `http` or `https`.
  ///
  /// `a` allows the `href` attribute  if it contains a valid
  /// <i>uri</i> and its scheme is blank, `http` or `https`.
  ///
  /// In `a` the attribute `rel="nofollow"` will be added for `href` values
  /// that point to external pages. See [Uris.external] for more details.
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
      .attributes(['blockquote', 'q'], 'cite',
          when: Uris.hasAllowedScheme('cite', ['http', 'https']))
      .attributes('a', 'href',
          when: Uris.hasAllowedScheme('href', ['http', 'https']))
      .extraAttributes('a', setAttribute('rel', 'nofollow'),
          when: Uris.external('href'));

  /// Allow only basic text tags and the image tag.
  ///
  /// In addition to the tags from [basic], the `img` tag is also
  /// allowed.
  ///
  /// Allowed attributes for the `img` tag are: `align`, `alt`, `height`,
  /// `title` and `width`.
  ///
  /// `img` allows the `src` attribute  if it contains a valid
  /// <i>uri</i> and its scheme is blank, `http`, `https` or `data`.

  static final Whitelist basicWithImages = basic
      .tags('img')
      .attributes('img', 'src',
          when: Uris.hasAllowedScheme('src', ['http', 'https', 'data']))
      .attributes('img', ['align', 'alt', 'height', 'title', 'width']);

  Whitelist._();

  /// Creates a new Whitelist with additional allowed [tags].
  ///
  /// The [tags] can be one of the following types:
  ///
  /// - [String] containing a tag name;
  /// - [Iterable<String>] containing tag names;
  /// - [Matcher].
  ///
  /// If [when] is provided, the tag will only be allowed if [when]
  /// applies. Only if [tags] matches will [when] be invoked.
  Whitelist tags(dynamic tags, {Filter when});

  /// Creates a new Whitelist with additional allowed [attributes] for the
  /// given [tags] that will be copied from the source.
  ///
  /// The [tags] and [attributes] can be one of the following types:
  ///
  /// - [String] containing a tag name or attribute name;
  /// - [Iterable<String>] containing tag names or attribute names;
  /// - [Matcher].
  ///
  /// If [when] is provided, the attribute will only be copied if [when]
  /// applies. Only if both [tags] and [attributes] match will
  /// [when] be invoked.
  Whitelist attributes(dynamic tags, dynamic attributes, {Filter when});

  /// Creates a new Whitelist with generated attributes for the
  /// given [tags].
  ///
  /// The [tags] can be one of the following types:
  ///
  /// - [String] containing a tag name;
  /// - [Iterable<String>]  containing tag names;
  /// - [Matcher].
  ///
  /// For each tag that matches [tags], the [generator] will be invoked to
  /// generate new attributes if necessary.
  ///
  /// If [when] is provided, the generator will only be invoked if [when]
  /// applies. Only if [tags] matches will [when] be invoked.
  Whitelist extraAttributes(dynamic tags, AttributeGenerator generator,
      {Filter when});

  /// Returns a safe copy of the [contents] after
  /// applying the rules of this Whitelist.
  String safeCopy(String contents);

  /// Returns a Cleaner that applies the rules of this Whitelist
  /// on DocumentFragments
  Cleaner get cleaner;
}
