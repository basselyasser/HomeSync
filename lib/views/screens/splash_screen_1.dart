import 'package:flutter/material.dart';
import 'package:homesync/views/screens/splash_screen_2.dart';
import '../../configs/constants.dart';

class SplashScreen1 extends StatelessWidget {
  const SplashScreen1({super.key});
  static const id = "splashScreen1";

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  children: [
                    SizedBox(height: screenHeight * 0.12),
                    const Text(
                      'HomeSync',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFA5B79F),
                      ),
                    ),
                    Container(
                      height: 200,
                      width: 200,
                      child: Image.asset("assets/images/splash1_home.png"),
                    ),
                    SizedBox(height: screenHeight * 0.06),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'No matter how far you go, home will be your destination to return to.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: CustomColor.greyTextColor,
                        ),
                      ),
                    ),
                  ]),
              Column(
                children: [
                  const Text(
                    'Let\'s make your home comfortable',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.08),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, SplashScreen2.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.buttonBackgroundColor,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'NEXT',
                      style: TextStyle(
                        color: CustomColor.backgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              color: Color(0xFFA5B79F),
                              shape: BoxShape.circle
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              color: Color(0xffdde8dd),
                              shape: BoxShape.circle
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
