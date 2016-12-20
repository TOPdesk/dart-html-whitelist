// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/src/api/typedefs.dart';

class Attribute {
  final Matcher _tags;
  final Matcher _attributes;

  Attribute(this._tags, this._attributes);

  bool allowed(String tag, String attribute) =>
      _tags(tag) && _attributes(attribute);
}
