import 'package:flutter/material.dart';
import 'package:social_network/screens/auth_ui/signup_st2.dart';

class SignUpSt1Screen extends StatelessWidget {
  const SignUpSt1Screen({super.key});

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
                    'Welcome to Instagram!',
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/user.png',
                      width: 100.0, // Kích thước của hình ảnh user.png
                      height: 100.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Xử lý khi nhấn vào icon máy ảnh
                      },
                      child: const Icon(
                        Icons.camera_alt,
                        size: 40.0,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70.0),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.3),
            child: Container(
              width: 350.0, // Độ rộng của ô nhập văn bản
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Color(0xF8F5F5F5),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  border: InputBorder.none,
                ),
                textAlignVertical: TextAlignVertical.center,
                enableInteractiveSelection: false,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.0, 0.95),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpSt2Screen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(350.0, 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                backgroundColor: const Color(0xD7FA3A61),
              ),
              child: const Text(
                'NEXT',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
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
