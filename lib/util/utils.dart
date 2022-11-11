import 'package:url_launcher/url_launcher.dart';

class Utils{

  static launch(url)  async {
    await launchUrl(Uri.parse(url));
  }
}