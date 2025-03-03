import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qna_app/Auth/Signin_Screen.dart';
import '../Animations/custom_animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _slideAnimation = Tween<double>(begin: -600.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1.2), weight: 70),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 30),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  Future<void> _initializeAndNavigate() async {
    try {
      await Firebase.initializeApp();
      print('Firebase initialized successfully');
      await Future.delayed(const Duration(milliseconds: 4500)); // Wait for animation
      if (mounted) {
       Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => SigninScreen(isFirebaseInitialized: true), // Passing flag
          ),
        );
      }
    } catch (e) {
      print('Error during initialization: $e');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => SigninScreen(isFirebaseInitialized: true), // Pass the flag even if initialization fails
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
    final centerY = (screenHeight - appBarHeight) / 2;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 70),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFBBDEFB), Color(0xFFE0E0E0)],
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: [
                Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 100,
                  top: centerY + _slideAnimation.value - 130,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 3000),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.5),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 15,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      child: Transform.rotate(
                        angle: _rotateAnimation.value,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Image.asset(
                            'assets/logo.png',
                            width: 370,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  top: centerY + _slideAnimation.value + 100,
                  child: CustomTextAnimation(
                    controller: _controller,
                    text: 'Transform ideas into powerful software solution',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
