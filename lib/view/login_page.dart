import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rst_superapp/controllers/login_controller.dart';
import 'package:rst_superapp/controllers/user_controller.dart';

class LoginPage extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final UserController userController = Get.put(UserController());
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticate() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        print('Biometric authentication is not available.');
        return;
      }

      bool isBiometricEnrolled = await _isBiometricEnrolled();
      if (!isBiometricEnrolled) {
        print('No biometrics enrolled.');
        return;
      }

      // Determine localized reason based on platform
      String localizedReason = Platform.isAndroid
          ? 'Scan your fingerprint to authenticate'
          : 'Use Face ID to authenticate';

      bool authenticated = await auth.authenticate(
        localizedReason: localizedReason,
      );
      if (authenticated) {
        loginController.login();
      } else {
        print('Authentication failed.');
      }
    } catch (e) {
      print('Error during authentication: $e');
    }
  }

  Future<bool> _isBiometricEnrolled() async {
    try {
      List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (e) {
      print('Error checking biometric enrollment: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              // Logo
              Image.asset(
                'assets/logo.png', // Sesuaikan path logo Anda
                height: 100,
              ),
              SizedBox(height: 16),
              // Nama Perusahaan
              Text(
                'RST Super App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              // Title Email
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your email address',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 8),
              // TextField Email
              TextField(
                onChanged: (value) => loginController.email.value = value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 16),
              // Title Password
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 8),
              // TextField Password
              Obx(() {
                return TextField(
                  onChanged: (value) => loginController.password.value = value,
                  obscureText: loginController.isPasswordHidden.value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        loginController.isPasswordHidden.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        loginController.isPasswordHidden.value =
                            !loginController.isPasswordHidden.value;
                      },
                    ),
                  ),
                );
              }),
              SizedBox(height: 40),
              // Biometric Icon (Fingerprint or Face ID)
              Obx(() {
                return userController.isBiometricEnabled.value
                    ? IconButton(
                        icon: Icon(Platform.isIOS ? Icons.face : Icons.fingerprint),
                        onPressed: () async {
                          await _authenticate();
                        },
                      )
                    : Container();
              }),
              SizedBox(height: 16),
              // Login Button
              Obx(() {
                bool isButtonDisabled = loginController.email.value.isEmpty || loginController.password.value.isEmpty;

                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isButtonDisabled ? Colors.grey : Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: isButtonDisabled
                        ? null
                        : () async {
                            if (userController.isBiometricEnabled.value) {
                              await _authenticate();
                            } else {
                              if (loginController.email.value.isNotEmpty &&
                                  loginController.password.value.isNotEmpty) {
                                loginController.login();
                              }
                            }
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              color: isButtonDisabled ? Colors.black54 : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: 16),
              // Loading Indicator
              Obx(() {
                return loginController.isLoading.value
                    ? CircularProgressIndicator()
                    : Container();
              }),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15), // Spacer to push content up
            ],
          ),
        ),
      ),
    );
  }
}
