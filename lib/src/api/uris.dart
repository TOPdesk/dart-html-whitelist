// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/htmlwhitelist.dart';

/// Contains some utility functions to inspect uris.
class Uris {
  Uris._();

  static final String _test1 = 'http://x.y/';
  static final String _test2 = 'ftp://y.x/';
  static final Uri _testUri1 = Uri.parse(_test1);
  static final Uri _testUri2 = Uri.parse(_test2);

  /// Returns `true` if [uri] contains a relative path.
  ///
  /// A path is relative when, if it gets resolved by a different path,
  /// remains on the same scheme and server.
  ///
  /// Examples of relative uris:
  ///
  /// - `document`
  /// - `/document`
  /// - `#fragment`
  ///
  /// Examples of non-relative paths:
  ///
  /// - `http://example.com`
  /// - `//example.com`
  static bool isRelative(String uri) =>
      _testUri1.resolve(uri).toString().startsWith(_test1) &&
      _testUri2.resolve(uri).toString().startsWith(_test2);

  /// Returns `true` if [uri] contains a valid uri.
  static bool isValid(String uri) {
    try {
      Uri.parse(uri);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Returns a Filter that can test if the path in [attribute] has one of
  /// the [schemes].
  ///
  /// The Filter will only return `true` if:
  ///
  /// - the [attribute] exists;
  /// - contains a non-null value;
  /// - that is a valid uri;
  /// - and the scheme of that uri is blank or listed in [schemes].
  static Filter hasAllowedScheme(String attribute, Iterable<String> schemes) {
    var allowed = List<String>.from(schemes);
    return (t, o) {
      var uri = o[attribute];
      if (uri == null || !isValid(uri)) {
        return false;
      }
      var scheme = Uri.parse(uri).scheme;
      return scheme.isEmpty || allowed.contains(scheme);
    };
  }

  /// Returns a Filter that can test if the path in [attribute] is external to
  /// all of the [allowed] uris.
  ///
  /// The Filter return `true` if the uri in [attribute] is invalid or external
  /// to all of the uris in [allowed].
  ///
  /// The Filter returns `false` for any of the following conditions:
  /// - the [attribute] is missing;
  /// - the uri is `null`;
  /// - the uri is relative to all uris;
  /// - the scheme in the uri is `data` or `javascript`;
  /// - when the uri is resolved from any of the [allowed] uris, its path starts
  ///   with that allowed uri.

  static Filter external(String attribute, {Iterable<String>? allowed}) {
    var allowedUris =
        allowed == null ? const <String>[] : List<String>.from(allowed);
    return (t, o) {
      var uri = o[attribute];
      if (uri == null) return false;
      if (!isValid(uri)) return true;
      if (isRelative(uri) ||
          ['data', 'javascript'].contains(Uri.parse(uri).scheme)) {
        return false;
      }
      return !allowedUris
          .any((a) => Uri.parse(a).resolve(uri).toString().startsWith(a));
    };
  }
}
