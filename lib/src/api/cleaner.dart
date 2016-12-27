// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:html/dom.dart';

/// Generates a [DocumentFragment] by applying the rules from the [Whitelist]
/// that created this cleaner to the [Node] given.
abstract class Cleaner {
  Cleaner._();

  /// Returns a new DocumentFragment that contains a copy of the [node] after
  /// applying the rules of the Whitelist that created this Cleaner.
  DocumentFragment safeCopy(Node node);
}
