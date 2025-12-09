import 'dart:async';
import 'package:blog_app/feature/auth/presentation/page/login_page.dart';

import 'package:blog_app/feature/onboarding/presentation/widgets/onboarding_content.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Color> _bgColors = [
    const Color(0xFFF2D4D7), // Pastel Pink
    const Color(0xFFEBF7D4), // Pastel Green
    const Color(0xFFF8E3D0), // Pastel Peach
    const Color(0xFFD4EBF7), // Pastel Blue
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < 3) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onGetStarted() async {
    _timer?.cancel();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              // Screen 1: Welcome
              OnboardingContent(
                backgroundColor: _bgColors[3],
                title: 'Applied. \nWaited. Ghosted?',
                description:
                    'Sit back. \nSip your coffee.. \nWe’ll handle the job applications ;)',
                content: Lottie.asset(
                  'assets/lottie/onboarding1.json',
                  height: 320,
                ),
              ),
              // Screen 2: Auto-Apply
              OnboardingContent(
                backgroundColor: _bgColors[1],

                title: 'Auto-Apply\nWhen \n80% Match',
                description:
                    'No luck. \nNo guesswork. \nPure algorithmic hustle...',
                content: Lottie.asset(
                  'assets/lottie/onboarding2.json',
                  height: 320,
                ),
              ),
              // Screen 3: Skill Insights
              OnboardingContent(
                backgroundColor: _bgColors[2],
                title: 'Boost\nYour Skill \nScore',
                description:
                    'We show the \nUPGRADES that make companies\nSwipe right on you :) <3',
                content: Lottie.asset(
                  'assets/lottie/onboarding3.json',
                  height: 320,
                ),
              ),
              // Screen 4: Explore
              OnboardingContent(
                backgroundColor: _bgColors[3],
                title: 'Explore.\nScroll.\nWorthy.',
                description:
                    'Tech news, trends... \n& your own blogs... \nbecause personality matters too :)',
                content: Lottie.asset(
                  'assets/lottie/onboarding4.json',
                  height: 320,
                ),
              ),
            ],
          ),

          // Top Progress Bar
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 4,
                    decoration: BoxDecoration(
                      color: _currentPage >= index
                          ? Colors.black
                          : Color.fromRGBO(0, 0, 0, 0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Bottom Buttons
          Positioned(
            bottom: 40,
            left: 32,
            right: 32,
            child: _currentPage == 3
                ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onGetStarted,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        _pageController.animateToPage(
                          3,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
