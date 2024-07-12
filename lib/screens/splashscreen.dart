import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/screens/loginscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Column(
            children: [
              Text(
                'TRADE HUB',
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffED0779),
                ),
              ),
              Text(
                'Exchange it, Make it asset',
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: const Color(0xff02B2E8),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 55),
                    child: Center(
                      child: Image(
                        image: AssetImage('assets/logo.png'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 475, bottom: 30, left: 110, right: 110),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffED0779),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ));
                        },
                        child: const Center(
                            child: Padding(
                          padding: EdgeInsets.only(top: 17, bottom: 17),
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                                color: const Color(0xffffffff),
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
