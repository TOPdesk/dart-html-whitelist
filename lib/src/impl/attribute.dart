// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/htmlwhitelist.dart';

class Attribute {
  final Matcher _tags;
  final AttributeGenerator _generator;
  final Filter _when;

  Attribute(this._tags, this._generator, this._when);

  void generate(String tag, Map<String, String> attributes,
      AttributeCollector collector) {
    if (_tags(tag) && _when(tag, attributes)) {
      _generator(tag, attributes, collector);
    }
  }
}
