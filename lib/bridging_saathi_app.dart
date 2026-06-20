import 'package:bridging_saathi/router/router.dart';
import 'package:bridging_saathi/theme/dark_theme.dart';
import 'package:bridging_saathi/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BridgingSaathiApp extends StatefulWidget {
  const BridgingSaathiApp({super.key});

  @override
  State<BridgingSaathiApp> createState() => _BridgingSaathiAppState();
}

class _BridgingSaathiAppState extends State<BridgingSaathiApp> {
  @override
  void initState() {
    super.initState();
    // Ensure auth status is checked when app starts
    authState.checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Bridging Saathi',
          theme: getLightTheme(context),
          darkTheme: getDarkTheme(context),
          themeMode: ThemeMode.light,
          routerConfig: router,
        );
      },
    );
  }
}
