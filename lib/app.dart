import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:DDatFlutter/common/event/http_error_event.dart';
import 'package:DDatFlutter/common/event/index.dart';
import 'package:DDatFlutter/common/localization/default_localizations.dart';
import 'package:DDatFlutter/common/localization/dd_localizations_delegate.dart';
import 'package:DDatFlutter/page/debug/debug_label.dart';
import 'package:DDatFlutter/page/photoview_page.dart';
import 'package:DDatFlutter/redux/gsy_state.dart';
import 'package:DDatFlutter/model/User.dart';
import 'package:DDatFlutter/common/style/gsy_style.dart';
import 'package:DDatFlutter/common/utils/common_utils.dart';
import 'package:DDatFlutter/page/home/home_page.dart';
import 'package:DDatFlutter/page/login/login_page.dart';
import 'package:DDatFlutter/page/welcome_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:DDatFlutter/common/net/code.dart';

import 'common/event/index.dart';
import 'common/utils/navigator_utils.dart';

class FlutterReduxApp extends StatefulWidget {
  @override
  _FlutterReduxAppState createState() => _FlutterReduxAppState();
}

class _FlutterReduxAppState extends State<FlutterReduxApp>
    with HttpErrorListener {
  /// 创建Store，引用 DDatFlutter 中的 appReducer 实现 Reducer 方法
  /// initialState 初始化 State
  final store = new Store<GSYState>(
    appReducer,

    ///拦截器
    middleware: middleware,

    ///初始化数据
    initialState: new GSYState(
        userInfo: User.empty(),
        login: false,
        themeData: CommonUtils.getThemeData(GSYColors.primarySwatch),
        locale: Locale('zh', 'CH')),
  );

  @override
  Widget build(BuildContext context) {
    /// 使用 flutter_redux 做全局状态共享
    /// 通过 StoreProvider 应用 store
    return new StoreProvider(
      store: store,
      child: new StoreBuilder<GSYState>(builder: (context, store) {
        ///使用 StoreBuilder 获取 store 中的 theme 、locale
        store.state.platformLocale = WidgetsBinding.instance.window.locale;
        return new MaterialApp(

            ///多语言实现代理
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              DDLocalizationsDelegate.delegate,
            ],
            supportedLocales: [store.state.locale],
            locale: store.state.locale,
            theme: store.state.themeData,

            ///命名式路由
            /// "/" 和 MaterialApp 的 home 参数一个效果
            routes: {
              WelcomePage.sName: (context) {
                _context = context;
                DebugLabel.showDebugLabel(context);
                return WelcomePage();
              },
              HomePage.sName: (context) {
                _context = context;
                return NavigatorUtils.pageContainer(new HomePage());
              },
              LoginPage.sName: (context) {
                _context = context;
                return NavigatorUtils.pageContainer(new LoginPage());
              },

              ///使用 ModalRoute.of(context).settings.arguments; 获取参数
              PhotoViewPage.sName: (context) {
                return PhotoViewPage();
              },
            });
      }),
    );
  }
}

mixin HttpErrorListener on State<FlutterReduxApp> {
  StreamSubscription stream;

  ///这里为什么用 _context 你理解吗？
  ///因为此时 State 的 context 是 FlutterReduxApp 而不是 MaterialApp
  ///所以如果直接用 context 是会获取不到 MaterialApp 的 Localizations 哦。
  BuildContext _context;

  @override
  void initState() {
    super.initState();

    ///Stream演示event bus
    stream = eventBus.on<HttpErrorEvent>().listen((event) {
      errorHandleFunction(event.code, event.message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (stream != null) {
      stream.cancel();
      stream = null;
    }
  }

  ///网络错误提醒
  errorHandleFunction(int code, message) {
    switch (code) {
      case Code.NETWORK_ERROR:
        showToast(GSYLocalizations.i18n(_context).network_error);
        break;
      case 401:
        showToast(GSYLocalizations.i18n(_context).network_error_401);
        break;
      case 403:
        showToast(GSYLocalizations.i18n(_context).network_error_403);
        break;
      case 404:
        showToast(GSYLocalizations.i18n(_context).network_error_404);
        break;
      case 422:
        showToast(GSYLocalizations.i18n(_context).network_error_422);
        break;
      case Code.NETWORK_TIMEOUT:
        //超时
        showToast(GSYLocalizations.i18n(_context).network_error_timeout);
        break;
      case Code.GITHUB_API_REFUSED:
        //Github API 异常
        showToast(GSYLocalizations.i18n(_context).github_refused);
        break;
      default:
        showToast(GSYLocalizations.i18n(_context).network_error_unknown +
            " " +
            message);
        break;
    }
  }

  showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG);
  }
}