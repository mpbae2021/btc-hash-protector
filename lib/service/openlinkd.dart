import 'package:url_launcher/url_launcher.dart';

class OpenLink {
  url() async {
    Uri url = Uri.parse('https://err34.page.link/jTpt');
    await launchUrl(url);
  }
}
