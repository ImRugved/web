import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:web_app/Constant/constColors.dart';
import 'package:web_app/Constant/constTextTheme.dart';
import 'package:web_app/Constant/loading.dart';
import 'package:web_app/Constant/rounded_button.dart';
import 'package:web_app/Screens/Login_Screen/Controller/login_controller.dart';
import 'package:web_app/Screens/Login_Screen/View/login_screen.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return SafeArea(
      child: Scaffold(
        body: GetBuilder(
          init: LoginController(),
          id: 'signUp',
          builder: (ctrl) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your account',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: ctrl.userNameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.grey[600],
                            ),
                            hintText: 'Username',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            } else if (value.length < 3) {
                              return 'Username must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: ctrl.emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.grey[600],
                            ),
                            hintText: 'Email',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: ctrl.passController,
                          obscureText: !ctrl.isVisible1.value,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.grey[800],
                              size: 25.sp,
                            ),
                            hintText: 'Password',
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  ctrl.isVisible1.value =
                                      !ctrl.isVisible1.value;
                                  ctrl.update(["signUp"]);
                                },
                                onDoubleTap: () {},
                                child: !ctrl.isVisible1.value
                                    ? Icon(Icons.visibility_off_sharp,
                                        color: ConstColors.modelSheet,
                                        size: 25.sp)
                                    : Icon(Icons.visibility_outlined,
                                        color: ConstColors.modelSheet,
                                        size: 25.sp)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: ctrl.passController,
                          obscureText: !ctrl.isVisible2.value,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.grey[800],
                              size: 25.sp,
                            ),
                            hintText: 'Confirm Password',
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  ctrl.isVisible2.value =
                                      !ctrl.isVisible2.value;
                                  ctrl.update(["signUp"]);
                                },
                                onDoubleTap: () {},
                                child: !ctrl.isVisible2.value
                                    ? Icon(Icons.visibility_off_sharp,
                                        color: ConstColors.modelSheet,
                                        size: 25.sp)
                                    : Icon(Icons.visibility_outlined,
                                        color: ConstColors.modelSheet,
                                        size: 25.sp)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            } else if (value != ctrl.passController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        RoundedButton(
                          press: () {
                            if (formKey.currentState!.validate()) {
                              ctrl.signUp(
                                context,
                                ctrl.emailController.text.trim(),
                                ctrl.passController.text.trim(),
                                ctrl.userNameController.text.trim(),
                              );
                            }
                          },
                          text: 'Sign Up',
                          color: Colors.deepOrange,
                          bordercolor: Colors.deepOrange,
                          radius: 8.sp,
                          style: getTextTheme().bodyMedium,
                        ).toProgress(ctrl.signupLoading),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text('Or'),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.login),
                              SizedBox(width: 8),
                              Text('Login with Google'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            TextButton(
                              onPressed: () {
                                Get.to(() => const LoginForm());
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
