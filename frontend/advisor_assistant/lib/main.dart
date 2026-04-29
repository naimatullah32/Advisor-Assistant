import 'package:advisor_assistant/res/getx_loclization/languages.dart';
import 'package:advisor_assistant/res/routes/routes.dart';
import 'package:advisor_assistant/res/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';





void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advisor Assistant',
      // translations: Languages(),
      // locale: const Locale('en' ,'US'),
      // fallbackLocale: const Locale('en' ,'US'),
      theme: ThemeData(primarySwatch: Colors.blue,),
      initialRoute: RouteName.adminHomeView,
      getPages: AppRoutes.appRoutes(),
    );
  }
}

