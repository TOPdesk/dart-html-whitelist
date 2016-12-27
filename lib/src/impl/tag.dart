// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/src/api/typedefs.dart';

class Tag {
  final Matcher _matcher;
  final Filter _when;

  Tag(this._matcher, this._when);

  bool allowed(String tag, Map<String, String> attributes) =>
      _matcher(tag) && _when(tag, attributes);
}
