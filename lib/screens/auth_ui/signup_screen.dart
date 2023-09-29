import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network/screens/auth_ui/login_screen.dart';
import 'package:social_network/respository/auth_repository.dart';
import 'package:routemaster/routemaster.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  String _username = '';
  String _email = '';
  String _fullName = '';
  String _password = '';

  void signUpWithCredentials(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final errorModel = await ref
        .read(authRepositoryProvider)
        .signUpWithCredentials(_email, _username, _fullName, _password);
    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.replace("/");
    } else {
      sMessenger.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }
  }

  bool _isValidEmail(String email) {
    // Email validation using regex
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(email);
  }

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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome Newbie!',
                    style: TextStyle(
                      fontFamily: 'HindSiliguri-Regular.ttf',
                      fontSize: 35.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full name is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _fullName = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      filled: true,
                      fillColor: Color(0xF8F5F5F5), // Màu nền xám nhạt
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _username = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      fillColor: Color(0xF8F5F5F5), // Màu nền xám nhạt
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!_isValidEmail(value)) {
                        return 'Email is not valid';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Color(0xF8F5F5F5), // Màu nền xám nhạt
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: const Color(0xF8F5F5F5), // Màu nền xám nhạt
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  SizedBox(
                    width: 350.0, // Tuỳ chỉnh chiều rộng của nút 2
                    height: 50.0, // Tuỳ chỉnh chiều cao của nút 2
                    child: ElevatedButton(
                      onPressed: () {
                        signUpWithCredentials(ref, context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        backgroundColor:
                            const Color(0xD7FA3A61), // Đổi màu thành deeppink
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
                      "Have an account?",
                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                    const SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(fontSize: 14.0, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
