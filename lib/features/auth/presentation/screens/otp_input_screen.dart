import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_chat/shared/services/otp_service.dart';
import 'package:flutter_app_chat/core/config.dart';
import '../models/otp_args.dart';

class OtpInputScreen extends StatefulWidget {
  final void Function(String otp)? onConfirm;

  const OtpInputScreen({Key? key, this.onConfirm}) : super(key: key);

  @override
  State<OtpInputScreen> createState() => _OtpInputScreenState();
}

class _OtpInputScreenState extends State<OtpInputScreen> {
  static const int _length = 6;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  bool _isResending = false;
  int _resendCooldown = 0;
  bool _isConfirming = false;
  late final OtpService _otpService;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_length, (_) => TextEditingController());
    _focusNodes = List.generate(_length, (_) => FocusNode());
    _otpService = OtpService(AppConfig.backendBaseUrl);
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startResendCooldown([int seconds = 30]) {
    if (!mounted) return;
    setState(() {
      _resendCooldown = seconds;
      _isResending = true;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _resendCooldown--);
      if (_resendCooldown <= 0) {
        setState(() => _isResending = false);
        return false;
      }
      return true;
    });
  }

  void _handlePaste(String text) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= _length) {
      for (var i = 0; i < _length; i++) {
        _controllers[i].text = digits[i];
      }
      _submit();
    }
  }

  void _submit() {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == _length) {
      _confirmOtp(otp);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full code')),
      );
    }
  }

  Future<void> _confirmOtp(String otp) async {
    if (_isConfirming) return;
    setState(() => _isConfirming = true);
    final email = _readEmailFromArgs(context);
    try {
      final res = await _otpService.verifyOtp(email, otp);
      if (res['ok'] == true) {
        if (widget.onConfirm != null) widget.onConfirm!(otp);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('OTP verified')));
        }
      } else {
        final reason = res['reason'] ?? 'unknown';
        final message = res['message'] ?? 'Verification failed';
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$message')));
        }
        if (reason == 'expired') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('OTP expired. Please request a new code.'),
              ),
            );
          }
          _startResendCooldown();
        }
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isConfirming = false);
    }
  }

  String _readEmailFromArgs(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is OtpArgs) return args.email;
    if (args is String) return args;
    if (args is Map) return args['email']?.toString() ?? '';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final email = _readEmailFromArgs(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Enter Verification Code')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Icon(
                Icons.lock_outline,
                size: 64,
                color: Color(0xFF377DFF),
              ),
              const SizedBox(height: 16),
              const Text(
                'Verification Code',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                email.isNotEmpty
                    ? 'Code sent to $email'
                    : 'We have sent the verification code to your email address',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_length, (index) {
                  return SizedBox(
                    width: 48,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (v) {
                        if (v.isNotEmpty) {
                          if (index + 1 < _length) {
                            _focusNodes[index + 1].requestFocus();
                          } else {
                            _focusNodes[index].unfocus();
                            _submit();
                          }
                        } else {
                          // user deleted the char -> move focus back
                          if (index - 1 >= 0)
                            _focusNodes[index - 1].requestFocus();
                        }
                      },
                      onTap: () async {
                        // quick paste detection: if clipboard contains 6 digits, auto-fill
                        final data = await Clipboard.getData('text/plain');
                        final text = data?.text ?? '';
                        if (text.replaceAll(RegExp(r'\D'), '').length >=
                            _length) {
                          _handlePaste(text);
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 28),

              ElevatedButton(
                onPressed: _isConfirming ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: _isConfirming
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Confirm', style: TextStyle(fontSize: 16)),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: _isResending
                    ? null
                    : () async {
                        final email = _readEmailFromArgs(context);
                        if (email.isEmpty) return;
                        setState(() => _isResending = true);
                        try {
                          await _otpService.sendOtp(email);
                          if (mounted)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('OTP resent')),
                            );
                          _startResendCooldown(30);
                        } catch (e) {
                          if (mounted)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Resend failed: $e')),
                            );
                        } finally {
                          if (mounted) setState(() => _isResending = false);
                        }
                      },
                child: Text(
                  _isResending ? 'Resend ($_resendCooldown)' : 'Resend code',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
