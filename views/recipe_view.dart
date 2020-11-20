import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
  final String postUrl;
  RecipeView({this.postUrl});

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  String finalUrl;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    if (widget.postUrl.contains("http://")) {
      finalUrl = widget.postUrl.replaceAll("http://", "https://");
    } else {
      finalUrl = widget.postUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: !kIsWeb
                      ? Platform.isIOS
                          ? 60
                          : 30
                      : 30,
                  left: 24,
                  right: 24,
                  bottom: 20),
              decoration: BoxDecoration(
                //color: Colors.black54,
                gradient: LinearGradient(
                  colors: [const Color(0xff213A50), const Color(0xff071930)],
                  begin: FractionalOffset.topRight,
                  end: FractionalOffset.bottomLeft,
                ),
              ),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment:
                    kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "AppGuy",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Overpass'),
                  ),
                  Text(
                    "Recipes",
                    style: GoogleFonts.overpass(
                      fontSize: 18,
                      color: Colors.blue,
                      //fontFamily: 'Overpass'
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width,
              child: WebView(
                initialUrl: finalUrl,
                onWebViewCreated: (WebViewController webViewController) {
                  setState(() {
                    _controller.complete(webViewController);
                  });
                },
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
