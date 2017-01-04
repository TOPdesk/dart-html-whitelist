// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/htmlwhitelist.dart';

class Uris {
  static final String _test1 = 'http://x.y/';
  static final String _test2 = 'ftp://y.x/';
  static final Uri _testUri1 = Uri.parse(_test1);
  static final Uri _testUri2 = Uri.parse(_test2);

  Uris._();

  static bool isRelative(String uri) =>
      _testUri1.resolve(uri).toString().startsWith(_test1) &&
      _testUri2.resolve(uri).toString().startsWith(_test2);

  static bool isValid(String uri) {
    try {
      Uri.parse(uri);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Filter hasAllowedScheme(String attribute, Iterable<String> schemes) =>
      (t, o) {
        var uri = o[attribute];
        if (uri == null || !isValid(uri)) {
          return false;
        }
        var scheme = Uri.parse(uri).scheme;
        return scheme.isEmpty || schemes.contains(scheme);
      };

  static Filter external(String attribute, {Iterable<String> allowed}) =>
      (t, o) {
        var uri = o[attribute];
        if (uri == null) return false;
        if (!isValid(uri)) return true;
        if (isRelative(uri)) return false;
        if (['data', 'javascript'].contains(Uri.parse(uri).scheme))
          return false;
        if (allowed == null) return true;
        return !allowed
            .any((a) => Uri.parse(a).resolve(uri).toString().startsWith(a));
      };
}
