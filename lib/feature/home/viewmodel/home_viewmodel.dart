import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../../../services/openai_service.dart';

class HomeViewModel extends GetxController {
  final OpenAIService _openAIService = OpenAIService(
    dotenv.env['CHATGPT_APIKEY'] ?? "key",
  );

  // Reactive state
  final isLoading = false.obs;
  final showInput = false.obs;

  // Data (kept non-reactive where it makes sense)
  final List<Map<String, dynamic>> promotionItems = [
    {
      'image':
          'https://images.pexels.com/photos/4315573/pexels-photo-4315573.jpeg', // Air Filter
      'title': 'High-Flow Air Filter',
      'discount': '10% Off',
      'description': 'Durable & Reliable ✓ High Air Flow ✓ Easy Installation',
      'button_text': 'BUY NOW',
      'button_color': '#FF9500',
    },
    {
      'image':
          'https://images.pexels.com/photos/1145434/pexels-photo-1145434.jpeg', // Synthetic Motor Oil
      'title': 'Synthetic Engine Oil',
      'discount': '15% Off',
      'description': 'Premium Quality ✓ Long Life ✓ Better Performance',
      'button_text': 'BUY NOW',
      'button_color': '#34C759',
    },
  ];

  final List<Map<String, dynamic>> categoryItems = [
    {
      'image':
          'https://www.shutterstock.com/image-illustration/car-parts-auto-spare-isolated-600nw-2283939101.jpg',
      'title': 'Service Parts',
    },
    {
      'image':
          'https://images.pexels.com/photos/4315579/pexels-photo-4315579.jpeg',
      'title': 'Belts & Chains',
    },
    {
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0YAP3nNsPfGDKDCaNpvuwOSVPyWkB2ThIpQ&s',
      'title': 'Cables',
    },
    {
      'image':
          'https://images.pexels.com/photos/3802517/pexels-photo-3802517.jpeg',
      'title': 'Body Parts',
    },
    {
      'image':
          'https://images.pexels.com/photos/4315572/pexels-photo-4315572.jpeg',
      'title': 'Locks & Security',
    },
    {
      'image':
          'https://thumbs.dreamstime.com/b/lense-ray-png-mist-realistic-illustration-car-headlight-flare-smoke-night-smoky-road-light-beams-glowing-fog-316975925.jpg',
      'title': 'Lighting',
    },
  ];

  final List<Map<String, dynamic>> schemeItems = [
    {
      'image':
          'https://www.as-parts.nz/images/531682/pid1745803/414-12032_1.PNG',
      'original_price': '\$180.00',
      'discounted_price': '\$100.00',
      'discount': '45% OFF',
      'scheme': 'Starter Maintenance Kit',
      'discount_pill_color': '#34C759',
      'button_color': '#34C759',
      'button_text': 'Add to Cart',
    },
    {
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTq_KLpNQ8g0iHCmG8qQTk7-lBFs5Mts89S7Q&s',
      'original_price': '\$250.00',
      'discounted_price': '\$150.00',
      'discount': '40% OFF',
      'scheme': 'Complete Service Bundle',
      'discount_pill_color': '#FF3B30',
      'button_color': '#FF3B30',
      'button_text': 'Add to Cart',
    },
  ];

  final List<Map<String, dynamic>> trendingItems = [
    {
      'image':
          'https://images.pexels.com/photos/5070474/pexels-photo-5070474.jpeg',
      'title': 'Synthetic Motor Oil 5W-30',
      'discount': 'Up to 40% Off',
      'discount_color': '#FF9500',
    },
    {
      'image':
          'https://images.pexels.com/photos/3862611/pexels-photo-3862611.jpeg',
      'title': 'Timing Belt & Chain Kit',
      'discount': '35% Off',
      'discount_color': '#FF9500',
    },
    {
      'image':
          'https://images.pexels.com/photos/4315573/pexels-photo-4315573.jpeg',
      'title': 'Air Filter Premium',
      'discount': '30% Off',
      'discount_color': '#34C759',
    },
    {
      'image':
          'https://images.pexels.com/photos/4420345/pexels-photo-4420345.jpeg',
      'title': 'Brake Pads Set',
      'discount': '25% Off',
      'discount_color': '#FF3B30',
    },
    {
      'image':
          'https://images.pexels.com/photos/978555/pexels-photo-978555.jpeg',
      'title': 'Spark Plug Set',
      'discount': '20% Off',
      'discount_color': '#007AFF',
    },
    {
      'image':
          'https://images.pexels.com/photos/4116193/pexels-photo-4116193.jpeg',
      'title': 'Car Battery Booster Pack',
      'discount': '15% Off',
      'discount_color': '#FF9500',
    },
  ];

