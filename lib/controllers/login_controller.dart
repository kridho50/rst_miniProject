import 'package:get/get.dart';
import '../view//home/home_page.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;
  var isPasswordHidden = true.obs; 

  void login() async {
    isLoading.value = true;
    // Tambahkan logika login di sini, seperti memanggil API
    await Future.delayed(Duration(seconds: 2));
    isLoading.value = false;

    // Simulasi login berhasil
    if (email.value == 'user' && password.value == 'user') {
      Get.snackbar('Login', 'Login berhasil');
      Get.off(() => HomePage());  // Navigasi ke HomePage setelah login berhasil
    } else {
      Get.snackbar('Login', 'Email atau password salah');
    }
  }
}
