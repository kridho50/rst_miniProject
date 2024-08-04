import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rst_superapp/controllers/user_controller.dart';
import 'package:local_auth/local_auth.dart';
import '../login_page.dart';

class ProfileTab extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> checkBiometric() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    return canCheckBiometrics;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code),
            onPressed: () {
              _showBarcodeDialog(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar Card
              Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() {
                    return CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userController.user.value.avatarUrl),
                    );
                  }),
                ),
              ),
              SizedBox(height: 16),
              Obx(() {
                return Text(
                  userController.user.value.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                );
              }),
              SizedBox(height: 8),
              Obx(() {
                return Text(
                  userController.user.value.email,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                );
              }),
              SizedBox(height: 16),
              // Edit Profile Button
              ElevatedButton(
                onPressed: () {
                  _showEditDialog(context);
                },
                child: Text('Edit Profile'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 46, 45, 45)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
              SizedBox(height: 16),
              // Menu Card
              Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // Push Notifications Switch
                    Obx(() {
                      return ListTile(
                        leading: Icon(Icons.notifications),
                        title: Text('Push Notifications'),
                        trailing: Switch(
                          value: userController.isPushNotificationEnabled.value,
                          activeColor: Colors.green,
                          onChanged: (bool value) {
                            userController.togglePushNotification(value);
                          },
                        ),
                      );
                    }),
                    Divider(color: Colors.black),
                    // Biometric Switch
                    FutureBuilder<bool>(
                      future: checkBiometric(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.data == true) {
                          return Obx(() {
                            return ListTile(
                              leading: Icon(Icons.fingerprint),
                              title: Text('Face ID/Biometric'),
                              trailing: Switch(
                                value: userController.isBiometricEnabled.value,
                                activeColor: Colors.green,
                                onChanged: (bool value) {
                                  userController.toggleBiometric(value);
                                },
                              ),
                            );
                          });
                        } else {
                          return Container();
                        }
                      },
                    ),
                    const Divider(color: Colors.black),
                    // Logout Button
                    Container(
                      margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                      width: double.infinity,
                      child: InkWell(
                        onTap: () {
                          Get.offAll(() => LoginPage());
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start, // Align to start (left)
                            crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
                            children: [
                              Icon(Icons.logout, color: Colors.black),
                              SizedBox(width: 8),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200], // Warna latar belakang abu-abu muda
          title: Center(child: Text('Edit Profile')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                userController.updateUser(
                  nameController.text,
                  emailController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Save'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 54, 132, 221)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showBarcodeDialog(BuildContext context) {
    const String hardcodedString = "Ryanda Taufik"; // Ganti dengan string hardcode Anda

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text('Barcode')),
          content: Container(
            width: 200,
            height: 200,
            child: Center(
              child: QrImageView(
                data: hardcodedString,
                version: QrVersions.auto,
                size: 150.0,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
