// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/htmlwhitelist.dart';
import 'package:html/parser.dart';
import 'package:test/test.dart';

void main() {
  final simpleText = ' <b>b</b><em>em</em><i>i</i>'
      '<strong>strong</strong><u>u</u> ';

  final basic = simpleText +
      ' <a href="#">a</a><blockquote>blockquote</blockquote><br>'
      '<cite>cite</cite><code>code</code><dl><dt>dt</dt><dd>dd</dd></dl>'
      '<kbd>kbd</kbd><ol><li>olli</li></ol><p>p</p><pre>pre</pre><q>q</q>'
      '<samp>samp</samp><small>small</small><span>span</span>'
      '<strike>strike</strike><sub>sub</sub><sup>sup</sup>'
      '<ul><li>ulli</li></ul><var>var</var> ';

  final basicWithImages = basic + ' <img> ';

  final tooMuch = basicWithImages + ' <script>script</script> ';

  final tooMuchContents = ' script ';

  final basicWithImagesContents = '  ' + tooMuchContents;

  final basicContents = ' ablockquotecitecodedtddkbdollippreqsamp'
      'smallspanstrikesubsupullivar ' +
      basicWithImagesContents;

  final textContents = ' bemistrongu ' + basicContents;

  group('Whitelist', () {
    group('.none', () {
      test('removes all tags', () {
        var test = parseFragment(tooMuch);
        expect(Whitelist.none.safeCopy(test).outerHtml, textContents);
      });
    });

    group('.simpleText', () {
      test('removes all illegal tags', () {
        var test = parseFragment(tooMuch);
        expect(Whitelist.simpleText.safeCopy(test).outerHtml,
            simpleText + basicContents);
      });
    });

    group('.basic', () {
      test('removes all illegal tags', () {
        var test = parseFragment(tooMuch);
        expect(Whitelist.basic.safeCopy(test).outerHtml,
            basic + basicWithImagesContents);
      });

      test('blockquote allows cite attribute', () {
        var ok = '<blockquote cite="cite">blockquote</blockquote>';
        var test = parseFragment(ok);
        expect(Whitelist.basic.safeCopy(test).outerHtml, ok);
      });

      test('q allows cite attribute', () {
        var ok = '<q cite="cite">q</q>';
        var test = parseFragment(ok);
        expect(Whitelist.basic.safeCopy(test).outerHtml, ok);
      });

      test('a allows attribute `href`', () {
        var ok = '<a href="#href">a</a>';
        var test = parseFragment(ok);
        expect(Whitelist.basic.safeCopy(test).outerHtml, ok);
      });

      test('a adds rel="nofollow" for non-fragment urls', () {
        var before = '<a href="https://example.com">Example</a>';
        var after = '<a href="https://example.com" rel="nofollow">Example</a>';
        var test = parseFragment(before);
        expect(Whitelist.basic.safeCopy(test).outerHtml, after);
      });
    });

    group('.basicWithImages', () {
      test('removes all illegal tags', () {
        var test = parseFragment(tooMuch);
        expect(Whitelist.basicWithImages.safeCopy(test).outerHtml,
            basicWithImages + tooMuchContents);
      });

      test(
          'img allows attributes `align`, `alt`, '
          '`height`, `src`, `title` and `width`', () {
        var ok = '<img src="https://example.com/favicon.ico" align="middle"'
            ' alt="Favicon" height="16" title="Example.com" width="16">';
        var test = parseFragment(ok);
        expect(Whitelist.basicWithImages.safeCopy(test).outerHtml, ok);
      });
    });

    group('.tags(dynamic tags)', () {
      test('accepts String', () {
        Whitelist.none.tags('');
      });

      test('accepts Matcher', () {
        Whitelist.none.tags((s) => false);
      });

      test('accepts empty Iterable', () {
        Whitelist.none.tags([]);
      });

      test('accepts Strings in Iterable', () {
        Whitelist.none.tags(['foo', 'bar']);
      });

      test('accepts Matchers in Iterable', () {
        Whitelist.none.tags([(s) => true, (s) => false]);
      });

      test('accepts Strings and Matchers in Iterable', () {
        Whitelist.none.tags([(s) => true, 'foo', (s) => false, 'bar']);
      });

      test('rejects `null`', () {
        expect(() => Whitelist.none.tags(null), throwsArgumentError);
      });

      test('rejects other types', () {
        expect(() => Whitelist.none.tags(1), throwsArgumentError);
      });

      test('rejects `null` in Iterable', () {
        expect(() => Whitelist.none.tags([null]), throwsArgumentError);
      });

      test('rejects other types in Iterable', () {
        expect(() => Whitelist.none.tags(['foo', 1]), throwsArgumentError);
      });
    });
  });
}
