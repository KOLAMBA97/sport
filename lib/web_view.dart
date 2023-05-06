import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';



class InfoPong extends StatefulWidget {
  String bloc;
  InfoPong({Key? key, required this.bloc}) : super(key: key);

  @override
  State<InfoPong> createState() => _InfoPongState();
}

class _InfoPongState extends State<InfoPong> {
  late InAppWebViewController _webViewController;
  double progress = 0;

  @override
  void initState() {
   // push();
    super.initState();
  }


  Future<bool> onBackPressed() async {
    _webViewController.goBack();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: onBackPressed,
        child: Column(
          children: [
            Expanded(
              child: Stack(children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.parse(widget.bloc)),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      useShouldOverrideUrlLoading: true,
                      javaScriptCanOpenWindowsAutomatically: true,
                    ),
                  ),
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },

                  androidOnPermissionRequest:
                      (InAppWebViewController controller, String origin,
                      List<String> resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  onProgressChanged: (controller, progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                ),
                progress < 1.0
                    ? Center(
                    child: SizedBox(
                        height: 70,
                        width: 70,
                        child: CircularProgressIndicator(color: Color.fromARGB(255, 82, 255, 59),))
                )
                    : Container(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}