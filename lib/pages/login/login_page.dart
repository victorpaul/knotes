import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/text_styles.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login Page',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text(
                'Login',
                style: AppTextStyles.button,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
