import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibe_in/features/auth/data/firebase_auth_repo.dart';
import 'package:vibe_in/features/profile/data/firebase_profile_repository.dart';

import 'features/auth/presentation/cubits/auth_cubits.dart';
import 'features/auth/presentation/cubits/auth_states.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/profile/presentation/cubits/profile_cubits.dart';
import 'features/storage/data/firebase_storage_repository.dart';
import 'themes/light_mode.dart';

/*
  App - Root Level
*/

class MyApp extends StatelessWidget {
  // auth repo
  final firebaseAuthRepo = FirebaseAuthRepo();

  // profile repo
  final firebaseProfileRepo = FirebaseProfileRepository();

  // storage repo
  final firebaseStorageRepo = FirebaseStorageRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // provide cubits to app
    return MultiBlocProvider(
      providers: [
        // auth cubit
        BlocProvider(
          create:
              (context) => AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),

        // profile cubit
        BlocProvider(
          create:
              (context) => ProfileCubits(
                profileRepository: firebaseProfileRepo,
                storageRepository: firebaseStorageRepo,
              ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VibeIn',
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            log('authState : $authState');

            if (authState is Unauthenticated) {
              return const AuthPage();
            }

            if (authState is Authenticated) {
              return const HomePage();
            } else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },

          // listen for errors
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}
