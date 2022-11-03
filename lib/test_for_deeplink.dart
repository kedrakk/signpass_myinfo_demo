import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TestForDeeplinkPage extends StatelessWidget {
  const TestForDeeplinkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Test For Deeplink",
        ),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Click me"),
          onPressed: () => _launchURL(),
        ),
      ),
    );
  }

  _launchURL() {
    launchUrl(
      Uri.parse("https://my-portfolio-6caa3.web.app/"),
      mode: LaunchMode.externalApplication,
    );
  }
}
