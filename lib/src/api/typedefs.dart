// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/htmlwhitelist.dart';

/// Returns `true` if the given [tag] and [attributes] are accepted.
///
/// [attributes] contains all attribute names and values of the source tag.
typedef Filter = bool Function(String tag, Map<String, String?> attributes);

/// Returns `true` if the given [name] matches.
typedef Matcher = bool Function(String name);

/// Uses the [collector] to generate attributes for the given [tag].
///
/// [originalAttributes] contains all attribute names and values in the source
/// tag. This makes it possible to create attributes and values based on
/// the original tag.
typedef AttributeGenerator = void Function(String tag,
    Map<String, String> originalAttributes, AttributeCollector collector);

/// Matches all tags.
bool anyTag(String name) => true;

/// Matches all attributes.
bool anyAttribute(String name) => true;

/// Always returns `true`.
bool always(String tag, Map<String, String?> attributes) => true;

/// Returns an AttributeGenerator that generates an attribute with the
/// given [name] and [value].
///
/// Example:
///
///     Whitelist.none
///         .tags('a')
///         .extraAttributes('a', setAttribute('target', '_blank'));
AttributeGenerator setAttribute(String name, String value) =>
    ((t, o, c) => c[name] = value);
