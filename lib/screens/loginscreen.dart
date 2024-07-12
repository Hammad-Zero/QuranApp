import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/screens/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _passwordValidationError = "";
  String _emailValidationError = "";
  bool _passwordVisible = false;

  Future<void> _loginWithEmailAndPassword(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Input Error'),
            content: Text('Please enter both email and password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUPScreen(),
        ),
      );
    } catch (error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Authentication Error'),
                content: Text('User not found. Please sign up.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (error.code == 'wrong-password') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Authentication Error'),
                content: Text('Incorrect password. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          print("Authentication error: $error");
        }
      }
    }
  }

  void _validatePassword(String password) {
    if (password.length < 6) {
      setState(() {
        _passwordValidationError = "Password must be at least 6 characters";
      });
    } else if (!password.contains(RegExp(r'[A-Z]'))) {
      setState(() {
        _passwordValidationError =
            "Password must contain at least one capital letter";
      });
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      setState(() {
        _passwordValidationError = "Password must contain at least one number";
      });
    } else {
      setState(() {
        _passwordValidationError = "";
      });
    }
  }

  void _validateEmail(String email) {
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() {
        _emailValidationError = "Enter a valid email address";
      });
    } else {
      setState(() {
        _emailValidationError = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  'TRADE HUB',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffED0779),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Exchange it',
                style: GoogleFonts.amiri(fontSize: 22),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 140, right: 140),
                child: Image(image: AssetImage('assets/logo.png')),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(right: 30, left: 30),
                child: TextFormField(
                  controller: _emailController,
                  onChanged: (value) {
                    _validateEmail(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(
                      color: Color(0xff02B2E8),
                    ),
                    fillColor: Colors.transparent,
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.email_rounded,
                      shadows: [BoxShadow(blurRadius: 0.1)],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Color(0xff02B2E8)),
                      borderRadius: BorderRadius.circular(70),
                    ),
                    errorText: _emailValidationError.isNotEmpty
                        ? _emailValidationError
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(right: 30, left: 30),
                child: TextFormField(
                  controller: _passwordController,
                  onChanged: (value) {
                    _validatePassword(value);
                  },
                  obscureText: !_passwordVisible, // Toggle password visibility
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                      shadows: [BoxShadow(blurRadius: 1)],
                    ),
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      color: Color(0xff02B2E8),
                    ),
                    fillColor: Colors.transparent,
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Color(0xff02B2E8)),
                      borderRadius: BorderRadius.circular(70),
                    ),
                    errorText: _passwordValidationError.isNotEmpty
                        ? _passwordValidationError
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff02B2E8),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  _loginWithEmailAndPassword(email, password);
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 30, left: 30),
                  child: Text('Login'),
                ),
              ),
              const SizedBox(height: 30),
              const Text('OR'),
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.only(right: 5, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image(
                      width: 30,
                      height: 30,
                      image: AssetImage('assets/fb.png'),
                    ),
                    Image(
                      width: 30,
                      height: 30,
                      image: AssetImage('assets/google.png'),
                    ),
                    Image(
                      width: 30,
                      height: 30,
                      image: AssetImage('assets/apple.png'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 11),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUPScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign Up here!',
                      style: TextStyle(
                        color: Color(0xff02B2E8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
