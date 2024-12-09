import 'package:flutter/material.dart';
import '../widgets/animated_balloon.dart';
import '../widgets/animated_cloud.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animations')),
      body: SafeArea(
        child: Stack(
          children: [
            // Clouds in the background
            AnimatedCloudWidget(),
            AnimatedBalloonWidget(),
            AnimatedBalloonWidget(),

            // Balloon in the foreground
            Center(child: AnimatedBalloonWidget()),
            AnimatedBalloonWidget(),
          ],
        ),
      ),
    );
  }
}
