import 'package:flutter/material.dart';
import 'package:flutter_app_chat/shared/services/otp_service.dart';
import 'package:flutter_app_chat/core/config.dart';
import '../models/otp_args.dart';
import 'otp_input_screen.dart';
import '../../domain/entities/user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class OtpRequestScreen extends StatefulWidget {
  final OtpArgs? initialArgs;
  const OtpRequestScreen({Key? key, this.initialArgs}) : super(key: key);

  @override
  State<OtpRequestScreen> createState() => _OtpRequestScreenState();
}

class _OtpRequestScreenState extends State<OtpRequestScreen> {
  final TextEditingController _emailController = TextEditingController();
  late final OtpService _otpService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _otpService = OtpService(AppConfig.backendBaseUrl);
    if (widget.initialArgs != null) {
      _emailController.text = widget.initialArgs!.email;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request OTP')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendOtp,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your email')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _otpService.sendOtp(email);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpInputScreen(
            onConfirm: (otp) {
              final init = widget.initialArgs;
              final user = UserEntity(
                uid: '',
                email: email,
                username: init?.username ?? '',
                phoneNumber: init?.phoneNumber ?? '',
                birthDate: init?.birthDate ?? '',
              );
              final password = init?.password ?? '';
              context.read<AuthBloc>().add(AuthSignUpRequested(user, password));
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send OTP: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
