// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:html/dom.dart';
import 'package:htmlwhitelist/src/impl/collector.dart';
import 'package:test/test.dart';

void main() {
  group('Collector', () {
    Collector a() => Collector();

    String string(Collector a) =>
        a.fill(Document().createElement('x')).outerHtml;

    group('[]=(String name, String value)', () {
      test('sets a normal attribute', () {
        expect(string(a()..['foo'] = 'bar'), '<x foo="bar"></x>');
      });

      test('can set a multiple attributes', () {
        expect(
            string(a()
              ..['foo'] = 'bar'
              ..['bar'] = 'foo'),
            '<x foo="bar" bar="foo"></x>');
      });

      test('uses the latest value', () {
        expect(
            string(a()
              ..['foo'] = 'bar'
              ..['foo'] = 'foo'),
            '<x foo="foo"></x>');
      });
    });

    group('ifAbsent(String name, String value)', () {
      test('sets a normal attribute if it is missing', () {
        expect(string(a()..ifAbsent('foo', 'bar')), '<x foo="bar"></x>');
      });

      test('does not add a an attributes if present', () {
        expect(
            string(a()
              ..['foo'] = 'bar'
              ..ifAbsent('foo', 'foo')),
            '<x foo="bar"></x>');
      });

      test('works only once per attribute', () {
        expect(
            string(a()
              ..ifAbsent('foo', 'bar')
              ..ifAbsent('foo', 'foo')),
            '<x foo="bar"></x>');
      });
    });

    group('append(String name, String value)', () {
      test('sets a normal attribute if it is missing', () {
        expect(string(a()..append('foo', 'bar')), '<x foo="bar"></x>');
      });

      test('appends the value if the attribute is present', () {
        expect(
            string(a()
              ..['foo'] = 'bar'
              ..append('foo', 'foo')),
            '<x foo="bar foo"></x>');
      });

      test('works multiple times', () {
        expect(
            string(a()
              ..['foo'] = 'bar'
              ..append('foo', 'foo')
              ..append('foo', 'foo')),
            '<x foo="bar foo foo"></x>');
      });
    });

    group('append(String name, String value, {String separator})', () {
      test('does not use the separator if the attribute is missing', () {
        expect(string(a()..append('foo', 'bar', separator: '--')),
            '<x foo="bar"></x>');
      });

      test('uses the separator if the attribute is present', () {
        expect(
            string(a()
              ..['foo'] = 'bar'
              ..append('foo', 'foo', separator: '--')),
            '<x foo="bar--foo"></x>');
      });

      test('uses \' \' ` if the separator is `null`', () {
        expect(
            string(a()
              ..['foo'] = 'bar'
              ..append('foo', 'foo', separator: null)),
            '<x foo="bar foo"></x>');
      });
    });

    group('prepend(String name, String value)', () {
      test('sets a normal attribute if it is missing', () {
        expect(string(a()..prepend('foo', 'bar')), '<x foo="bar"></x>');
      });

      test('prepends the value if the attribute is present', () {
        expect(
            string(a()
              ..['foo'] = 'bar'
              ..prepend('foo', 'foo')),
            '<x foo="foo bar"></x>');
      });

      test('works multiple times', () {
        expect(
            string(a()
              ..['foo'] = 'bar'
              ..prepend('foo', 'foo')
              ..prepend('foo', 'foo')),
            '<x foo="foo foo bar"></x>');
      });
    });

    group('prepend(String name, String value, {String separator})', () {
      test('does not use the separator if the attribute is missing', () {
        expect(string(a()..prepend('foo', 'bar', separator: '--')),
            '<x foo="bar"></x>');
      });

      test('uses the separator if the attribute is present', () {
        expect(
            string(a()
              ..['foo'] = 'bar'
              ..prepend('foo', 'foo', separator: '--')),
            '<x foo="foo--bar"></x>');
      });

      test('uses \' \' ` if the separator is `null`', () {
        expect(
            string(a()
              ..['foo'] = 'bar'
              ..prepend('foo', 'foo', separator: null)),
            '<x foo="foo bar"></x>');
      });
    });

    group('remove(String name)', () {
      test('is a no-op if it is missing', () {
        expect(string(a()..remove('foo')), '<x></x>');
      });

      test('removes the attribute if it is present', () {
        expect(
            string(a()
              ..['foo'] = 'bar'
              ..remove('foo')),
            '<x></x>');
      });

      test('leaves other attributes the way they are', () {
        expect(
            string(a()
              ..['foo'] = 'bar'
              ..['bar'] = 'foo'
              ..remove('bar')),
            '<x foo="bar"></x>');
      });
    });

    group('fill(Element element))', () {
      test('maintains the addition order', () {
        expect(
            string(a()
              ..['b'] = 'b'
              ..['a'] = 'a'
              ..ifAbsent('c', 'c')
              ..append('d', 'd')
              ..prepend('e', 'e')
              ..['g'] = 'g'
              ..['f'] = 'f'
              ..remove('g')
              ..['g'] = 'g'
              ..append('d', 'd', separator: '.')),
            '<x b="b" a="a" c="c" d="d.d" e="e" f="f" g="g"></x>');
      });
    });
  });
}
