import 'package:flutter/material.dart';
import '../Animations/home_animation.dart';
import 'homescreen.dart'; // Updated animation import

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFBBDEFB), Color(0xFFE0E0E0)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight - MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo at Top Just Below Notch
                    Padding(
                      padding: EdgeInsets.only(top: 1.0,), // Tight spacing below notch
                      child: HomeScreenAnimation(
                        delay: 0,
                        child: Image.asset(
                          'assets/logo.png', // Ensure your logo matches the screenshot
                          height: screenHeight * 0.12,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // About QnA Technologies Section
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.0,
                      ),
                      child: HomeScreenAnimation(
                        delay: 300,
                        child: Container(
                          width: screenWidth * 0.9,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                spreadRadius: 6,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "About QnA Technologies",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Lora',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "We are a leading technology partner dedicated to transforming your ideas into innovative software solutions. Our team specializes in custom development, cutting-edge coding, and driving business growth through technology.",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Lora',
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Feature Cards Section (Including New Cards)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02,
                      ),
                      child: HomeScreenAnimation(
                        delay: 600,
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildFeatureCard(
                              icon: Icons.settings,
                              title: "Custom Solutions",
                              description: "Tailored software for your needs.",
                            ),
                            _buildFeatureCard(
                              icon: Icons.code,
                              title: "Innovative Development",
                              description: "Cutting-edge coding expertise.",
                            ),
                            _buildFeatureCard(
                              icon: Icons.bar_chart,
                              title: "Business Growth",
                              description: "Drive success with our tools.",
                            ),
                            _buildFeatureCard(
                              icon: Icons.cloud,
                              title: "Other Solutions",
                              description: "Advanced tools for your business.",
                            ),
                            _buildFeatureCard(
                              icon: Icons.support,
                              title: "Support Services",
                              description: "24/7 assistance and updates.",
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10), // Extra spacing at the bottom
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // Floating Action Button with Arrow
      floatingActionButton: HomeScreenAnimation(
        delay: 900,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen())
            );
            // Add navigation to next screen here later
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.arrow_forward, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: 150,
      height: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            spreadRadius: 4,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.green.withOpacity(0.5), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.green),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Lora',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 10,
                fontFamily: 'Lora',
                color: Colors.black),
          ),
        ],
      ),
    );
  }
}