// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';

import '../models/language_model.dart';

class AppConstants {
  static String APP_NAME = "project_jurnee";

  // share preference Key
  static String THEME = "theme";

  static const String LANGUAGE_CODE = 'language_code';
  static const String COUNTRY_CODE = 'country_code';

  static RegExp emailValidator = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  static RegExp passwordValidator = RegExp(
    r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$",
  );
  static List<LanguageModel> languages = [
    LanguageModel(
      languageName: 'English',
      countryCode: 'US',
      languageCode: 'en',
    ),
    LanguageModel(languageName: 'عربى', countryCode: 'SA', languageCode: 'ar'),
  ];

  static const LinearGradient DEFAULT_GRADIENT_BACKGROUND = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color.fromRGBO(2, 72, 50, 0.8), Color.fromRGBO(9, 79, 26, 0.8)],
    stops: [0.149, 1],
  );
}
