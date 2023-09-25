import 'package:flutter/material.dart';
import 'package:social_network/screens/auth_ui/signup_st1.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              alignment: Alignment(0.6, -1),
              children: [
                Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 90.0,
                    color: Color(0xF8F5F5F5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Positioned(
                  top: 52.0, // Điều chỉnh vị trí theo y để chữ "Welcome Back!" chồng lên "LOGIN"
                  child: Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontFamily: 'HindSiliguri-Regular.ttf',
                      fontSize: 35.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Color(0xF8F5F5F5), // Màu nền xám nhạt
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Color(0xF8F5F5F5), // Màu nền xám nhạt
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  obscureText: true,
                ),

                const SizedBox(height: 20.0),

                SizedBox(
                  width: 350.0, // Tuỳ chỉnh chiều rộng của nút 2
                  height: 50.0, // Tuỳ chỉnh chiều cao của nút 2
                  child: ElevatedButton(
                    onPressed: () {
                      // Xử lý sự kiện khi nút 2 được nhấn
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ), backgroundColor: const Color(0xD7FA3A61), // Đổi màu thành deeppink
                    ),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10.0),
                InkWell(
                  onTap: () {
                    // Xử lý khi nhấn vào "Forgot your Password?"
                  },
                  child: const Text(
                    'Forgot your Password?',
                    style: TextStyle(fontSize: 14.0, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  // Xử lý khi nhấn vào "Don't have an account? Sign up"
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                    const SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => const SignUpSt1Screen(),
                        )
                        );
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(fontSize: 14.0, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 30.0,
            left: 10.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

        ],
      ),
    );
  }
}


