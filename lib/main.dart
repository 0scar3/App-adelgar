import 'package:Adelgar/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adelgar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(url: 'https://clubadelgar.essenzialdev.com/'),
    );
  }
}

/*
Posible solución para cambiar entre modo claro y oscuro (sustituir entera class MyApp)
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
    create:(_) => ThemeModel(),
    child: Consumer(
      builder: (context, ThemeModel themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Adelgar',
          theme: themeNotifier.isDark ? ThemeData.dark() : ThemeData.light(),
          home: MyHomePage(url: 'https://www.adelgar.es/'),
          );
        },
      )
    );
  }
}*/



class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.url});
  final String url;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loading = true;
  late WebViewController _controller;

  final Completer<WebViewController> _controllerCompleter =
  Completer<WebViewController>();
  //Make sure this function return Future<bool> otherwise you will get an error
  Future<bool> _onWillPop(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(
      duration,
          () {
        setState(() {
          loading = false;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor  = Color(0xFF7BB129);
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: AppBar(
            title: Text(''),
            backgroundColor: primaryColor,
          ),
        ),
        body: loading == true
            ? Center(
            child: Image.asset(
              "assets/images/Logo-adelgar-134x71.png",
              width: 500,
              height: 500,
            )
        )
            : SafeArea(
            child: WebView(
              key: UniqueKey(),
              onWebViewCreated: (WebViewController webViewController) {
                _controllerCompleter.future.then((value) => _controller = value);
                _controllerCompleter.complete(webViewController);
              },
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.url,
            )),
      ),
    );
  }
}

/*
Posible idea para cambiar entre modo oscuro y claro (cambiar codigo a partir de linea 86)


Widget build(BuildContext context) {
    const primaryColor  = Color(0xFF7BB129);
    return Consumer(
      builder: (context, ThemeModel themeNotifier, child){
        return WillPopScope(
          onWillPop: () => _onWillPop(context),
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.5),
              child: AppBar(
                title: Text('Adelgar'),
                backgroundColor: primaryColor,
                actions: [
                  IconButton(
                      onPressed: (){
                        themeNotifier.isDark
                            ? themeNotifier.isDark = false
                            : themeNotifier.isDark = true;
                      },
                      icon: Icon(
                          themeNotifier.isDark
                              ? Icons.wb_sunny : Icons.nightlight_round))
                ],
              ),
            ),
            body: loading == true
                ? Center(
                child: Image.asset(
                  "assets/images/Logo-adelgar-134x71.png",
                  width: 500,
                  height: 500,
                )
            )
                : SafeArea(
                child: WebView(
                  key: UniqueKey(),
                  onWebViewCreated: (WebViewController webViewController) {
                    _controllerCompleter.future.then((value) => _controller = value);
                    _controllerCompleter.complete(webViewController);
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: widget.url,
                )),
          ),
        );
      }
    );
*/

