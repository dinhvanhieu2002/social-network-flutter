import 'package:flutter/material.dart';

import 'complete_signup.dart';

class SignUpSt2Screen extends StatelessWidget {
  const SignUpSt2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          const Align(
            alignment: Alignment(-1, -0.60),
            child: Stack(
              alignment: Alignment(-0.5, -1),
              children: [
                Text(
                  'SIGNUP',
                  style: TextStyle(
                    fontSize: 90.0,
                    color: Color(0xF8F5F5F5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Positioned(
                  top: 52.0, // Điều chỉnh vị trí theo y để chữ "Welcome Back!" chồng lên "LOGIN"
                  child: Text(
                    'Monitoring & Wellness!',
                    style: TextStyle(
                      fontFamily: 'HindSiliguri-Regular.ttf',
                      fontSize: 30.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 140.0),
                const SizedBox(
                  width: 350.0,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Color(0xF8F5F5F5),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0), // Khoảng cách giữa Email và Password
                const SizedBox(
                  width: 350.0,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Color(0xF8F5F5F5),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0), // Khoảng cách giữa Password và Confirm Password
                const SizedBox(
                  width: 350.0,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      filled: true,
                      fillColor: Color(0xF8F5F5F5),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0), // Khoảng cách giữa Password và Confirm Password
                SizedBox(
                  width: 350.0,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompleteSignUpScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ), backgroundColor: const Color(0xD7FA3A61), // Đổi màu thành deeppink
                    ),
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 30.0,
            left: 10.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Chuyển về trang trước đó (select_option.dart)
              },
            ),
          ),
        ],
      ),
    );
  }
}
