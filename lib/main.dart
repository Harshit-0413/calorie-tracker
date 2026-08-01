import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme/app_theme.dart';

import 'repositories/meal_repository.dart';

import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'services/database_seeder.dart';
import 'services/claude_service.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'blocs/meal/meal_bloc.dart';
import 'blocs/goal/goal_bloc.dart';
import 'blocs/weight/weight_bloc.dart';

import 'firebase_options.dart';

import 'screens/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final databaseService = DatabaseService();

  await databaseService.database;

  await DatabaseSeeder(databaseService).seedFoods();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const CalorieTrackerApp());
}

class CalorieTrackerApp extends StatelessWidget {
  const CalorieTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService.instance;
    final databaseService = DatabaseService();
    final claudeService = ClaudeService();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthService>.value(value: authService),
        RepositoryProvider<DatabaseService>.value(value: databaseService),
        RepositoryProvider<ClaudeService>.value(value: claudeService),
        RepositoryProvider<MealRepository>(
          create: (_) =>
              MealRepository(database: databaseService, claude: claudeService),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(authService)..add(AuthStarted()),
          ),
          BlocProvider(create: (_) => UserBloc(databaseService)),
          BlocProvider(
            create: (context) => MealBloc(context.read<MealRepository>()),
          ),
          BlocProvider(create: (_) => WeightBloc(databaseService)),
          BlocProvider(create: (_) => GoalBloc(databaseService)),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Calorie Tracker",
          theme: AppTheme.theme,
          home: const AppRouter(),
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              ),
              child: const Icon(
                Icons.local_fire_department_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: AppTheme.md),
            Text(
              "CalTrack",
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
