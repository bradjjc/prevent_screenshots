import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:screen_protector/screen_protector.dart';

void main() async {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } else {
      await ScreenProtector.preventScreenshotOn();
    }
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _secureMode = false;

  @override
  void initState() {
    super.initState();
    // SecureShot().on().then((value) => setState(() {}));
  }

  @override
  void dispose() {
    SecureShot().off();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Secure Mode: ${_secureMode.toString()}\n'),
              ElevatedButton(
                  onPressed: () async {
                    // final secureModeToggle = !_secureMode;
                    //
                    // if (secureModeToggle == true) {
                    //   await FlutterWindowManager.addFlags(
                    //       FlutterWindowManager.FLAG_SECURE);
                    // } else {
                    await FlutterWindowManager.clearFlags(
                        FlutterWindowManager.FLAG_SECURE);
                    // }

                    setState(() {
                      _secureMode = !_secureMode;
                    });
                  },
                  child: const Text("Toggle Secure Mode")),
            ],
          ),
        ),
      ),
    );
  }
}

class SecureShot {
  SecureShot();

  static const _channel = MethodChannel('secureShotChannel');

  Future<void> on() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } else if (Platform.isIOS) {
      await _channel.invokeMethod("secureIOS");
    }
  }

  Future<void> off() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } else if (Platform.isIOS) {
      await _channel.invokeMethod("unSecureIOS");
    }
  }
}
