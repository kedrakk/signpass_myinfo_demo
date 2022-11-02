import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:test_singpass/routes.dart';

class HtmlContentPage extends StatelessWidget {
  const HtmlContentPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text("HTML content"),
      ),
      body: data != null
          ? Html(
              data: data.toString(),
            )
          : Center(
              child: ElevatedButton(
                child: const Text(
                  "Error",
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                    arguments: "this is home",
                  );
                },
              ),
            ),
    );
  }
}