  // Reactive config containers
  final RxMap<String, Map<String, dynamic>> sectionConfigs =
      <String, Map<String, dynamic>>{}.obs;
  final RxList<String> sectionOrder = <String>[
    'location',
    'search_bar',
    'carousel',
    'product_category',
    'scheme',
    'hot_trending_products',
  ].obs;

  final Map<String, Map<String, dynamic>> _backupConfigs = {};
  final List<String> _backupOrder = [];

  HomeViewModel() {
    _initializeConfigs();
    _createBackup();
  }

  Map<String, dynamic> get currentConfig => {
    'sectionOrder': sectionOrder.toList(),
    'sectionConfigs': sectionConfigs,
  };

  // Public method used by UI to process prompt
  Future<bool> processPrompt(String prompt) async {
    if (prompt.trim().isEmpty) return false;

    try {
      isLoading.value = true;
      final response = await _openAIService.processPrompt(
        prompt: prompt,
        currentConfig: currentConfig,
      );

      if (response != null && response['success'] == true) {
        updateLayout(response);
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('processPrompt error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void updateLayout(Map<String, dynamic> response) {
    if (response['success'] == true) {
      if (response['sectionOrder'] != null) {
        sectionOrder.assignAll(List<String>.from(response['sectionOrder']));
      }
      if (response['sectionConfigs'] != null) {
        final newConfigs = Map<String, Map<String, dynamic>>.from(
          (response['sectionConfigs'] as Map).map(
            (key, value) =>
                MapEntry(key as String, Map<String, dynamic>.from(value)),
          ),
        );
        sectionConfigs
          ..clear()
          ..addAll(newConfigs);
      }
    }
  }

  void _initializeConfigs() {
    sectionConfigs['location'] = {
      'type': 'location',
      'data': {
        'text': 'Downtown, Los Angeles, California, USA',
        'icon': 'location_on',
        'icon_color': '#FF9500',
      },
    };

    sectionConfigs['search_bar'] = {
      'type': 'search_bar',
      'data': {
        'hint_text': 'Search auto parts',
        'border_radius': 30.0,
        'fill_color': '#F2F2F7',
        'content_padding_horizontal': 20.0,
        'content_padding_vertical': 10.0,
      },
    };

    sectionConfigs['carousel'] = {
      'type': 'carousel',
      'data': {
        'height': 200.0,
        'auto_play': true,
        'enlarge_center_page': true,
        'viewport_fraction': 1.0,
        'items': promotionItems,
      },
    };

    sectionConfigs['product_category'] = {
      'type': 'grid_section',
      'title': 'Product Categories',
      'view_all': true,
      'view_all_color': '#FF9500',
      'item_type': 'category',
      'cross_axis_count': 3,
      'cross_axis_spacing': 10.0,
      'main_axis_spacing': 10.0,
      'child_aspect_ratio': 0.8,
      'items': categoryItems,
    };

    sectionConfigs['scheme'] = {
      'type': 'horizontal_list_section',
      'title': 'Special Offers',
      'view_all': true,
      'view_all_color': '#FF9500',
      'item_type': 'scheme',
      'height': 280.0,
      'items': schemeItems,
    };

    sectionConfigs['hot_trending_products'] = {
      'type': 'grid_section',
      'title': 'Trending Auto Parts',
      'view_all': true,
      'view_all_color': '#FF9500',
      'item_type': 'trending',
      'cross_axis_count': 3,
      'cross_axis_spacing': 10.0,
      'main_axis_spacing': 10.0,
      'child_aspect_ratio': 0.8,
      'items': trendingItems,
    };
  }

  void _createBackup() {
    _backupOrder
      ..clear()
      ..addAll(sectionOrder);

    _backupConfigs
      ..clear()
      ..addAll(
        sectionConfigs.map(
          (key, value) => MapEntry(key, Map<String, dynamic>.from(value)),
        ),
      );
  }
}
