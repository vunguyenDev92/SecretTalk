import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpService {
  final String backendUrl;
  OtpService(this.backendUrl);

  Future<void> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse('$backendUrl/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );
    if (response.statusCode == 200) return;
    final body = json.decode(response.body);
    final msg = body is Map
        ? (body['message'] ?? body['error'] ?? response.body)
        : response.body;
    throw Exception('Failed to send OTP: $msg');
  }

  /// Returns a map: { 'ok': bool, 'reason': String? }
  Future<Map<String, dynamic>> verifyOtp(String email, String inputCode) async {
    final response = await http.post(
      Uri.parse('$backendUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'code': inputCode}),
    );
    final body = response.body.isNotEmpty ? json.decode(response.body) : {};
    if (response.statusCode == 200) return {'ok': true};
    // normalize reasons
    if (body is Map && body.containsKey('reason')) {
      return {
        'ok': false,
        'reason': body['reason'],
        'message': body['message'],
      };
    }
    return {
      'ok': false,
      'reason': 'unknown',
      'message': body is Map ? body['message'] ?? body['error'] : response.body,
    };
  }
}
