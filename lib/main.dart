import 'package:app/decrypt/index.dart';
import 'package:app/encrypt/index.dart';
import 'package:app/about/index.dart';
import 'package:app/phrase/index.dart';
import 'package:app/service/translate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(TranslateApp(), permanent: true);
  TranslateApp lang = Get.find();
  await lang.setLang();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TranslateApp lang = Get.find();
  @override
  void initState() {
    super.initState();
  }

  start() {}

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translationsKeys: AppTranslation.translationsKeys,
      locale: (lang.locale ?? Get.deviceLocale),
      fallbackLocale: const Locale('pt', 'BR'),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      title: 'BTC HashProtector',
      theme: ThemeData(
        tabBarTheme: const TabBarTheme(
          indicatorColor: Color.fromARGB(255, 178, 140, 3),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF022142),
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 178, 140, 3),
        ),
        useMaterial3: true,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    EncryptPage(),
    DecryptPage(),
    PhrasePage(),
    InfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.enhanced_encryption_outlined),
            label: 'encrypt'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.no_encryption_outlined),
            label: 'decrypt'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.key_outlined),
            label: 'phrase'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.info_outline),
            label: 'about'.tr,
          ),
        ],
      ),
    );
  }
}
