class OtpArgs {
  final String email;
  final String? password;
  final String? username;
  final String? phoneNumber;
  final String? birthDate;

  OtpArgs({
    required this.email,
    this.password,
    this.username,
    this.phoneNumber,
    this.birthDate,
  });
}
