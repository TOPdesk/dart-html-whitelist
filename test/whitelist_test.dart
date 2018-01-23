// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/htmlwhitelist.dart';
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
        expect(Whitelist.none.safeCopy(tooMuch), textContents);
      });
    });

    group('.simpleText', () {
      test('removes all illegal tags', () {
        expect(
            Whitelist.simpleText.safeCopy(tooMuch), simpleText + basicContents);
      });
    });

    group('.basic', () {
      test('removes all illegal tags', () {
        expect(
            Whitelist.basic.safeCopy(tooMuch), basic + basicWithImagesContents);
      });

      test(
          'blockquote copies `cite` for relative uris, '
          'and the schemes `http` and `https`', () {
        var ok = '<blockquote cite="cite">blockquote</blockquote>'
            '<blockquote cite="http://example.com">blockquote</blockquote>'
            '<blockquote cite="https://example.com">blockquote</blockquote>';
        expect(Whitelist.basic.safeCopy(ok), ok);
      });

      test('blockquote does not copy `cite` other schemes', () {
        expect(
            Whitelist.basic
                .safeCopy('<blockquote cite="ftp://example.com"></blockquote>'
                    '<blockquote cite="data:,"></blockquote>'
                    '<blockquote cite="javascript:alert(12)"></blockquote>'),
            '<blockquote></blockquote>'
            '<blockquote></blockquote>'
            '<blockquote></blockquote>');
      });

      test(
          'q copies `cite` for relative uris, '
          'and the schemes `http` and `https`', () {
        var ok = '<q cite="cite">q</q>'
            '<q cite="http://example.com">q</q>'
            '<q cite="https://example.com">q</q>';
        expect(Whitelist.basic.safeCopy(ok), ok);
      });

      test('q does not copy `cite` other schemes', () {
        expect(
            Whitelist.basic.safeCopy('<q cite="ftp://example.com"></q>'
                '<q cite="data:,"></q>'
                '<q cite="javascript:alert(12)"></q>'),
            '<q></q><q></q><q></q>');
      });

      test(
          'a copies `href` for relative uris, '
          'and the schemes `http` and `https`', () {
        var ok = '<a href="#href">a</a>'
            '<a href="http://example.com" rel="nofollow">a</a>'
            '<a href="https://example.com" rel="nofollow">a</a>';
        expect(Whitelist.basic.safeCopy(ok), ok);
      });

      test('a does not `href` other schemes', () {
        expect(
            Whitelist.basic.safeCopy('<a href="ftp://example.com"></a>'
                '<a href="data:,"></a>'
                '<a href="javascript:alert(12)"></a>'),
            '<a rel="nofollow"></a><a></a><a></a>');
      });

      test('a adds rel="nofollow" for external uris', () {
        var before = '<a href="https://example.com">Example</a>';
        var after = '<a href="https://example.com" rel="nofollow">Example</a>';
        expect(Whitelist.basic.safeCopy(before), after);
      });
    });

    group('.basicWithImages', () {
      test('removes all illegal tags', () {
        expect(Whitelist.basicWithImages.safeCopy(tooMuch),
            basicWithImages + tooMuchContents);
      });

      test(
          'img allows attributes `align`, `alt`, '
          '`height`, `src`, `title` and `width`', () {
        var ok = '<img src="https://example.com/favicon.ico" align="middle"'
            ' alt="Favicon" height="16" title="Example.com" width="16">';
        expect(Whitelist.basicWithImages.safeCopy(ok), ok);
      });

      test(
          'img copies `src` for relative uris, '
          'and the schemes `http`, `https` and `data`', () {
        var ok = '<img src="http://example.com/favicon.ico">'
            '<img src="https://example.com/favicon.ico">'
            '<img src="data:,">'
            '<img src="/foo">';
        expect(Whitelist.basicWithImages.safeCopy(ok), ok);
      });

      test('img does not copy `src` for other schemes', () {
        var test = '<img src="ftp://example.com/favicon.ico">'
            '<img src="about:config">'
            '<img src="javascript:alert(12)">';
        expect(Whitelist.basicWithImages.safeCopy(test), '<img><img><img>');
      });
    });

    group('.tags(dynamic tags)', () {
      test('accepts String', () {
        Whitelist.none.tags('');
      });

      test('accepts Matcher', () {
        Whitelist.none.tags((dynamic s) => false);
      });

      test('accepts empty Iterable', () {
        Whitelist.none.tags(<String>[]);
      });

      test('accepts Strings in Iterable', () {
        Whitelist.none.tags(['foo', 'bar']);
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

      test('rejects Matchers in Iterable', () {
        expect(
            () => Whitelist.none
                .tags([(dynamic s) => true, (dynamic s) => false]),
            throwsArgumentError);
      });

      test('rejects other types in Iterable', () {
        expect(() => Whitelist.none.tags(['foo', 1]), throwsArgumentError);
      });
    });

    group('.tags(dynamic tags, {Filter when})', () {
      test('when: `null` means no filter', () {
        expect(
            Whitelist.none.tags(['a', 'b'],
                when: null).safeCopy('<a>a</a><b>b</b><i>i</i>'),
            '<a>a</a><b>b</b>i');
      });
      test('when: filter uses filter', () {
        expect(
            Whitelist.none
                .tags(['a'], when: (t, a) => !a.containsKey('href')).safeCopy(
                    '<a>a</a><a href="#">href</a>'),
            '<a>a</a>href');
      });
      test('when: filter is only invoked if tag matches', () {
        expect(
            Whitelist.none.tags('a', when: (t, a) {
              if (t == 'b') throw new AssertionError();
              return true;
            }).safeCopy('<a>foo</a><b>bar</b>'),
            '<a>foo</a>bar');
      });
    });
    group('.attributes(dynamic tags, dynamic attributes)', () {
      var before = '<a id="a" href="foo">a</a><b id="b">b</b>';
      var base = Whitelist.none.tags(anyTag);

      test('copies a single attribute for single tag', () {
        expect(base.attributes('a', 'href').safeCopy(before),
            '<a href="foo">a</a><b>b</b>');
      });
      test('copies a single attribute for all tags', () {
        expect(base.attributes(anyTag, 'id').safeCopy(before),
            '<a id="a">a</a><b id="b">b</b>');
      });
      test('copies all attributes for a single tag', () {
        expect(base.attributes('a', anyAttribute).safeCopy(before),
            '<a id="a" href="foo">a</a><b>b</b>');
      });
      test('copies all attributes for all tags', () {
        expect(base.attributes(anyTag, anyAttribute).safeCopy(before), before);
      });
    });
    group('.attributes(dynamic tags, dynamic attributes, {Filter when})', () {
      test('when: `null` means no filter', () {
        expect(
            Whitelist.none
                .tags(anyTag)
                .attributes('a', 'href', when: null)
                .safeCopy('<a href="foo">a</a>'),
            '<a href="foo">a</a>');
      });
      test('when: filter uses filter', () {
        expect(
            Whitelist.none
                .tags(anyTag)
                .attributes('a', 'href',
                    when: (t, a) => a['href'].startsWith('f'))
                .safeCopy('<a href="foo">foo</a><a href="#">hash</a>'),
            '<a href="foo">foo</a><a>hash</a>');
      });
      test('when: filter is only invoked if tag matches', () {
        expect(
            Whitelist.none.tags(anyTag).attributes('a', anyAttribute,
                when: (t, a) {
              if (t == 'b') throw new AssertionError();
              return true;
            }).safeCopy('<a href="foo">foo</a><b href="bar">bar</b>'),
            '<a href="foo">foo</a><b>bar</b>');
      });
      test('when: filter is only invoked if attributes matches', () {
        expect(
            Whitelist.none
                .tags(anyTag)
                .attributes(anyTag, 'href',
                    when: (t, a) => a['href'].startsWith('f'))
                .safeCopy('<a href="foo">foo</a><a class="bar">bar</a>'),
            '<a href="foo">foo</a><a>bar</a>');
      });
    });
    group('.extraAttributes(dynamic tags, AttributeGenerator generator)', () {
      test('generates an attribute for a single tag', () {
        expect(
            Whitelist.none
                .tags(['a', 'b'])
                .extraAttributes('a', (t, o, c) => c['target'] = '_blank')
                .safeCopy('<a>a</a><b>b</b>'),
            '<a target="_blank">a</a><b>b</b>');
      });
      test('generates multiple attributes for a single tag', () {
        expect(
            Whitelist.none.tags(['a', 'b']).extraAttributes('a', (t, o, c) {
              c['target'] = '_blank';
              c['class'] = 'foo';
            }).safeCopy('<a>a</a><b>b</b>'),
            '<a target="_blank" class="foo">a</a><b>b</b>');
      });
      test('generates an attribute for all tags', () {
        expect(
            Whitelist.none
                .tags(['a', 'b'])
                .extraAttributes(anyTag, (t, o, c) => c['class'] = 'foo')
                .safeCopy('<a>a</a><b>b</b>'),
            '<a class="foo">a</a><b class="foo">b</b>');
      });
      test('overrides an existing attribute', () {
        expect(
            Whitelist.none
                .tags(['a', 'b'])
                .attributes(anyTag, 'target')
                .extraAttributes('a', (t, o, c) => c['target'] = 'bar')
                .safeCopy('<a target="foo">a</a><b target="foo">b</b>'),
            '<a target="bar">a</a><b target="foo">b</b>');
      });
      test('generator = `null` is accepted and does not generate anything', () {
        expect(
            Whitelist.none
                .tags(['a', 'b'])
                .extraAttributes('a', null)
                .safeCopy('<a>a</a><b>b</b>'),
            '<a>a</a><b>b</b>');
      });
      test('generator cannot modify the originalAttributes', () {
        expect(
            () => Whitelist.none
                .tags(['a'])
                .extraAttributes('a', (t, o, c) => o['foo'] = 'foo')
                .safeCopy('<a foo="bar">a</a>'),
            throwsUnsupportedError);
      });
      test('the originalAttributes are in source order', () {
        expect(
            Whitelist.none
                .tags(['a'])
                .extraAttributes(
                    anyTag, (t, o, c) => o.forEach((k, v) => c[k] = v))
                .safeCopy('<a b="b" a="a" f="f" c="c" e="e" d="d"></a>'),
            '<a b="b" a="a" f="f" c="c" e="e" d="d"></a>');
      });
    });
    group(
        '.extraAttributes(dynamic tags, AttributeGenerator generator,'
        ' {Filter when})', () {
      test('when: `null` means no filter', () {
        expect(
            Whitelist.none
                .tags(anyTag)
                .extraAttributes('a', (t, o, c) => c['target'] = 'bar',
                    when: null)
                .safeCopy('<a>a</a>'),
            '<a target="bar">a</a>');
      });
      test('when: filter uses filter', () {
        expect(
            Whitelist.none
                .tags(anyTag)
                .attributes(anyTag, anyAttribute)
                .extraAttributes('a', (t, o, c) => c['target'] = 'bar',
                    when: (t, a) => !a.containsKey('target'))
                .safeCopy('<a>a</a><a target="foo">b</a>'),
            '<a target="bar">a</a><a target="foo">b</a>');
      });
      test('when: filter is only invoked if tag matches', () {
        expect(
            Whitelist.none
                .tags(anyTag)
                .attributes(anyTag, anyAttribute)
                .extraAttributes('a', (t, o, c) => c['target'] = 'bar',
                    when: (t, a) {
              if (t == 'b') throw new AssertionError();
              return true;
            }).safeCopy('<a>a</a><b>b</b>'),
            '<a target="bar">a</a><b>b</b>');
      });
    });
  });
}
