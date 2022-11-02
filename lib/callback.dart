import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:test_singpass/const.dart';
import 'package:test_singpass/repo/data_repo.dart';

import 'routes.dart';

class CallbackTestPage extends StatefulWidget {
  const CallbackTestPage({
    super.key,
    required this.code,
    required this.state,
  });
  final String code;
  final String state;

  @override
  State<CallbackTestPage> createState() => _CallbackTestPageState();
}

class _CallbackTestPageState extends State<CallbackTestPage> {
  bool loading = true;
  String token = "";
  String sub = "";
  String userData = "";
  @override
  void didChangeDependencies() {
    _getToken();
    super.didChangeDependencies();
  }

  _getToken() async {
    token = await DataRepo.getToken(
      code: widget.code,
      state: widget.state,
      redirectURL: redirectURL,
      clientId: clientId,
      clientSecret: clientSecret,
    );
    _getSubFromToken();
    _getUserData();
  }

  _getSubFromToken() {
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    sub = payload['sub'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              "Here",
            ),
            Text(widget.state),
            Text(widget.code),
            if (loading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  _getUserData() async {
    setState(() {
      loading = true;
    });
    userData = await DataRepo.getPersonData(
      sub: sub,
      attributes: attributes,
      clientId: clientId,
      authorizationToken: token,
    );
    loading = false;
    setState(() {});
    _backToHome();
  }

  _backToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
      arguments: userData,
    );
  }
}
