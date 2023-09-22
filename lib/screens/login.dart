import 'package:flutter/material.dart';
 // Đảm bảo thay thế "tên_dự_án" bằng tên dự án của bạn

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Stack(
        children: [

          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white, // Đổi màu nền tùy ý
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(height: 16.0),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Xử lý đăng nhập
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {
                    // Xử lý đăng nhập bằng Facebook
                  },
                  child: const Text('Continue with Facebook'),
                ),
                const SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {
                    // Xử lý đăng nhập bằng Google
                  },
                  child: const Text('Continue with Google'),
                ),
                const SizedBox(height: 8.0),
                InkWell(
                  onTap: () {
                    // Xử lý khi quên mật khẩu được nhấn
                  },
                  child: const Text(
                    'Forgot your Password?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
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
