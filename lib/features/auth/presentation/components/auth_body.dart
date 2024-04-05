import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/auth/presentation/components/auth_textfield.dart';
import 'package:movies_app/features/auth/presentation/auth_view_cubit/auth_view_cubit.dart';

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
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
          child: Column(
            children: [
              const Text(
                "Welcome to Movies App!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 54, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 90),
              const ErrorMessageWidget(),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _loginController,
                prefixIcon: Icons.login,
                hintText: "Enter your login",
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _passwordController,
                obscureText: true,
                prefixIcon: Icons.password,
                hintText: "Enter your password",
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomLeft,
                child: CustomLoginButton(
                  loginController: _loginController,
                  passwordController: _passwordController,
                ),
              ),
            ],
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
        if (errorMessage == null) return const SizedBox.shrink();
        return Text(
          errorMessage,
          style: TextStyle(
            fontSize: 17,
            color: Theme.of(context).colorScheme.error,
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
            ? SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : const Text('Login');

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            fixedSize: const Size(90, 50),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(16), // Установка радиуса закругления
            ),
          ),
          onPressed: onPressed,
          child: child,
        );
      },
    );
  }
}
