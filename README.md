# Test Project

An AI-powered, dynamically configurable e-commerce home screen built with Flutter.

## Project Overview
This app demonstrates an AI-assisted, highly flexible home screen for an e-commerce experience (auto parts themed by default). Users can type natural-language prompts to:
- Reorder sections (location, search bar, carousel, categories, offers, trending)
- Show/hide sections
- Adjust visual settings (colors via hex codes, paddings, sizes, grid params)
- Tweak content-specific properties (button colors, titles, hints)

Under the hood, the app sends your prompt and current layout configuration to an AI service which returns a JSON describing the updated layout. The UI then updates reactively without a restart.

## Project Architecture

This Flutter app follows the **MVVM (Model-View-ViewModel)** pattern with reactive state management:

### Structure
```
lib/
├── feature/home/
│   ├── view/home_page.dart          # UI layer - HomeScreen widget
│   └── viewmodel/home_viewmodel.dart # Business logic & state management
├── services/
│   └── openai_service.dart          # External API communication
├── utils/
│   └── app_helper.dart              # Helper functions (colors, icons)
└── main.dart                        # App entry point
```

### Key Components

**HomeScreen (View)**
- Renders the dynamic UI based on ViewModel state
- Handles user interactions (prompt input, edit toggle)
- Observes reactive state changes using GetX

**HomeViewModel (ViewModel)**
- Manages section configurations and order
- Handles AI prompt processing with validation
- Implements rate limiting (3-second intervals)
- Contains all UI data (categories, promotions, trending items)

**OpenAIService (Service)**
- Communicates with ChatGPT API
- Includes timeout protection (20 seconds)
- Validates API responses and handles errors gracefully
- Parses AI-generated JSON for layout updates

**AppHelper (Utility)**
- Safe hex-to-color conversion with fallbacks
- Icon name-to-IconData mapping
- Shared utility functions

### Data Flow
1. User enters prompt → HomeScreen
2. Input validation & rate limiting → HomeViewModel
3. API call with current config → OpenAIService
4. AI processes prompt → Returns JSON
5. Layout update → ViewModel updates reactive state
6. UI automatically rebuilds → HomeScreen reflects changes

### State Management
- **GetX** for reactive state management
- Observable collections for section configs and order
- Automatic UI updates when state changes
- Simple dependency injection with Get.put()

## Versions
- Dart SDK: >=3.8.1 <4.0.0
- Flutter: >=3.18.0-18.0.pre.54

Tip: To see your local Flutter version, run `flutter --version` in your terminal.

## Setup

1) Install Flutter and set up your environment.
2) Copy the example environment file and set your own key:

```
cp .env.example .env
# Then edit .env and set CHATGPT_APIKEY to your OpenAI API key
```

3) Get packages:
```
flutter pub get
```

4) Run the app:
```
flutter run
```


## Security Notes
- Never commit real secrets. Keep your actual `.env` local only. The repo ignores `*.env` by default.
- If a secret was ever committed, rotate it immediately and consider purging it from VCS history.
- The app includes basic input validation, API timeouts, and safer parsing of AI responses.

## How it works
- The UI can be reconfigured using natural-language prompts.
- The app sends the prompt and current layout config to the OpenAI API.
- The assistant responds with a JSON that updates section order and configuration.

## Using AI prompts

To use the app:
1. Tap the **Edit** button at the top of the screen to enable prompt input mode
2. Enter your natural-language prompt in the text field that appears
3. The app will send your prompt to the AI service and update the layout accordingly

You can copy/paste these example prompts:

- Change the location text to "California", set the location icon to "person", and change the icon color to Pink.
- Change the search bar background fill color to Black, set its hint text to "Search parts", and set the border radius to 5.
- Move the carousel to the bottom of the screen.
- Change the "Product Categories" section title to "Product".
- In the carousel, change the "BUY NOW" button color to Green.
- In the Special Offers section, change the "Add to Cart" button color to Yellow.
- Set the carousel height to 100.
- Change all "View All" button colors to Red.
- In Product Categories, set cross_axis_count to 4.
- Increase the spacing between grid items in Product Categories: set cross_axis_spacing to 40 and main_axis_spacing to 40.
- Remove all Items from the Trending Products section.
- Remove the Trending Products section entirely.

Tips:
- Be specific about which section you are modifying (e.g., carousel, product_category, scheme, hot_trending_products).
- Use hex colors only.
- If a change affects multiple sections (e.g., "View All" buttons), say so explicitly.

## Tech
- Flutter, GetX
- Carousel for promos, simple validation and rate limiting in ViewModel
