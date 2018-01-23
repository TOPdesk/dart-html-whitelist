import 'package:htmlwhitelist/htmlwhitelist.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

void main() {
  var contents = '<b>See:</b> <a href="docs.html">the documentation</a>';

  DocumentFragment fragment = parseFragment(contents);
  DocumentFragment safeCopy = Whitelist.simpleText.cleaner.safeCopy(fragment);

  print(safeCopy.outerHtml);
}