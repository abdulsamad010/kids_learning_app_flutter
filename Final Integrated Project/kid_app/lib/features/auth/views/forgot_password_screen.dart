import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kid_app/core/common/utils/validators.dart';
import 'package:kid_app/core/common/widgets/app_button.dart';
import 'package:kid_app/features/auth/viewmodels/auth_viewmodel.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _submitted = false;
  String? _lastError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSend() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitted = true);
    context.read<AuthViewModel>().forgotPassword(
          email: _emailController.text.trim(),
        );
  }

  void _handleAuthState(AuthViewModel auth) {
    if (_submitted && !auth.isLoading && auth.errorMessage == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'If the account exists, a reset link has been sent.',
              ),
            ),
          );
          Navigator.pop(context);
        }
      });
    }
    if (auth.errorMessage != null && auth.errorMessage != _lastError) {
      _lastError = auth.errorMessage;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(auth.errorMessage!)),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    _handleAuthState(auth);

    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Reset your password',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Enter your email address and we will send you a password reset link.',
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Send Reset Link',
                isLoading: auth.isLoading,
                onPressed: auth.isLoading ? null : _onSend,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
