import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/auth/presentation/auth_view_cubit/auth_view_cubit.dart';

class AuthBody extends StatelessWidget {
  AuthBody({super.key});

  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const ErrorMessageWidget(),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _loginController,
            labelText: "Login",
            hintText: "Enter your login",
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _passwordController,
            obscureText: true,
            labelText: "Password",
            hintText: "Enter your password",
          ),
          const SizedBox(height: 20),
          CustomLoginButton(
            loginController: _loginController,
            passwordController: _passwordController,
          ),
        ],
      ),
    );
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
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            errorMessage,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.obscureText = false,
    required this.labelText,
    required this.hintText,
  });

  final TextEditingController controller;
  final bool obscureText;
  final String labelText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      ),
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
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Login');

        return ElevatedButton(
          onPressed: onPressed,
          child: child,
        );
      },
    );
  }
}
