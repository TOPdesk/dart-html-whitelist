// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/src/api/typedefs.dart';

class Extra {
  final Matcher _tags;
  final AttributeGenerator _generator;

  Extra(this._tags, this._generator);

  generate(String tag, Map<String, String> attributes, AddAttribute adder) {
    if (_tags(tag)) {
      _generator(tag, attributes, adder);
    }
  }
}
