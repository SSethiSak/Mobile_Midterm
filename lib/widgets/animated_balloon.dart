import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
class AnimatedBalloonWidget extends StatefulWidget {
  @override
  _AnimatedBalloonWidgetState createState() => _AnimatedBalloonWidgetState();
}

class _AnimatedBalloonWidgetState extends State<AnimatedBalloonWidget> with TickerProviderStateMixin {
  late AnimationController _controllerFloatUp;
  late AnimationController _controllerGrowSize;
  late AnimationController _controllerRotate;
  late AnimationController _controllerPulse;
  late Animation<double> _animationFloatUp;
  late Animation<double> _animationGrowSize;
  late Animation<double> _animationRotate;
  late Animation<double> _animationPulse;

  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _controllerFloatUp =
        AnimationController(duration: Duration(seconds: 8), vsync: this);
    _controllerGrowSize =
        AnimationController(duration: Duration(seconds: 4), vsync: this);
    _controllerRotate =
        AnimationController(duration: Duration(seconds: 4), vsync: this)
        ..repeat(reverse:true);
    _controllerPulse  =
        AnimationController(duration: Duration(seconds: 1), vsync: this)
        ..repeat(reverse: true);

    _audioPlayer = AudioPlayer();




  }

  @override
  void dispose() {
    _controllerFloatUp.dispose();
    _controllerGrowSize.dispose();
    _controllerPulse.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/pop.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    double _balloonHeight = MediaQuery
        .of(context)
        .size
        .height / 2;
    double _balloonWidth = MediaQuery
        .of(context)
        .size
        .height / 3;
    double _balloonBottomLocation = MediaQuery
        .of(context)
        .size
        .height - _balloonHeight;

    _animationFloatUp = Tween(begin: _balloonBottomLocation, end: 0.0).animate(
        CurvedAnimation(parent: _controllerFloatUp, curve: Curves.linear)
    );

    _animationGrowSize = Tween(begin: 50.0, end: _balloonWidth).animate(
        CurvedAnimation(parent: _controllerGrowSize, curve: Curves.linear)
    );
    _animationRotate = Tween(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controllerRotate, curve: Curves.easeInOut)
    );
    _animationPulse = Tween(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controllerPulse, curve: Curves.easeInOut)
    );

    _controllerFloatUp.forward();
    _controllerGrowSize.forward();

    return AnimatedBuilder(
      animation: Listenable.merge([_animationFloatUp, _animationPulse]),
      builder: (context, child) {
        return Transform.scale(
          scale: _animationPulse.value,
          child: Container(
            margin: EdgeInsets.only(
              top: _animationFloatUp.value,
            ),
            width: _animationGrowSize.value,
            child: child,
          ),
        );
      },
        child: GestureDetector(
        onTap: () {
          if (_controllerFloatUp.isCompleted) {
            _controllerFloatUp.reverse();
            _controllerGrowSize.reverse();
          } else {
            _controllerFloatUp.forward();
            _controllerGrowSize.forward();
          }
          _playSound();
        },
        child: RotationTransition(
          turns: _animationRotate,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Shadow layer
              Positioned(
                top: 15, // Adjust offset to position shadow
                left: 10, // Adjust offset to position shadow
                child: Opacity(
                  opacity: 0.2, // Lower opacity for shadow effect
                  child: Image.asset(
                    'assets/images/BeginningGoogleFlutter-Balloon.png',
                    height: _balloonHeight,
                    width: _balloonWidth,
                    color: Colors.black, // Make shadow darker
                    colorBlendMode: BlendMode.srcATop, // Blend for shadow effect
                  ),
                ),
              ),
              // Main balloon image
              Image.asset(
                'assets/images/BeginningGoogleFlutter-Balloon.png',
                height: _balloonHeight,
                width: _balloonWidth,
              ),
            ],
          ),
        ),
        ),
      );

  }
}

