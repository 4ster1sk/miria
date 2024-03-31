import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/general_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralSettingsRepository extends ChangeNotifier {
  var _settings = const GeneralSettings();
  GeneralSettings get settings => _settings;

  void _initLanguage() {
    Languages lang = Languages.jaJP;
    switch (WidgetsBinding.instance.platformDispatcher.locale.languageCode) {
      case "zh":
        lang = Languages.zhCN;
        break;
    }
    _settings = _settings.copyWith(languages: lang);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString("general_settings");
    if (storedData == null || storedData.isEmpty) {
      _initLanguage();
      _save();
      return;
    }

    try {
      _settings = GeneralSettings.fromJson(jsonDecode(storedData));
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> update(GeneralSettings settings) async {
    _settings = settings;
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("general_settings", jsonEncode(_settings.toJson()));
  }
}
