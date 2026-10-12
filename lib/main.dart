
import 'package:flutter/material.dart';

void main() {
  runApp(const FoodApp());
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF741F),
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'title': 'Discover new tastes',
      'description':
      'Explore delicious meals and discover your next favorite.',
    },
    {
      'title': 'All your favorites',
      'description':
      'Get all your loved foods in one place,\nyou just place the order we do the rest',
    },
    {
      'title': 'Fast delivery',
      'description':
      'Enjoy your favorite food delivered right to your door.',
    },
    {
      'title': 'Enjoy your meal',
      'description':
      'Order now and enjoy delicious food whenever you want.',
    },
  ];

  static const orange = Color(0xFFFF741F);
  static const textColor = Color(0xFF373743);
  static const mutedColor = Color(0xFF85879F);

  void nextPage() {
    if (currentPage < pages.length - 1) {
      setState(() {
        currentPage++;
      });
    } else {
      // Navigate to your login or home screen.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Onboarding completed')),
      );
    }
  }

  void skipOnboarding() {
    setState(() {
      currentPage = pages.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Illustration area
                  SizedBox(
                    height: screenHeight * 0.57,
                    width: double.infinity,
                    child: Center(
                      child: Image.asset(
                        'assets/images/onboarding.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.fastfood,
                            size: 120,
                            color: orange,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Heading
                  Text(
                    pages[currentPage]['title']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description
                  Text(
                    pages[currentPage]['description']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: mutedColor,
                    ),
                  ),

                  const SizedBox(height: 26),

                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPage == index
                              ? orange
                              : const Color(0xFFFFE0D0),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Next button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: const Text(
                        'NEXT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Skip button
                  TextButton(
                    onPressed: skipOnboarding,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: mutedColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}