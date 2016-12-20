// Copyright (c) 2016, TOPdesk. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

typedef bool Filter(String tag, Map<String, String> attributes);

typedef bool Matcher(String tag);

typedef void AttributeGenerator(
    String tag, Map<String, String> attributes, AddAttribute adder);

typedef void AddAttribute(String attribute, String value);

final Matcher anyTag = (t) => true;
final Matcher anyAttribute = (a) => true;
final Filter always = (t, a) => true;

final Matcher noMatcher = (t) => false;
final AttributeGenerator noOp = (t, a, g) {};

AttributeGenerator forceAttribute(String attribute, String value,
        {Filter when}) =>
    (t, a, g) {
      if ((when ?? always)(t, a)) g(attribute, value);
    };
