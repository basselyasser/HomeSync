import 'package:flutter/material.dart';
import '../../configs/constants.dart';
import 'login_screen.dart';

class SplashScreen2 extends StatelessWidget {
  const SplashScreen2({super.key});
  static const id = "splashScreen2";

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
                      height: 300,
                      width: 360,
                      child: Image.asset("assets/images/splash2_home.png"),
                    ),
                    SizedBox(height: screenHeight * 0.06),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Sync Your Home Simplifying Your Life',
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

                  SizedBox(height: screenHeight * 0.08),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, LoginScreen.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.buttonBackgroundColor,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'GET STARTED',
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
                              color: Color(0xffdde8dd),
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
                              color: Color(0xFFA5B79F),
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
