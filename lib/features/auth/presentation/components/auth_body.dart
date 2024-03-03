import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/auth/presentation/auth_view_bloc/auth_view_bloc.dart';

class AuthBody extends StatelessWidget {
  const AuthBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: TextFormsWidget(),
    );
  }
}

class TextFormsWidget extends StatelessWidget {
  const TextFormsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const ErrorMessageWidget(),
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Login',
            hintText: 'Enter your login',
          ),
          onChanged: (value) {
            context.read<AuthViewBloc>().add(AuthViewLoginEvent(value));
          },
        ),
        const SizedBox(height: 20),
        TextField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
          ),
          onChanged: (value) {
            context.read<AuthViewBloc>().add(AuthViewPasswordEvent(value));
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.read<AuthViewBloc>().add(AuthViewAuthEvent());
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final errorMessage = context.select((AuthViewBloc c) {
      final state = c.state;
      return state is AuthViewErrorState ? state.errorMessage : null;
    });
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
  }
}
