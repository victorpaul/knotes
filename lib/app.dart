import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'widgets/initialization_wrapper.dart';
import 'service_locator.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> _initializeApp() async {
    // Initialize services
    await setupServiceLocator();
  }

  @override
  Widget build(BuildContext context) {
    return InitializationWrapper(
      initialization: _initializeApp,
      child: drawRouter(),
    );
  }

  Widget drawRouter() {
    return MaterialApp.router(
      title: 'Kotes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
