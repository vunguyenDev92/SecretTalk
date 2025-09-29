import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../state/auth_state.dart';
import 'login_screen.dart';
import '../../../chat/presentation/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthBloc>().add(AuthCheckRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          });
        } else if (state is AuthUnauthenticated || state is AuthError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Lottie.asset(
            'assets/Le Petit Chat _Cat_ Noir.json',
            width: 220,
            height: 220,
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),
      ),
    );
  }
}
