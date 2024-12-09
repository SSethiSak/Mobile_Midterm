import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AnimatedCloudWidget extends StatefulWidget {
  @override
  _AnimatedCloudWidgetState createState() => _AnimatedCloudWidgetState();
}

class _AnimatedCloudWidgetState extends State<AnimatedCloudWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _audioPlayer = AudioPlayer();
    _audioPlayer.play(AssetSource('sounds/wind.mp3'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
    // Access MediaQuery inside the build method
    double screenWidth = MediaQuery.of(context).size.width;

    _animation = Tween<double>(
      begin: -200.0, // Start off the screen
      end: screenWidth, // End at the right edge of the screen
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: _animation.value,
          top: MediaQuery.of(context).size.height / 8, // Adjust height here
          child: child!,
        );
      },
      child: Image.asset(
        'assets/images/realistic-white-cloud.png', // Cloud image
        width: 100,
        height: 120,
      ),
    );
  }
}
