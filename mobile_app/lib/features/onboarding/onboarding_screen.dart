import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard/dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Privacy First',
      description: 'Your financial logs stay entirely on your device. No cloud sync, no tracking, total privacy.',
      lottieUrl: 'https://assets10.lottiefiles.com/packages/lf20_ndp7p0re.json', // Security/Privacy animation
      color: const Color(0xFF10B981),
    ),
    OnboardingData(
      title: 'Ultra Fast Logging',
      description: 'Record expenses in seconds with zero latency. No loading spinners, ever.',
      lottieUrl: 'https://assets2.lottiefiles.com/packages/lf20_m69yidvw.json', // Rocket/Speed animation
      color: const Color(0xFFFBBF24),
    ),
    OnboardingData(
      title: 'Smart Analytics',
      description: 'Beautiful, interactive charts to help you master your budget offline.',
      lottieUrl: 'https://assets5.lottiefiles.com/packages/lf20_qpwb7iub.json', // Chart/Data animation
      color: const Color(0xFF3B82F6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (v) => setState(() => _currentPage = v),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Container(
                padding: const EdgeInsets.all(40),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Lottie.network(page.lottieUrl, repeat: true, fit: BoxFit.contain),
                    ).animate().scale(duration: 600.ms, curve: Curves.backOut),
                    const SizedBox(height: 48),
                    Text(
                      page.title,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                    const SizedBox(height: 24),
                    Text(
                      page.description,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(_pages.length, (index) => _buildIndicator(index == _currentPage)),
                ),
                ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: 300.ms,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF10B981) : Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  void _next() async {
    if (_currentPage == _pages.length - 1) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_done', true);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const DashboardScreen()));
    } else {
      _controller.nextPage(duration: 600.ms, curve: Curves.easeInOutCubic);
    }
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String lottieUrl;
  final Color color;
  OnboardingData({required this.title, required this.description, required this.lottieUrl, required this.color});
}
