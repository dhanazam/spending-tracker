import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:module_data/module_data.dart';
import 'package:spendingtracker/app/spending_tracker_app.dart';
import 'package:spendingtracker/blocs/app_bloc_observer.dart';
import 'package:spendingtracker/blocs/authentication/authentication_bloc.dart';
import 'package:spendingtracker/blocs/categories/categories_bloc.dart';
import 'package:spendingtracker/blocs/profile/profile_bloc.dart';
import 'package:spendingtracker/core/locator.dart';

const showDebug = false;
void main() async {
  Intl.systemLocale = await findSystemLocale();
  initServiceLocator();
  await initDataServices();
  if (showDebug) {
    Bloc.observer = AppBlocObserver();
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) =>
              sl<AuthenticationBloc>()..add(AuthenticationStarted()),
        ),
        BlocProvider<CategoriesBloc>(
          create: (context) => sl<CategoriesBloc>(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => sl<ProfileBloc>()..add(ProfileLoad()),
        )
      ],
      child: const SpendingTrackerApp(),
    ),
  );
}
