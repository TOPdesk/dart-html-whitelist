// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/htmlwhitelist.dart';

/// Returns `true` if the given [tag] and [attributes] are accepted.
///
/// [attributes] contains all attribute names and values of the source tag.
typedef bool Filter(String tag, Map<String, String?> attributes);

/// Returns `true` if the given [name] matches.
typedef bool Matcher(String name);

/// Uses the [collector] to generate attributes for the given [tag].
///
/// [originalAttributes] contains all attribute names and values in the source
/// tag. This makes it possible to create attributes and values based on
/// the original tag.
typedef void AttributeGenerator(String tag,
    Map<String, String> originalAttributes, AttributeCollector collector);

/// Matches all tags.
final Matcher anyTag = (t) => true;

/// Matches all attributes.
final Matcher anyAttribute = (a) => true;

/// Always returns `true`.
final Filter always = (t, a) => true;

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
