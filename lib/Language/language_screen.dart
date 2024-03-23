import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pos/Screens/Home/home.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import 'language_provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  List<String> baseFlagsCode = [
    'US',
    'RU',
    'UZ',

    // 'MM'
  ];
  List<String> countryList = [
    'English',
    'Russian',
    'Uzbek',

    // "Burmese",
  ];
  String selectedCountry = 'Uzbek';

  Future<void> saveData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedLanguage', data);
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    selectedCountry = prefs.getString('savedLanguage') ?? selectedCountry;
    setState(() {});
  }

  Future<void> saveDataOnLocal(
      {required String key,
      required String type,
      required dynamic value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (type == 'bool') prefs.setBool(key, value);
    if (type == 'string') prefs.setString(key, value);
  }

  @override
  void initState() {
    getData();
    selectedCountry;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          lang.S.of(context).language,
          style: const TextStyle(color: kWhite),
        ),
        iconTheme: const IconThemeData(color: kWhite),
      ),
      backgroundColor: kMainColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
          child: ListView.builder(
              itemCount: countryList.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border:
                          Border.all(color: kBorderColorTextField, width: 0.7),
                    ),
                    // boxShadow: const [BoxShadow(color: kDarkWhite, offset: Offset(5, 5), spreadRadius: 2.0, blurRadius: 10.0)]),
                    child: ListTile(
                      horizontalTitleGap: 5,
                      onTap: () {
                        setState(
                          () {
                            selectedCountry = countryList[index];
                            selectedCountry == 'English'
                                ? context
                                    .read<LanguageChangeProvider>()
                                    .changeLocale("en")
                                : selectedCountry == "Russian"
                                    ? context
                                        .read<LanguageChangeProvider>()
                                        .changeLocale("ru")
                                    : selectedCountry == 'Uzbek'
                                        ? context
                                            .read<LanguageChangeProvider>()
                                            .changeLocale("uz")
                                        : selectedCountry == 'Spanish'
                                            ? context
                                                .read<LanguageChangeProvider>()
                                                .changeLocale("es")
                                            : selectedCountry == 'Hindi'
                                                ? context
                                                    .read<
                                                        LanguageChangeProvider>()
                                                    .changeLocale("hi")
                                                : selectedCountry == 'France'
                                                    ? context
                                                        .read<
                                                            LanguageChangeProvider>()
                                                        .changeLocale("fr")
                                                    : selectedCountry ==
                                                            "Bengali"
                                                        ? context
                                                            .read<
                                                                LanguageChangeProvider>()
                                                            .changeLocale("bn")
                                                        : selectedCountry ==
                                                                "Turkish"
                                                            ? context
                                                                .read<
                                                                    LanguageChangeProvider>()
                                                                .changeLocale(
                                                                    "tr")
                                                            : selectedCountry ==
                                                                    "Chinese"
                                                                ? context
                                                                    .read<
                                                                        LanguageChangeProvider>()
                                                                    .changeLocale(
                                                                        "zh")
                                                                : selectedCountry ==
                                                                        "Japanese"
                                                                    ? context
                                                                        .read<
                                                                            LanguageChangeProvider>()
                                                                        .changeLocale(
                                                                            "ja")
                                                                    : selectedCountry ==
                                                                            "Romanian"
                                                                        ? context
                                                                            .read<LanguageChangeProvider>()
                                                                            .changeLocale("ro")
                                 : context.read<LanguageChangeProvider>().changeLocale("en");
                            saveDataOnLocal(
                                key: 'savedLanguage',
                                type: 'string',
                                value: selectedCountry);
                            saveData(selectedCountry);
                          },
                        );
                      },
                      leading: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: kBorderColorTextField, width: 0.3)),
                        child: Flag.fromString(
                          baseFlagsCode[index],
                          fit: BoxFit.cover,
                          height: 25,
                          width: 30,
                        ),
                      ),
                      title: Text(countryList[index]),
                      trailing: selectedCountry == countryList[index]
                          ? const Icon(Icons.radio_button_checked,
                              color: kMainColor)
                          : const Icon(
                              Icons.radio_button_off,
                              color: Color(0xff9F9F9F),
                            ),
                    ),
                  ),
                );
              }),
        ),
      ),
      bottomNavigationBar: Container(
        height: 95,
        color: Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 15),
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: kMainColor),
              child: Text(
                lang.S.of(context).save,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
