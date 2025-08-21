import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../viewmodel/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  final HomeViewModel viewModel = HomeViewModel();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Location display module
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      'Sector 9, Faridabad, Haryana, India',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // 2. Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // 3. Slider with indicator for promotions
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                ),
                items: viewModel.promotions.map((promo) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Increased radius for more rounded borders
                    ),
                    child: Stack(
                      children: [
                        // Background image (assuming it's dark)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              promo['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200, // Fixed height for slider images
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                promo['title']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                promo['discount']!,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                promo['description']!,
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('BUY NOW'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 16),

              // 4. Product category section
              // Product category section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('View All', style: TextStyle(color: Colors.orange)),
                  ],
                ),
              ),
              SizedBox(height: 8),
              GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true, // Important inside SingleChildScrollView
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Always 3 items in a row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8, // Adjust as per design
                ),
                itemCount: viewModel.categories.length,
                itemBuilder: (context, index) {
                  final cat = viewModel.categories[index];
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          cat['image']!,
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        cat['title']!,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 16),

              // 5. Sales section (list of sales)
              // Assuming it's a vertical list, but could be horizontal if needed
              // ----------------- Scheme Section -----------------
              // ----------------- Scheme Section -----------------
              // ----------------- Scheme Section -----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Scheme',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('View All', style: TextStyle(color: Colors.orange)),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 280, // increased to fit card + title + button
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.sales.length,
                  itemBuilder: (context, index) {
                    final sale = viewModel.sales[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                      ), // left spacing
                      child: Column(
                        children: [
                          // Oval scheme card
                          Container(
                            width: 320,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                100,
                              ), // oval shape
                              gradient: LinearGradient(
                                colors: [Colors.grey[200]!, Colors.blue[100]!],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Discount pill
                                Positioned(
                                  top: 12,

                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      sale['discount']!,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                // Price on left
                                Positioned(
                                  top: 60,
                                  left: 20,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sale['originalPrice']!,
                                        style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        sale['discountedPrice']!,
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Product image on right
                                Positioned(
                                  right: 20,
                                  top: 50,
                                  bottom: 50,
                                  child: Image.network(
                                    sale['image']!,
                                    width: 120,
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 12),

                          // Title outside
                          Text(
                            sale['scheme']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8),

                          // Add to Cart button outside
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: StadiumBorder(),
                              minimumSize: Size(140, 40),
                            ),
                            child: Text('Add to Cart'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 16),

              // 6. Trending products (similar to categories)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hot Trending Products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('View All', style: TextStyle(color: Colors.orange)),
                  ],
                ),
              ),
              SizedBox(height: 8),
              GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Always 3 items in a row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: viewModel.trending.length,
                itemBuilder: (context, index) {
                  final trend = viewModel.trending[index];
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
                                  trend['image']!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                color: Colors.orange,
                                child: Text(
                                  trend['discount']!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Flexible(
                        child: Text(
                          trend['title']!,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
