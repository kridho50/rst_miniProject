import 'package:get/get.dart';
import '../models/models_user.dart';

class UserController extends GetxController {
  var user = UserModel(
    name: 'John Doe',
    email: 'john.doe@example.com',
    avatarUrl: 'https://media.licdn.com/dms/image/C5103AQGopznOeVm_og/profile-displayphoto-shrink_800_800/0/1580738690079?e=1727913600&v=beta&t=m5MKOasXvjg5Rt8O3fycFeE7hHNQT0XC3NpLJpRTfLs',
  ).obs;

  var isPushNotificationEnabled = false.obs;
  var isBiometricEnabled = false.obs;

  void updateUser(String name, String email) {
    user.update((val) {
      if (val != null) {
        val.name = name;
        val.email = email;
      }
    });
  }

  void togglePushNotification(bool value) {
    isPushNotificationEnabled.value = value;
  }

  void toggleBiometric(bool value) {
    isBiometricEnabled.value = value;
  }
}
