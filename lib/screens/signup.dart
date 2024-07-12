import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/screens/loginscreen.dart';
import 'package:quran_app/screens/modules.dart';

class SignUPScreen extends StatefulWidget {
  const SignUPScreen({super.key});

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _passwordValidationError = "";
  String _emailValidationError = "";
  bool _passwordVisible = false;

  Future<void> _signUpWithEmailAndPassword(
      String username, String email, String password) async {
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Input Error'),
            content: Text('Please enter username, email, and password.'),
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
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } catch (error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'email-already-in-use') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Registration Error'),
                content: Text('This email is already registered.'),
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
          print("Registration error: $error");
        }
      }
    }
  }

  void _validatePassword(String password) {}

  void _validateEmail(String email) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  'TRADE HUB',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffED0779),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 7, left: 140, right: 140),
                child: Image(image: AssetImage('assets/logo.png')),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(top: 15, right: 30, left: 30),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person_2_rounded,
                      shadows: [BoxShadow(blurRadius: 2)],
                    ),
                    hintText: 'Username',
                    hintStyle: const TextStyle(
                      color: Color(0xff02B2E8),
                    ),
                    fillColor: Colors.transparent,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Color(0xff02B2E8)),
                      borderRadius: BorderRadius.circular(70),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
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
                    prefixIcon: const Icon(Icons.email_rounded, shadows: [
                      BoxShadow(
                        blurRadius: 2,
                      )
                    ]),
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
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 15, right: 30, left: 30),
                child: TextFormField(
                  controller: _passwordController,
                  onChanged: (value) {
                    _validatePassword(value);
                  },
                  obscureText: !_passwordVisible, // Toggle password visibility
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, shadows: [
                      BoxShadow(
                        blurRadius: 2,
                      )
                    ]),
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
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff02B2E8),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  String username = _usernameController.text;
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  _signUpWithEmailAndPassword(username, email, password);
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 30, left: 30),
                  child: Text('SignUp'),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModulesScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Login here !',
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
