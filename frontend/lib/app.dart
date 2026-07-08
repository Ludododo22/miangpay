import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class MiangPayApp extends StatelessWidget {
  const MiangPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MiangPay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
