// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

import 'package:htmlwhitelist/htmlwhitelist.dart';

/// Allows [AttributeGenerator]s to modify the attributes of the tag that is
/// being added to the copy.
///
/// Typically, the generators use `collector['name'] = 'value';` to
/// set an attribute to a given value.
abstract class AttributeCollector {
  AttributeCollector._();

  /// Sets the attribute [name] to the given [value].
  ///
  /// If the attribute was already present, its value will be overwritten.
  ///
  /// Throws an [ArgumentError] if [name] or [value] is `null`.
  void operator []=(String name, String value);

  /// Sets the attribute [name] to the given [value] if it was not present.
  ///
  /// Throws an [ArgumentError] if [name] or [value] is `null`.
  void ifAbsent(String name, String value);

  /// Appends the [value] to the previous value of attribute [name].
  ///
  /// If the attribute was not present, it will just set the attribute [name] to
  /// [value]. Otherwise, it will use the [separator] to put between the
  /// previous value and [value].
  ///
  /// If [separator] is not specified or `null`, a single space will be
  /// used as separator.
  ///
  /// Throws an [ArgumentError] if [name] or [value] is `null`.
  void append(String name, String value, {String separator});

  /// Prepends the [value] to the previous value of attribute [name].
  ///
  /// If the attribute was not present, it will just set the attribute [name] to
  /// [value]. Otherwise, it will use the [separator] to put between [value]
  /// and the previous value.
  ///
  /// If [separator] is not specified or `null`, a single space will be
  /// used as separator.
  ///
  /// Throws an [ArgumentError] if [name] or [value] is `null`.
  void prepend(String name, String value, {String separator});

  /// Removes the attribute [name] if it was present.
  ///
  /// Throws an [ArgumentError] if [name] is `null`.
  void remove(String name);
}
