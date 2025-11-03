import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'welcome_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      'video': 'videos/onboard1.mp4',
      'title': 'Sync with Nature’s Rhythm',
      'subtitle': 'Find balance by connecting effortlessly with natural cycles.',
      'gradient': const LinearGradient(
  colors: [Color(0xFF082257), Color(0xFF0B0024)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  ),
    },
    {
      'video': 'videos/onboard2.mp4',
      'title': 'Effortless & Automatic Syncing',
      'subtitle': 'Let the app handle your syncing automatically, anytime.',
      'gradient': const LinearGradient(
        colors: [Color(0xFF082257), Color(0xFF0B0024)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    },
    {
      'video': 'videos/onboard3.mp4',
      'title': 'Relax & Unwind',
      'subtitle': 'Enjoy peace and calm as everything stays perfectly aligned.',
      'gradient': const LinearGradient(
        colors: [Color(0xFF082257), Color(0xFF0B0024)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final data = onboardingData[index];
              return Container(
                decoration: BoxDecoration(
                  gradient: data['gradient'] as Gradient?,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    // --- Skip Button ---
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 70, right: 16),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const WelcomeScreen()),
                            );
                          },
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              fontFamily: 'Oxygen',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
//Video Section
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      width: 360,
                      height: 429,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _VideoBackground(videoPath: data['video']),
                    ),

                    //Text Section
                    Container(
                      width: 360,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      child: Column(
                        children: [
                          Text(
                            data['title'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            data['subtitle'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

// --- Page Indicators---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 12 : 8,
                          height: _currentPage == index ? 12 : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.deepPurple
                                : Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),


                    // --- Next Button ---
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: SizedBox(
                        width: 360,
                        height: 76,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          onPressed: () {
                            if (_currentPage == onboardingData.length - 1) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const WelcomeScreen()),
                              );
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Text(
                            _currentPage == onboardingData.length - 1
                                ? 'Get Started'
                                : 'Next',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _VideoBackground extends StatefulWidget {
  final String videoPath;
  const _VideoBackground({required this.videoPath});

  @override
  State<_VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<_VideoBackground> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) async {
        await Future.delayed(const Duration(milliseconds: 200));
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _controller.value.size.width,
        height: _controller.value.size.height,
        child: VideoPlayer(_controller),
      ),
    )
        : const Center(child: CircularProgressIndicator());
  }
}