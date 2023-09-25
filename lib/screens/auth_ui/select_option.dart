import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_network/screens/auth_ui/login.dart';

class SelectOptionScreen extends StatelessWidget {
  const SelectOptionScreen({super.key});

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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: const Alignment(0.0, 1.5), // Điều chỉnh vị trí lên xuống
                  child: Image.asset(
                    'assets/images/instagram.png',
                    width: 150.0,
                  ),
                ),
                const SizedBox(height: 100.0),
                SizedBox(
                  width: 350.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      // Xử lý sự kiện khi nút 1 được nhấn
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: const Color(0xFF003E8F),
                    ),
                    child: const Text(
                      'CONTINUE WITH FACEBOOK',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),
                SizedBox(
                  width: 350.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      // Xử lý sự kiện khi nút 2 được nhấn
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: const Color(0xD7FA3A61),
                    ),
                    child: const Text(
                      'CREATE AN ACCOUNT',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),
                InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Have An Account? ',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Login',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'By Dan Le',
                style: TextStyle(fontSize: 12.0, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}







