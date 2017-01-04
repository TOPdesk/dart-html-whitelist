// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/htmlwhitelist.dart';
import 'package:test/test.dart';

void main() {
  group('Uris', () {
    group('isRelative(String uri)', () {
      test('returns true for ``', () {
        expect(Uris.isRelative(''), true);
      });

      test('returns true for `foo`', () {
        expect(Uris.isRelative('foo'), true);
      });

      test('returns true for `/`', () {
        expect(Uris.isRelative('/'), true);
      });

      test('returns true for `/foo`', () {
        expect(Uris.isRelative('/foo'), true);
      });

      test('returns true for `/..`', () {
        expect(Uris.isRelative('/..'), true);
      });

      test('returns true for `#`', () {
        expect(Uris.isRelative('#'), true);
      });

      test('returns true for `#foo`', () {
        expect(Uris.isRelative('#foo'), true);
      });

      test('returns true for `?`', () {
        expect(Uris.isRelative('?'), true);
      });

      test('returns true for `?foo`', () {
        expect(Uris.isRelative('?foo'), true);
      });

      test('returns true for `.`', () {
        expect(Uris.isRelative('.'), true);
      });

      test('returns true for `./`', () {
        expect(Uris.isRelative('./'), true);
      });

      test('returns true for `..`', () {
        expect(Uris.isRelative('..'), true);
      });

      test('returns true for `../`', () {
        expect(Uris.isRelative('../'), true);
      });

      test('returns true for `\\`', () {
        expect(Uris.isRelative('\\'), true);
      });

      test('returns false for `javascript:alert(12)`', () {
        expect(Uris.isRelative('javascript:alert(12)'), false);
      });

      test('returns false for `http://example.com`', () {
        expect(Uris.isRelative('http://example.com'), false);
      });

      test('returns false for `https://127.0.0.1`', () {
        expect(Uris.isRelative('https://127.0.0.1'), false);
      });

      test('returns false for `//example.com`', () {
        expect(Uris.isRelative('//example.com'), false);
      });
    });

    group('isValue(String uri)', () {
      test('returns true for valid uris', () {
        expect(Uris.isValid('http://example.com'), true);
        expect(Uris.isValid('data:,Hello'), true);
        expect(Uris.isValid('/'), true);
        expect(Uris.isValid('//'), true);
        expect(Uris.isValid('?'), true);
        expect(Uris.isValid('.'), true);
        expect(Uris.isValid('..'), true);
        expect(Uris.isValid('...'), true);
        expect(Uris.isValid('#'), true);
        expect(Uris.isValid('a'), true);
        expect(Uris.isValid('http:[::1]'), true);
        expect(Uris.isValid('http:127.1:80'), true);
        expect(Uris.isValid('http://?'), true);
      });

      test('returns false for invalid uris', () {
        expect(Uris.isValid('[::1]'), false);
        expect(Uris.isValid('127.1:80'), false);
        expect(Uris.isValid(':foo'), false);
        expect(Uris.isValid('data:'), false);
      });
    });

    group('hasAllowedScheme(String attribute, Iterable<String> schemes)', () {
      test('returns true for allowed scheme', () {
        expect(
            Uris.hasAllowedScheme('href', ['http'])(
                'a', {'href': 'http://example.com'}),
            true);
      });

      test('returns true for allowed schemes', () {
        expect(
            Uris.hasAllowedScheme('href', ['http', 'https'])(
                'a', {'href': 'http://example.com'}),
            true);
        expect(
            Uris.hasAllowedScheme('href', ['http', 'https'])(
                'a', {'href': 'https://example.com'}),
            true);
      });

      test('returns true for empty scheme in attribute', () {
        expect(
            Uris.hasAllowedScheme('href', ['http'])(
                'a', {'href': '//example.com'}),
            true);
      });

      test('returns true for empty scheme', () {
        expect(
            Uris.hasAllowedScheme('href', [''])('a', {'href': '//example.com'}),
            true);
      });

      test('returns true for empty schemes and relative uri in attribute', () {
        expect(
            Uris.hasAllowedScheme('href', [])('a', {'href': '//example.com'}),
            true);
      });

      test('returns false for missing attribute', () {
        expect(Uris.hasAllowedScheme('href', ['http'])('a', {}), false);
      });

      test('returns false for null in attribute', () {
        expect(Uris.hasAllowedScheme('href', ['http'])('a', {'href': null}),
            false);
      });

      test('returns false for invalid uri in attribute', () {
        expect(
            Uris.hasAllowedScheme('href', ['http'])('a', {'href': '127.1:80'}),
            false);
      });

      test('returns false for wrong schemes', () {
        expect(
            Uris.hasAllowedScheme('href', ['http'])(
                'a', {'href': 'https://example.com'}),
            false);
      });

      test('returns false for empty scheme list and scheme in attribute', () {
        expect(
            Uris.hasAllowedScheme('href', [])(
                'a', {'href': 'http://example.com'}),
            false);
      });
    });

    group('external(String attribute)', () {
      test('returns false for missing attribute', () {
        expect(Uris.external('href')('a', {}), false);
      });

      test('returns false for null attribute', () {
        expect(Uris.external('href')('a', {'href': null}), false);
      });

      test('returns false for relative attribute', () {
        expect(Uris.external('href')('a', {'href': '/foo'}), false);
      });

      test('returns false for `data` scheme in attribute', () {
        expect(Uris.external('href')('a', {'href': 'data:,'}), false);
      });

      test('returns false for `javascript` scheme in attribute', () {
        expect(Uris.external('href')('a', {'href': 'javascript:alert(12)'}),
            false);
      });

      test('returns true for absolute attribute', () {
        expect(
            Uris.external('href')('a', {'href': 'http://example.com'}), true);
      });

      test('returns true for invalid attribute', () {
        expect(Uris.external('href')('a', {'href': '[::1]'}), true);
      });
    });

    group('external(String attribute, {Iterable<String> allowed})', () {
      test('returns true for empty list and absolute attribute', () {
        expect(
            Uris.external('href', allowed: [])('a', {'href': '//foo'}), true);
      });

      test('returns true for unallowed attribute', () {
        expect(
            Uris.external('href', allowed: ['http://example.com'])(
                'a', {'href': 'http://foo.com'}),
            true);
        print(Uri.parse('http://example.com').resolve('//foo'));
      });

      test('returns false for allowed attribute', () {
        expect(
            Uris.external('href', allowed: ['http://example.com'])(
                'a', {'href': 'http://example.com/foo'}),
            false);
      });

      test('returns false for multiple allowed attribute', () {
        expect(
            Uris.external('href', allowed: [
              'http://example.com',
              'ftp://foo.bar'
            ])('a', {'href': 'http://example.com/foo'}),
            false);
        expect(
            Uris.external('href', allowed: [
              'http://example.com',
              'ftp://foo.bar'
            ])('a', {'href': 'ftp://foo.bar/foo'}),
            false);
      });
    });
  });
}
