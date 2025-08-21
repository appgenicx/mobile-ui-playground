class HomeViewModel {
  // Sample data for promotions (sliders)
  final List<Map<String, String>> promotions = [
    {
      'image': 'https://picsum.photos/200/400',
      'title': 'Air Filter',
      'discount': '10% Off',
      'description': 'Durable & Reliable ✓ High Flow air filter ✓ Easy to Fit',
    },
    // Add more promotions if needed
  ];

  // Sample product categories
  final List<Map<String, String>> categories = [
    {
      'image': 'https://picsum.photos/100',
      'title': 'Service Parts',
      'discount': '40% Off',
    },
    {
      'image': 'https://picsum.photos/100',
      'title': 'Belt & Chain Sprocket',
      'discount': '40% Off',
    },
    {
      'image': 'https://picsum.photos/100',
      'title': 'Cables',
      'discount': '40% Off',
    },
    {
      'image': 'https://picsum.photos/100',
      'title': 'Plastic & Body Parts',
      'discount': '40% Off',
    },
    {
      'image': 'https://picsum.photos/100',
      'title': 'Locks',
      'discount': '40% Off',
    },
    {
      'image': 'https://picsum.photos/100',
      'title': 'Light Parts',
      'discount': '40% Off',
    },
  ];

  // Sample sales items
  final List<Map<String, String>> sales = [
    {
      'image': 'https://picsum.photos/200/300',
      'originalPrice': '₹18,000',
      'discountedPrice': '₹10,000',
      'discount': '44% OFF',
      'scheme': 'Chota Kit Bada Dhamaka',
    },
    {
      'image': 'https://picsum.photos/200/300',
      'originalPrice': '₹18,000',
      'discountedPrice': '₹10,000',
      'discount': '44% OFF',
      'scheme': 'Chota Kit Bada Dhamaka',
    },
    // Add more sales if needed
  ];

  // Sample trending products (similar to categories)
  final List<Map<String, String>> trending = [
    {
      'image': 'https://picsum.photos/100',
      'title': 'Engine Oil Hero Splender',
      'discount': 'Upto 40% Off',
    },
    {
      'image': 'https://picsum.photos/100',
      'title': 'Belt & Chain Sprocket Hero Splender',
      'discount': '35% Off',
    },
    {
      'image': 'https://picsum.photos/100',
      'title': 'Engine Oil MDQ-50',
      'discount': 'Upto 40% Off',
    },
    // Add more
  ];
}
