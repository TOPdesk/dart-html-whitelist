// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/src/api/cleaner.dart';
import 'package:htmlwhitelist/src/api/typedefs.dart';
import 'package:htmlwhitelist/src/impl/whitelistimpl.dart';

abstract class Whitelist {
  static final Whitelist none = new WhitelistImpl();

  static final Whitelist simpleText =
      none.tags(['b', 'em', 'i', 'strong', 'u']);

  static final Whitelist basic = simpleText
      .tags([
        'a',
        'blockquote',
        'br',
        'cite',
        'code',
        'dd',
        'dl',
        'dt',
        'li',
        'ol',
        'p',
        'pre',
        'q',
        'small',
        'span',
        'strike',
        'sub',
        'sup',
        'ul'
      ])
      .attributes(['blockquote', 'q'], 'cite')
      .attributes('a', 'href')
      .extraAttributes(
          'a',
          forceAttribute('rel', 'nofollow', when: (t, a) {
            var href = a['href'];
            return href != null && !href.startsWith('#');
          }));

  static final Whitelist basicWithImages = basic
      .tags('img')
      .attributes('img', ['align', 'alt', 'height', 'src', 'title', 'width']);

  Whitelist tags(dynamic tags);

  Whitelist attributes(dynamic tags, dynamic attributes);

  Whitelist extraAttributes(dynamic tags, AttributeGenerator generator);

  Cleaner cleaner();
}
