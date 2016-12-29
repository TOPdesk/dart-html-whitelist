// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:html/dom.dart';
import 'package:htmlwhitelist/htmlwhitelist.dart';

class Collector implements AttributeCollector {
  final Map<String, String> _values = {};

  @override
  void operator []=(String name, String value) {
    _checkNameAndValue(name, value);
    _values[name] = value;
  }

  @override
  void ifAbsent(String name, String value) {
    _checkNameAndValue(name, value);
    _values.putIfAbsent(name, () => value);
  }

  @override
  void append(String name, String value, {String separator}) {
    _checkNameAndValue(name, value);
    var previous = _values[name];
    if (previous == null) {
      _values[name] = value;
    } else {
      _values[name] = previous + (separator ?? ' ') + value;
    }
  }

  @override
  void prepend(String name, String value, {String separator}) {
    _checkNameAndValue(name, value);
    var previous = _values[name];
    if (previous == null) {
      _values[name] = value;
    } else {
      _values[name] = value + (separator ?? ' ') + previous;
    }
  }

  @override
  void remove(String name) {
    _checkNameAndValue(name, '');
    _values.remove(name);
  }

  Element fill(Element element) {
    element.attributes.addAll(_values);
    return element;
  }

  _checkNameAndValue(String name, String value) {
    if (identical(name, null)) {
      throw new ArgumentError('null name');
    }
    if (identical(value, null)) {
      throw new ArgumentError('null value');
    }
  }
}
