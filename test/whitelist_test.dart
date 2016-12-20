// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/htmlwhitelist.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:test/test.dart';

void main() {
  group('Whitelist', () {
    DocumentFragment fragment;

    setUp(() {
      fragment = parseFragment('<H1>Title</H1>'
          '<p><b class="foo">bold</b>and <i foo="bar">'
          ' italic </i><strike>removed</strike>'
          '<a href="#hi" rel="foo">jump</a>'
          '<a href="http://google.com">link</a></p>more test');
    });

    test('.none removes all tags', () {
      expect(Whitelist.none.cleaner().safeCopy(fragment).outerHtml,
          'Titleboldand  italic removedjumplinkmore test');
    });

    test('.simpleText removes all complicated tags', () {
      expect(Whitelist.simpleText.cleaner().safeCopy(fragment).outerHtml,
          'Title<b>bold</b>and <i> italic </i>removedjumplinkmore test');
    });

    test('.basic removes all complicated tags', () {
      expect(
          Whitelist.basic.cleaner().safeCopy(fragment).outerHtml,
          'Title<p><b>bold</b>and <i> italic </i><strike>removed</strike>'
          '<a href="#hi">jump</a><a href="http://google.com" rel="nofollow">'
          'link</a></p>more test');
    });
  });
}
