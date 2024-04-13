import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/features/auth/presentation/auth_view_cubit/auth_view_cubit.dart';
import 'package:movies_app/features/auth/presentation/components/auth_body.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  void _onAuthViewCubitStateChange(BuildContext context, AuthViewState state) {
    if (state is AuthViewSuccessState) {
      context.go(AppRoutes.screenLoader);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthViewCubit(
        initialState: AuthViewFormFillInProgressState(),
        authBloc: RepositoryProvider.of<AuthBloc>(context),
      ),
      child: BlocListener<AuthViewCubit, AuthViewState>(
        listener: _onAuthViewCubitStateChange,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/welcome_image.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.75),
                  Colors.black.withOpacity(0.35),
                  Colors.black.withOpacity(0.75),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
            child: const Scaffold(
              backgroundColor: Colors.transparent,
              // resizeToAvoidBottomInset: false,
              body: AuthBody(),
            ),
          ),
        ),
      ),
    );
  }
}
