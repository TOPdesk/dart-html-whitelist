// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/htmlwhitelist.dart';

class Tag {
  Tag(this._matcher, this._when);

  final Matcher _matcher;
  final Filter _when;

  bool allowed(String tag, Map<String, String> attributes) =>
      _matcher(tag) && _when(tag, attributes);
}
