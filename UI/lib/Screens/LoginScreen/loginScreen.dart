import 'package:flutter/material.dart';
import 'package:garbageClassification/auth/auth.dart';
import 'package:garbageClassification/common/constants/appSizes.dart';
import 'package:garbageClassification/common/util/appValidation.dart';
import 'package:garbageClassification/router/app_router.dart';
import 'package:garbageClassification/widgets/circular_image.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true; // Biến trạng thái kiểm soát hiển thị mật khẩu

  // Chuyển đổi trạng thái ẩn/hiện mật khẩu
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();

     final authController = AuthController();
      await authController.signIn(context, email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height, // Chiều cao toàn màn hình
          padding: const EdgeInsets.all(20), // Khoảng cách xung quanh
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa nội dung
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // Email
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                        ),
                        filled: true,
                        fillColor: Color(0xFFF1F4FF),
                      ),
                      validator: (value) {
                        return AppValidator.validateEmail(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    // Password
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF1F4FF),
                        suffixIcon: IconButton(
                          onPressed: _togglePasswordVisibility,
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      obscureText: _obscureText, // Ẩn mật khẩu
                      validator: (value) {
                        return AppValidator.validatePassword(value);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Logic khi nhấn nút
                  },
                  child: Text(
                    'Quên mật khẩu?',
                    style: TextStyle(
                      color: Color(0xFF1F41BB),
                      fontSize: AppSizes.fontSizeMd,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  _submit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F41BB), // Màu nền
                  foregroundColor: Colors.white, // Màu chữ
                  padding:
                      const EdgeInsets.symmetric(horizontal: 125, vertical: 20),
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                child: const Text('Đăng nhập'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Chưa có tài khoản? ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: AppSizes.fontSizeMd,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Chuyển hướng đến trang đăng ký
                       Navigator.pushReplacementNamed(
                              context,
                              AppRouter.register,
                            );
                      },
                    child: const Text(
                      'Đăng ký',
                      style: TextStyle(
                        color: Color(0xFF1F41BB),
                        fontSize: AppSizes.fontSizeMd,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Center(
                child: const Text(
                  'Hoặc đăng nhập bằng',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: AppSizes.fontSizeMd,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      /*final authController = AuthController();
                      authController.signInWithGoogle(context);*/
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Màu nền
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Bo góc
                        ),
                        padding: const EdgeInsets.all(5),
                        shadowColor: Colors.grey),
                    child: CircularImages(
                      image: "assets/images/google.png",
                      width: 50,
                      height: 50,
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
