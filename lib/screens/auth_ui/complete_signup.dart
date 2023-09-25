import 'package:flutter/material.dart';

class CompleteSignUpScreen extends StatelessWidget {
  const CompleteSignUpScreen({super.key});

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
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: const BoxDecoration(
                    color: Color(0xE579DCA0),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 80.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0), // Khoảng cách giữa vòng tròn và dòng chữ
                const Text(
                  'Welcome to Instagram!',
                  style: TextStyle(
                    fontFamily: 'HindSiliguri-Regular.ttf',
                    fontSize: 27.0,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 50.0), // Khoảng cách giữa dòng chữ và các nút
                ElevatedButton(
                  onPressed: () {
                    // Xử lý khi nhấn nút 1
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: const Color(0xFF635BD5),
                    minimumSize: const Size(350.0, 50.0),
                  ),
                  child: const Text(
                    'COMPLETE YOUR PROFILE',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 25.0),
                ElevatedButton(
                  onPressed: () {
                    // Xử lý khi nhấn nút 2
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: const Color(0xD7FA3A61),
                    minimumSize: const Size(350.0, 50.0),
                  ),
                  child: const Text(
                    'ADD NEW USER PROFILE',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
