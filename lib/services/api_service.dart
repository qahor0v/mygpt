import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

class ApiService {
  static String base = "api.openai.com";
  static String path = "/v1/completions";
  static const model = "text-davinci-003";
  static const temperature = 0;
  static const maxTokens = 2000;

  static Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer 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"
  };

  static Future<String?> getResponse(String prompt) async {
    String body = jsonEncode({
      "model": model,
      "prompt": prompt,
      "temperature": temperature,
      "max_tokens": maxTokens,
    });

    var uri = Uri.https(base, path);
    final response = await post(uri, headers: headers, body: body);
    log(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> newResponse = jsonDecode(response.body);
      return newResponse['choices'][0]['text'];
    }
    return null;
  }
}
