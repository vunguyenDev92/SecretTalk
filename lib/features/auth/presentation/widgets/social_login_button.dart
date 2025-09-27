import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String assetPath;
  final String text;
  final VoidCallback onPressed;
  const SocialLoginButton({
    super.key,
    required this.assetPath,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Image.asset(assetPath, height: 24),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
