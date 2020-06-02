import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:DDatFlutter/app.dart';
import 'package:DDatFlutter/env/config_wrapper.dart';
import 'package:DDatFlutter/env/env_config.dart';
import 'package:DDatFlutter/page/error_page.dart';

import 'env/prod.dart';

void main() {
  runZoned(() {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      Zone.current.handleUncaughtError(details.exception, details.stack);
      return ErrorPage(
          details.exception.toString() + "\n " + details.stack.toString(),
          details);
    };
    runApp(ConfigWrapper(
      child: FlutterReduxApp(),
      config: EnvConfig.fromJson(config),
    ));
  }, onError: (Object obj, StackTrace stack) {
    ///do not thing
  });
}
