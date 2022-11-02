import 'package:flutter/material.dart';
import 'package:test_singpass/callback.dart';
import 'package:test_singpass/home.dart';
import 'package:test_singpass/html_content.dart';

class AppRoutes {
  static const String home = "/";
  static const String htmlContent = "/html-content";
  static const String callback = "/callback";
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    String routeName = settings.name ?? "/";
    if (settings.name != null && settings.name!.isNotEmpty) {
      routeName = settings.name!.substring(settings.name!.lastIndexOf('/'));
    }
    if (routeName.startsWith(AppRoutes.callback)) {
      routeName = AppRoutes.callback;
    }
    switch (routeName) {
      case AppRoutes.home:
        return buildRoute(
          const MyHomePage(),
          settings: settings,
        );
      case AppRoutes.htmlContent:
        return buildRoute(
          const HtmlContentPage(),
          settings: settings,
        );
      case AppRoutes.callback:
        String code = Uri.base.queryParameters['code'] ?? "";
        String state = Uri.base.queryParameters['state'] ?? "";
        return buildRoute(
          CallbackTestPage(
            code: code,
            state: state,
          ),
          settings: settings,
        );
      default:
        return _errorRoute();
    }
  }

  static MaterialPageRoute buildRoute(
    Widget child, {
    required RouteSettings settings,
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => child,
    );
  }

  static MaterialPageRoute _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text(
              'ERROR!!',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  SizedBox(
                      height: 450.0,
                      width: 450.0,
                      child: Icon(Icons.error_outline)),
                  Text(
                    'Seems the route you\'ve navigated to doesn\'t exist!!',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
