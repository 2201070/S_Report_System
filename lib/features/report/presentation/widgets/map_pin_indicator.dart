import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MapPinIndicator extends StatefulWidget {
  const MapPinIndicator({super.key});

  @override
  State<MapPinIndicator> createState() => _MapPinIndicatorState();
}

class _MapPinIndicatorState extends State<MapPinIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _pulseScale;
  late Animation<double> _pulseOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _bounceAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -10).chain(CurveTween(curve: Curves.easeOut)), 
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -10, end: 0).chain(CurveTween(curve: Curves.easeIn)), 
        weight: 50,
      ),
    ]).animate(_controller);

    _pulseScale = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.5).chain(CurveTween(curve: Curves.easeOut)), 
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), 
        weight: 50,
      ),
    ]).animate(_controller);

    _pulseOpacity = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.5, end: 0.0).chain(CurveTween(curve: Curves.easeOut)), 
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.5).chain(CurveTween(curve: Curves.easeIn)), 
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Pulsating Circle
        Positioned(
          bottom: -16, // Adjust to center the pulse under the pin tip
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _pulseOpacity.value,
                child: Transform.scale(
                  scale: _pulseScale.value,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.accentBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Bouncing Pin
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              // Negative offset moves the pin UP so the tip points to center
              offset: Offset(0, _bounceAnimation.value - 24),
              child: const Icon(
                Icons.location_on,
                color: AppColors.accentBlue,
                size: 48,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 8),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
