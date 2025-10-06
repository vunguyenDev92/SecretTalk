import 'package:flutter/material.dart';
import 'package:flutter_app_chat/features/auth/presentation/screens/profile_screen.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';
import 'login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../models/otp_args.dart';
import 'otp_request_screen.dart';
import '../state/auth_state.dart';
import '../../domain/entities/user_entity.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_divider.dart';
import '../widgets/social_login_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  DateTime? birthDate;
  bool obscurePassword = true;
  Country? _selectedCountry = Country.parse('VN');

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        birthDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const AuthHeader(
                  title: 'Sign up',
                  subtitle: 'Create an account to continue!',
                ),
                const SizedBox(height: 24),
                const AuthDivider(),
                const SizedBox(height: 24),
                SocialLoginButton(
                  assetPath: 'assets/google.png',
                  text: 'Continue with Google',
                  onPressed: () {},
                ),
                const SizedBox(height: 16),
                SocialLoginButton(
                  assetPath: 'assets/facebook.png',
                  text: 'Continue with Facebook',
                  onPressed: () {},
                ),
                const SizedBox(height: 32),
                AuthTextField(
                  label: 'Full Name',
                  controller: nameController,
                  hintText: 'Lois Becket',
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  label: 'Email',
                  controller: emailController,
                  hintText: 'Loisbecket@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                const Text('Birth of date'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickBirthDate,
                  child: AbsorbPointer(
                    child: AuthTextField(
                      label: 'Birth of date',
                      controller: TextEditingController(
                        text: birthDate != null
                            ? DateFormat('dd/MM/yyyy').format(birthDate!)
                            : '',
                      ),
                      hintText: '18/03/2024',
                      suffixIcon: const Icon(Icons.calendar_today),
                      enabled: false,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Phone Number'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          onSelect: (Country country) {
                            setState(() {
                              _selectedCountry = country;
                            });
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            if (_selectedCountry != null) ...[
                              Text(
                                _selectedCountry!.flagEmoji,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '+${_selectedCountry!.phoneCode}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ] else ...[
                              const Text('🌐', style: TextStyle(fontSize: 20)),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AuthTextField(
                        label: 'Phone Number',
                        controller: phoneController,
                        hintText: '(454) 726-0592',
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  label: 'Set Password',
                  controller: passwordController,
                  hintText: '********',
                  obscureText: obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 32),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                        (route) => false,
                      );
                    } else if (state is AuthError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
                        final phone = phoneController.text.trim();
                        final country = _selectedCountry;
                        final birth = birthDate;
                        if (name.isEmpty ||
                            email.isEmpty ||
                            password.isEmpty ||
                            phone.isEmpty ||
                            country == null ||
                            birth == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please enter complete information!',
                              ),
                            ),
                          );
                          return;
                        }
                        final otpArgs = OtpArgs(
                          email: email,
                          password: password,
                          username: name,
                          phoneNumber: '+${country.phoneCode}$phone',
                          birthDate: DateFormat('dd/MM/yyyy').format(birth),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                OtpRequestScreen(initialArgs: otpArgs),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            );
                          }
                          return const Text(
                            'Register',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
