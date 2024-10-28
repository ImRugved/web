import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:web_app/Constant/constColors.dart';
import 'package:web_app/Constant/constTextTheme.dart';
import 'package:web_app/Constant/loading.dart';
import 'package:web_app/Constant/rounded_button.dart';
import 'package:web_app/Screens/Login_Screen/Controller/login_controller.dart';
import 'package:web_app/Screens/Login_Screen/View/signup_screen.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: GetBuilder(
        init: LoginController(),
        id: 'login',
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your credentials for login',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.person_outline, color: Colors.grey[600]),
                      hintText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.passController,
                    obscureText: !controller.isVisible.value,
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.lock_outline, color: Colors.grey[600]),
                      hintText: 'Password',
                      suffixIcon: GestureDetector(
                          onTap: () {
                            controller.isVisible.value =
                                !controller.isVisible.value;
                            controller.update(["login"]);
                          },
                          onDoubleTap: () {},
                          child: !controller.isVisible.value
                              ? Icon(Icons.visibility_off_sharp,
                                  color: ConstColors.modelSheet, size: 25.sp)
                              : Icon(Icons.visibility_outlined,
                                  color: ConstColors.modelSheet, size: 25.sp)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  RoundedButton(
                    press: () {
                      // Validate the form fields
                      if (formKey.currentState != null &&
                          formKey.currentState!.validate()) {
                        controller.emailLogin(
                          context,
                          controller.emailController.text.trim(),
                          controller.passController.text.trim(),
                        );
                      } else {
                        Get.snackbar(
                          'User Alert',
                          'Please enter valid credentials',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    text: 'Login Now',
                    color: Colors.deepOrange,
                    bordercolor: Colors.deepOrange,
                    radius: 8.sp,
                    style: getTextTheme().bodyMedium,
                  ).toProgress(controller.loading),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpForm(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
