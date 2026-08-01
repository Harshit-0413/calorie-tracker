import 'package:calorie_tracker/screens/setup/profile_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/user/user_bloc.dart';

import 'main/main_screen.dart';
import 'onboarding/onboarding_screen.dart';
import '../main.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  String? _loadedUid;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthAuthenticated && authState.uid != _loadedUid) {
          _loadedUid = authState.uid;
          context.read<UserBloc>().add(LoadUser(authState.uid));
        }
      },
      builder: (context, authState) {
        if (authState is AuthLoading) return const SplashScreen();
        if (authState is AuthUnauthenticated) return const OnboardingScreen();

        if (authState is AuthAuthenticated) {
          return BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              if (userState is UserLoading || userState is UserInitial) {
                return const SplashScreen();
              }
              if (userState is UserLoaded) return const MainScreen();
              if (userState is UserNotFound) return const ProfileSetupScreen();
              if (userState is UserError) {
                return Scaffold(body: Center(child: Text(userState.message)));
              }
              return const SplashScreen();
            },
          );
        }

        return const SplashScreen();
      },
    );
  }
}
