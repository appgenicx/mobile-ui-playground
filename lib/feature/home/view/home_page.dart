import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_helper.dart';
import '../viewmodel/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeViewModel viewModel = Get.put(HomeViewModel());

  final TextEditingController _promptController = TextEditingController();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _processPrompt() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      _showSnackBar('Please enter a prompt');
      return;
    }

    final success = await viewModel.processPrompt(prompt);
    if (success) {
      _promptController.clear();
      _showSnackBar('Layout updated successfully!');
      viewModel.showInput.value = false;
    } else {
      _showSnackBar('Failed to process prompt.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Toggle button for input field
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dynamic Home Screen',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Obx(
                    () => IconButton(
                      icon: Icon(
                        viewModel.showInput.value ? Icons.close : Icons.edit,
                      ),
                      onPressed: () => viewModel.showInput.toggle(),
                    ),
                  ),
                ],
              ),
            ),

            // Input field for prompts
            Obx(
              () => viewModel.showInput.value
                  ? _buildPromptInput()
                  : const SizedBox(),
            ),

            // Main content
            Expanded(
              child: Obx(
                () => SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: viewModel.sectionOrder
                        .map(
                          (id) => viewModel.sectionConfigs[id] == null
                              ? const SizedBox.shrink()
                              : _buildSection(
                                  context,
                                  viewModel.sectionConfigs[id]!,
                                ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptInput() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _promptController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText:
                  'Enter your prompt to modify the home screen layout...\n\nExample: "Move the carousel to the bottom and change the product categories to show 2 columns instead of 3"',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => ElevatedButton(
                onPressed: viewModel.isLoading.value ? null : _processPrompt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: viewModel.isLoading.value
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Processing...',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    : const Text(
                        'Update Layout',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, Map<String, dynamic> section) {
    final String type = section['type'];
    switch (type) {
      case 'location':
        return _buildLocation(section['data']);
      case 'search_bar':
        return _buildSearchBar(section['data']);
      case 'carousel':
        return _buildCarousel(section['data']);
      case 'grid_section':
        return _buildGridSection(context, section);
      case 'horizontal_list_section':
        return _buildHorizontalListSection(context, section);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLocation(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        children: [
          Icon(
            AppHelper.getIconFromName(data['icon']),
            color: AppHelper.hexToColor(data['icon_color']),
          ),
          const SizedBox(width: 8),
          Text(
            data['text'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: data['hint_text'],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(data['border_radius']),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppHelper.hexToColor(data['fill_color']),
          contentPadding: EdgeInsets.symmetric(
            horizontal: data['content_padding_horizontal'],
            vertical: data['content_padding_vertical'],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel(Map<String, dynamic> data) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: data['height'],
            autoPlay: data['auto_play'],
            enlargeCenterPage: data['enlarge_center_page'],
            viewportFraction: data['viewport_fraction'],
          ),
          items: (data['items'] as List<dynamic>).map((promo) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        promo['image'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          promo['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          promo['discount'],
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          promo['description'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppHelper.hexToColor(
                              promo['button_color'],
                            ),
                          ),
                          child: Text(promo['button_text']),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGridSection(BuildContext context, Map<String, dynamic> section) {
    final String itemType = section['item_type'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                section['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (section['view_all'] == true)
                Text(
                  'View All',
                  style: TextStyle(
                    color: AppHelper.hexToColor(section['view_all_color']),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: section['cross_axis_count'],
            crossAxisSpacing: section['cross_axis_spacing'],
            mainAxisSpacing: section['main_axis_spacing'],
            childAspectRatio: section['child_aspect_ratio'],
          ),
          itemCount: (section['items'] as List<dynamic>).length,
          itemBuilder: (context, index) {
            final item = section['items'][index];
            if (itemType == 'category') {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item['image'],
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['title'],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            } else if (itemType == 'trending') {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            color: AppHelper.hexToColor(item['discount_color']),
                            child: Text(
                              item['discount'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      item['title'],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHorizontalListSection(
    BuildContext context,
    Map<String, dynamic> section,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                section['title'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (section['view_all'] == true)
                Text(
                  'View All',
                  style: TextStyle(
                    color: AppHelper.hexToColor(section['view_all_color']),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: section['height'],
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: (section['items'] as List<dynamic>).length,
            itemBuilder: (context, index) {
              final item = section['items'][index];
              return Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: [
                    Container(
                      width: 320,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                          colors: [Colors.grey[200]!, Colors.blue[100]!],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppHelper.hexToColor(
                                  item['discount_pill_color'],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item['discount'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 60,
                            left: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['original_price'],
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  item['discounted_price'],
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 20,
                            top: 50,
                            bottom: 50,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(item['image']),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['scheme'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppHelper.hexToColor(
                          item['button_color'],
                        ),
                        shape: const StadiumBorder(),
                        minimumSize: const Size(140, 40),
                      ),
                      child: Text(item['button_text']),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
