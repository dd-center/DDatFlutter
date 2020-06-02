import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:DDatFlutter/common/localization/dd_string_base.dart';
import 'package:DDatFlutter/common/localization/dd_string_en.dart';
import 'package:DDatFlutter/common/localization/dd_string_zh.dart';

///自定义多语言实现
class GSYLocalizations {
  final Locale locale;

  GSYLocalizations(this.locale);

  ///根据不同 locale.languageCode 加载不同语言对应
  ///DDStringEn和DDStringZh都继承了DDStringBase
  static Map<String, DDStringBase> _localizedValues = {
    'en': new DDStringEn(),
    'zh': new DDStringZh(),
  };

  DDStringBase get currentLocalized {
    if (_localizedValues.containsKey(locale.languageCode)) {
      return _localizedValues[locale.languageCode];
    }
    return _localizedValues["en"];
  }

  ///通过 Localizations 加载当前的 GSYLocalizations
  ///获取对应的 DDStringBase
  static GSYLocalizations of(BuildContext context) {
    return Localizations.of(context, GSYLocalizations);
  }

  ///通过 Localizations 加载当前的 GSYLocalizations
  ///获取对应的 DDStringBase
  static DDStringBase i18n(BuildContext context) {
    return (Localizations.of(context, GSYLocalizations) as GSYLocalizations)
        .currentLocalized;
  }
}
