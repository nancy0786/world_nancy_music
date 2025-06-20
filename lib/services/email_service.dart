import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static const _serviceId = 'your_service_id';
  static const _templateId = 'your_template_id';
  static const _userId = 'your_user_id';

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
