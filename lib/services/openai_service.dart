// lib/services/openai_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  final String apiKey;

  OpenAIService(this.apiKey);

  Future<Map<String, dynamic>?> processPrompt({
    required String prompt,
    required Map<String, dynamic> currentConfig,
  }) async {
    final systemPrompt =
        '''
    You are a Flutter UI configuration assistant. You help modify home screen layouts based on user prompts.
    
    Current configuration:
    ${jsonEncode(currentConfig)}
    
    Available sections and their types:
    - location: Shows location with icon
    - search_bar: Search input field
    - carousel: Image carousel with promotions
    - product_category: Grid of product categories
    - scheme: Horizontal list of schemes/offers
    - hot_trending_products: Grid of trending products
    
    Instructions:
    1. Analyze the user's prompt
    2. Modify ONLY the sections mentioned in the prompt
    3. Keep all existing data structure intact
    4. Only change order, visibility, or configuration parameters
    5. Return a JSON object with "success": true and the modified "sectionOrder" and "sectionConfigs"
    6. If the prompt is unclear or unsafe, return {"success": false, "error": "reason"}
    
    Valid modifications:
    - Reorder sections
    - Hide/show sections (remove from or add to sectionOrder)
    - Change grid parameters (cross_axis_count, spacing, etc.)
    - Change carousel settings (height, auto_play, etc.)
    - Change colors (use hex format like #FF0000 for red, #00FF00 for green, etc.)
    - Change text, padding values
    - Enable/disable view_all buttons
    
    Color format requirements:
    - ALL colors must be in hex format starting with # (e.g., #FF9500, #34C759, #007AFF)
    - Do not use color names like 'red', 'blue', 'orange'
    
    Do NOT:
    - Add new section types
    - Remove required data fields
    - Change item data structure
    - Add unsafe content
    ''';

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 2000,
          'temperature': 0.3,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return jsonDecode(content);
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error calling ChatGPT: $e');
      return null;
    }
  }
}
