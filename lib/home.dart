import 'package:flutter/material.dart';
import 'package:test_singpass/const.dart';
import 'package:test_singpass/model.dart';
import 'package:test_singpass/repo/data_repo.dart';
import 'package:test_singpass/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? data;
  bool isLoading = false;

  _getData() {
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      data = args.toString();
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    _getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retrieve User"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.testForDeeplink,
              );
            },
            icon: const Icon(
              Icons.link,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : (data != null
                  ? Text("Singpass username:${data!}")
                  : GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 2 / 3,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              imageAsset,
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        changeLoading(true);
                        ResponseModel? res;
                        try {
                          res = await DataRepo.requestAuthCode(
                            clientId: clientId,
                            purpose: purpose,
                            state: "12121212",
                            redirectURL: redirectURL,
                            attributes: attributes,
                          );
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                        changeLoading(false);
                        if (res!.code == 200) {
                          _launchURL(res.data);
                        } else {
                          _goToanotherPage(res.data);
                        }
                      },
                    )),
        ),
      ),
    );
  }

  changeLoading(bool newVal) {
    setState(() {
      isLoading = newVal;
    });
  }

  _goToanotherPage(res) {
    Navigator.pushNamed(
      context,
      AppRoutes.htmlContent,
      arguments: res,
    );
  }

  _launchURL(res) async {
    try {
      await launchUrl(Uri.parse(res));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
