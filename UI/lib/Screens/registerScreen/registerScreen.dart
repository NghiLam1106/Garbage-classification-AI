import 'package:flutter/material.dart';
import 'package:garbageClassification/auth/auth.dart';
import 'package:garbageClassification/common/constants/appSizes.dart';
import 'package:garbageClassification/common/util/appValidation.dart';
import 'package:garbageClassification/router/app_router.dart';
import 'package:garbageClassification/widgets/circular_image.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController passwordController =
      TextEditingController(); // Controller để lưu giá trị mật khẩu
  final TextEditingController emailController =
      TextEditingController(); // Controller để lưu giá trị email
  final TextEditingController fullnameController =
      TextEditingController(); // Controller để lưu giá trị full name
  final TextEditingController confirmPasswordController =
      TextEditingController(); // Controller để lưu giá trị nhập lại mật khẩu

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();

      final authController = AuthController();
        await authController.signUp(
            context, fullnameController.text, email, password);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20), // Khoảng cách xung quanh
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa nội dung
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              const Text(
                'Đăng ký',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // Full name
                    TextFormField(
                      controller: fullnameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                        ),
                        filled: true,
                        fillColor: Color(0xFFF1F4FF),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nhập đầy đủ thông tin';
                        } else if (!RegExp(r"^[a-zA-Z]+([ '-][a-zA-Z]+)*$")
                            .hasMatch(value)) {
                          return 'Username không hợp lệ';
                        }
                        return null;
                      },
                      // onChanged: (value) {
                      //   emailErrorText =
                      // },
                    ),
                    const SizedBox(height: 20),
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
                      // onChanged: (value) {
                      //   emailErrorText =
                      // },
                    ),
                    const SizedBox(height: 20),
                    // Password
                    TextFormField(
                      controller:
                          passwordController, // Gán controller cho password feild
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                        ),
                        filled: true,
                        fillColor: Color(0xFFF1F4FF),
                      ),
                      obscureText: true,
                      validator: (value) {
                        return AppValidator.validatePassword(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    // Confirm password
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                        ), // Ẩn mật khẩu
                        filled: true,
                        fillColor: Color(0xFFF1F4FF),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nhập đầy đủ thông tin';
                        } else if (value != passwordController.text) {
                          return 'Mật khẩu không khớp';
                        }
                        return null;
                      },
                      // onSaved: (value) {
                      //   confirmPassword = value!;
                      // },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  _submit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F41BB), // Màu nền
                  foregroundColor: Colors.white, // Màu chữ
                  padding:
                      const EdgeInsets.symmetric(horizontal: 135, vertical: 20),
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                child: const Text('Đăng ký'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Đã có tài khoản? ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                       Navigator.pushNamed(
                              context,
                              AppRouter.login,
                            );
                          },
                    child: const Text(
                      'Đăng nhập',
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
                      // Logic khi nhấn nút
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Màu nền
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Bo góc
                      ),
                      padding: const EdgeInsets.all(5),
                      shadowColor: Colors.grey,
                    ),
                    child: CircularImages(
                      image: "assets/google.png",
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

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    fullnameController.dispose();
    super.dispose();
  }
}
