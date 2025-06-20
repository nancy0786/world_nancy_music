import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static const _serviceId = 'YOUR_SERVICE_ID';
  static const _templateId = 'YOUR_TEMPLATE_ID';
  static const _userId = 'YOUR_PUBLIC_KEY'; // Also called "User ID" or "Public Key"

  static Future<bool> sendLoginCode(String toEmail, String code) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': _serviceId,
        'template_id': _templateId,
        'user_id': _userId,
        'template_params': {
          'user_email': toEmail,
          'login_code': code,
        },
      }),
    );

    return response.statusCode == 200;
  }
}
