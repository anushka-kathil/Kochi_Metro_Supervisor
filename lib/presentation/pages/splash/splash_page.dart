import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/services/storage_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    // Replace 'assets/videos/splash_video.mp4' with your actual video path
    _videoController = VideoPlayerController.asset('assets/splash_screen.mp4');

    try {
      await _videoController.initialize();
      setState(() {
        _isVideoInitialized = true;
      });

      // Play the video
      _videoController.play();

      // Listen for video completion or navigate after duration
      _videoController.addListener(() {
        if (_videoController.value.position >=
            _videoController.value.duration) {
          _navigateToNextScreen();
        }
      });

      // Fallback navigation in case video doesn't end properly
      Future.delayed(AppConstants.splashDuration, () {
        _navigateToNextScreen();
      });
    } catch (e) {
      print('Error initializing video: $e');
      // Fallback to navigation if video fails to load
      Future.delayed(const Duration(seconds: 2), () {
        _navigateToNextScreen();
      });
    }
  }

  void _navigateToNextScreen() async {
    if (!mounted) return;

    final storageService = Get.find<StorageService>();
    final token = storageService.readString(AppConstants.authTokenKey);

    if (token != null) {
      Get.offAllNamed(AppRoutes.dashboard);
    } else {
      Get.offAllNamed(AppRoutes.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video Player
          if (_isVideoInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),

          // Loading indicator while video loads
          if (!_isVideoInitialized)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }
}
