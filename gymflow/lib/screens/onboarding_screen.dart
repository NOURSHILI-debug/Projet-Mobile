import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Widgets/onboarding_page.dart';
import '../Widgets/button.dart';

class OnboardingScreen extends StatefulWidget {

  const OnboardingScreen({super.key});

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();

}

class OnBoardingScreenState extends State<OnboardingScreen> {
  //Keeps track of which page we're on
  final PageController _controller = PageController(viewportFraction: 1.0001);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Stack(
        children: [
          PageView(
            controller: _controller,
            physics: const ClampingScrollPhysics(),
            children: const [
              OnboardingPage(
                imagePath: 'assets/images/onboarding_screen/image1.jpg',
                title: "Welcome to GymFlow",
                description: 'Track your workouts and stay motivated every day !',
              ),
              OnboardingPage(
                imagePath: 'assets/images/onboarding_screen/image2.jpg',
                title: "Connect with Your Coach Instantly",
                description: 'Get personalized guidance and support from certified trainers',
                ),
              OnboardingPage(
                imagePath: 'assets/images/onboarding_screen/image3.jpg',
                title: "Manage Your Gym Anytime",
                description: 'Book classes, track attendance, and manage your membership all in one place!'
                ),
            ],
          ),
          ExpandingDots(controller: _controller),
          GetStartedButton(),
        ],
      ),
    );
  }
}

class GetStartedButton extends StatelessWidget {
  const GetStartedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 120,
      left: 90,
      child: Center(
        child: SizedBox(
          width: 250,
          height: 45,
          child: CustomButton(
            text: "Get Started",
            fontFamily: 'StackSansText',
            useGradientText: true,
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          
        ),
        
      ),
    );
  }
}


class ExpandingDots extends StatelessWidget {
  const ExpandingDots({
    super.key,
    required PageController controller,
  }) : _controller = controller;

  final PageController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, 0.57),
      child: SmoothPageIndicator(
        controller: _controller,
        count: 3,
        effect: ExpandingDotsEffect(
          activeDotColor: Colors.red, dotColor: Colors.grey,
          dotHeight: 8,
          dotWidth: 10,
          spacing: 10,
          expansionFactor: 10
          ),
        ),
    );
  }
}
