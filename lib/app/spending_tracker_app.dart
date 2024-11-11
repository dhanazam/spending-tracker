import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spendingtracker/app/go_router.dart';
import 'package:spendingtracker/blocs/authentication/authentication_bloc.dart';
import 'package:spendingtracker/theme/app_theme.dart';

class SpendingTrackerApp extends StatelessWidget {
  const SpendingTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationBloc = context.read<AuthenticationBloc>();

    return MaterialApp.router(
      title: 'Spending Tracker',
      routerConfig: goRouter(authenticationBloc),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ms'),
      ],
      theme: AppTheme.getThemeFor(ThemeMode.light),
      darkTheme: AppTheme.getThemeFor(ThemeMode.dark),
      themeMode: ThemeMode.system,
    );
  }
}
