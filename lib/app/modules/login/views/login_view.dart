import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qr_code/app/controllers/auth_controller.dart';

import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  final TextEditingController emailC =
      TextEditingController(text: "admin@gmail.com");
  final TextEditingController passwordC =
      TextEditingController(text: "Qwerty@123");

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: emailC,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelText: 'Email',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(9))),
          ),
          Gap(40),
          Obx(() => TextField(
                autocorrect: false,
                controller: passwordC,
                keyboardType: TextInputType.text,
                obscureText: controller.isPassword.value,
                decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                        onPressed: () {
                          controller.isPassword.toggle();
                        },
                        icon: Icon(controller.isPassword.isFalse
                            ? Icons.remove_red_eye
                            : Icons.remove_red_eye_outlined)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9))),
              )),
          Gap(100),
          ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
                    controller.isLoading(true);
                    Map<String, dynamic> result =
                        await authController.login(emailC.text, passwordC.text);
                    controller.isLoading(false);

                    if (result["error"] == true) {
                      Get.snackbar("Error!", result["message"]);
                    } else {
                      Get.offAllNamed(Routes.home);
                    }
                  } else {
                    Get.snackbar("Error!", "Email dan Password wajib diisi");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                  padding: EdgeInsets.symmetric(vertical: 20)),
              child: Obx(() =>
                  Text(controller.isLoading.isFalse ? "Login" : "Loading...")))
        ],
      ),
    );
  }
}
