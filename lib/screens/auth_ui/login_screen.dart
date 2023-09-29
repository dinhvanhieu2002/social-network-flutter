import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:social_network/respository/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String _username = '';
  String _password = '';

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final errorModel =
        await ref.read(authRepositoryProvider).signInWithGoogle();
    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.replace("/");
    } else {
      sMessenger.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }
  }

  void signInWithFacebook(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final errorModel =
        await ref.read(authRepositoryProvider).signInWithFacebook();

    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.replace("/");
    } else {
      sMessenger.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }
  }

  void signInWithCredentials(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final errorModel = await ref
        .read(authRepositoryProvider)
        .signInWithCredentials(_username, _password);
    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.replace("/");
    } else {
      sMessenger.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }
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
                    'Welcome Back!',
                    style: TextStyle(
                      fontFamily: 'HindSiliguri-Regular.ttf',
                      fontSize: 35.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 50.0),
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
                  const SizedBox(height: 10.0),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment
                          .centerRight, //t thấy khi để cái dòng ni bên phải hắn hơi lệch quá. nếu m thích thì sửa lại cho ra giữa
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Forgot your Password?',
                        style: TextStyle(fontSize: 14.0, color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: 350.0, // Tuỳ chỉnh chiều rộng của nút 2
                    height: 50.0, // Tuỳ chỉnh chiều cao của nút 2
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signInWithCredentials(ref, context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        backgroundColor:
                            const Color(0xD7FA3A61), // Đổi màu thành deeppink
                      ),
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20),
                    child: Column(children: [
                      ElevatedButton.icon(
                          onPressed: () => signInWithGoogle(ref, context),
                          icon: Image.asset(
                            'assets/images/google.png',
                            height: 20,
                          ),
                          label: const Text(
                            'Sign in with Google',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(200, 40),
                              alignment: Alignment.center)),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                        onPressed: () => signInWithFacebook(ref, context),
                        icon: Image.asset(
                          'assets/images/facebook.png',
                          height: 20,
                          alignment: Alignment.topLeft,
                        ),
                        label: const Text(
                          'Sign in with Facebook',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size(200, 40)),
                      )
                    ]),
                  )
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
                      "Don't have an account?",
                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                    const SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {
                        Routemaster.of(context).push("/signup");
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
        ],
      ),
    );
  }
}
