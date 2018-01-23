import 'package:htmlwhitelist/htmlwhitelist.dart';

void main() {
  var contents = '<b>See:</b> <a href="docs.html">the documentation</a>';
  var safe = Whitelist.simpleText.safeCopy(contents);
  print(safe);
}
