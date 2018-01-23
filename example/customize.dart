import 'package:htmlwhitelist/htmlwhitelist.dart';

void main() {
  var whitelist = Whitelist.simpleText
      .tags([
        'a',
        'blockquote',
        'br',
        'code',
        'li',
        'ol',
        'p',
        'pre',
        'q',
        'small',
        'strike',
        'sub',
        'sup',
        'tt',
        'ul',
        'ins',
        'del',
      ])
      .attributes(['blockquote', 'q'], 'cite',
          when: Uris.hasAllowedScheme('cite', ['http', 'https']))
      .attributes('a', 'href',
          when: Uris.hasAllowedScheme('href', ['http', 'https']))
      .extraAttributes('a', setAttribute('rel', 'noopener noreferrer'),
          when: Uris.external('href'))
      .extraAttributes('a', setAttribute('target', '_blank'),
          when: Uris.external('href'));

  var contents = '<b>See:</b> <a href="docs.html">the documentation</a>';

  var safe = whitelist.safeCopy(contents);
  print(safe);
}
