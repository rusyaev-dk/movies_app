import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/auth/presentation/auth_view_cubit/auth_view_cubit.dart';
import 'package:movies_app/features/auth/presentation/components/auth_textfield.dart';
import 'package:movies_app/uikit/colors/colors.dart';
import 'package:movies_app/uikit/text/text.dart';

class AuthBody extends StatefulWidget {
  const AuthBody({super.key});

  @override
  State<AuthBody> createState() => _AuthBodyState();
}

class _AuthBodyState extends State<AuthBody> {
  late final TextEditingController _loginController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Container(
              width: 500,
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2), blurRadius: 55)
                ],
              ),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          "Welcome to Movies App!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.w900,
                            color: ColorPalette.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const ErrorMessageWidget(),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _loginController,
                          prefixIcon: Icons.login,
                          hintText: "Login",
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _passwordController,
                          obscureText: true,
                          prefixIcon: Icons.password,
                          hintText: "Password",
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: CustomLoginButton(
                            loginController: _loginController,
                            passwordController: _passwordController,
                          ),
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthViewCubit, AuthViewState>(
      builder: (context, state) {
        final errorMessage = context.select(
          (AuthViewCubit cubit) {
            final state = cubit.state;
            return state is AuthViewErrorState ? state.errorMessage : null;
          },
        );
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: errorMessage == null
              ? const SizedBox.shrink()
              : Container(
                  key: ValueKey(errorMessage),
                  height: 52,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Center(
                    child: Text(
                      errorMessage,
                      style: AppTextScheme.of(context).label.copyWith(
                            fontSize: 17,
                            color: AppColorScheme.of(context).danger,
                          ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class CustomLoginButton extends StatelessWidget {
  const CustomLoginButton({
    super.key,
    required TextEditingController loginController,
    required TextEditingController passwordController,
  })  : _loginController = loginController,
        _passwordController = passwordController;

  final TextEditingController _loginController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthViewCubit, AuthViewState>(
      builder: (context, state) {
        final AuthViewState state =
            context.select((AuthViewCubit cubit) => cubit.state);

        final bool canStartAuth = state is AuthViewFormFillInProgressState ||
            state is AuthViewErrorState;

        final void Function()? onPressed = canStartAuth
            ? () => context.read<AuthViewCubit>().onAuth(
                  login: _loginController.text,
                  password: _passwordController.text,
                )
            : null;

        final Widget child = state is AuthViewAuthInProgressState
            ? const SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ColorPalette.white,
                ),
              )
            : Text(
                "Login",
                style: AppTextScheme.of(context).label.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: ColorPalette.white,
                    ),
              );

        return SizedBox(
          width: 110,
          height: 45,
          child: FloatingActionButton(
            onPressed: onPressed,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primaryContainer,
                  ],
                  stops: const [0.65, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(child: child),
            ),
          ),
        );
      },
    );
  }
}
