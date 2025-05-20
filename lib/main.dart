import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pani_express/blocs/auth/auth_bloc.dart';
import 'package:pani_express/blocs/language/language_bloc.dart';
import 'package:pani_express/blocs/language/language_state.dart';
import 'package:pani_express/blocs/theme/theme_bloc.dart';
import 'package:pani_express/blocs/theme/theme_state.dart';
import 'package:pani_express/blocs/user/user_bloc.dart';
import 'package:pani_express/config/app_themes.dart';
import 'package:pani_express/repositories/auth_repository.dart';
import 'package:pani_express/repositories/user_repository.dart';
import 'package:pani_express/services/api_service.dart';
import 'package:pani_express/utils/app_routes.dart';
import 'package:pani_express/utils/route_generator.dart';
import 'package:pani_express/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository =
        AuthRepository(apiService: apiService);
    final UserRepository userRepository =
        UserRepository(apiService: apiService);

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider<LanguageBloc>(
          create: (context) => LanguageBloc(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userRepository: userRepository),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, languageState) {
              return MaterialApp(
                title: 'Pure Aqua',
                debugShowCheckedModeBanner: false,
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
                themeMode: themeState.themeMode,
                locale: languageState.locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en', ''), // English
                  Locale('ne', ''), // Nepali
                ],
                initialRoute: AppRoutes.splash,
                onGenerateRoute: RouteGenerator.generateRoute,
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
