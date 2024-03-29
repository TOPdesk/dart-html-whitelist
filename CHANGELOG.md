## 1.0.0
* null-safety
* update dependency:
  * html ^0.15.0

## 0.5.3

* Update test dependency for Dart 2.0


## 0.5.2

* Moving to Dart 2.0 compatibility

## 0.5.1

* Added examples

## 0.5.0

* Introduced strong mode

## 0.4.1

* Added documentation to `Uris`
* Tweaks in implementation

## 0.4.0

* Added `Uris` class to contain various utility functions for inspecting and filtering uris
* Restrict `href` in `a` and `cite` in `blockquote` and `q` to valid uris with the schemes blank, `http` or `https`
* Only add `rel="nofollow"` for external references
* Restrict `src` in `img` to valid uris with the schemes blank, `http`, `https` or `data`


## 0.3.0

* Replaced `AddAttribute` by `AttributeCollector` for more flexibility in the generated attributes
* Renamed `forceAttribute` to `setAttribute` to better reflect what it does
* The `originalAttributes` are now in source order and unmodifiable

## 0.2.1

* Tweaks in implementation

## 0.2.0

* Added documentation
* Added tests
* Removed `when` from `forceAttribute`
* Added `when` to `Whitelist.tags`, `Whitelist.attributes` and `Whitelist.extraAttributes`
* Several minor improvements

## 0.1.0

* Initial implementation