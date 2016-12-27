Html Whitelist
============

* [Introduction](#introduction)
* [Usage](#usage)
* [License and contributors](#license-and-contributors)

Introduction
------------

This library can be used to whitelist html elements, attributes and attribute values.  

Usage
------------

```Dart
import 'package:htmlwhitelist/htmlwhitelist.dart';

main() {
  var contents = '<b>See:</b> <a href="docs.html">the documentation</a>';
  var safe = Whitelist.simpleText.safeCopy(contents);
  print(safe);
}
```

prints

```Shell
<b>See:</b> the documentation
```

If you have a DocumentFragment instead of a String you can use the Cleaner instead:

```Dart
import 'package:htmlwhitelist/htmlwhitelist.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

main() {
  var contents = '<b>See:</b> <a href="docs.html">the documentation</a>';

  DocumentFragment fragment = parseFragment(contents);
  DocumentFragment safeCopy = Whitelist.simpleText.cleaner.safeCopy(fragment);

  print(safeCopy.outerHtml);
}
```

prints

```Shell
<b>See:</b> the documentation
```

License and contributors
------------------------

* The MIT License, see [LICENSE](https://github.com/TOPdesk/dart-html-whitelist/raw/master/LICENSE).
* For contributors, see [AUTHORS](https://github.com/TOPdesk/dart-html-whitelist/raw/master/AUTHORS).