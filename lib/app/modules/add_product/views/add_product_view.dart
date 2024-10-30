import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  AddProductView({super.key});
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddProductView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: codeC,
            keyboardType: TextInputType.number,
            maxLength: 10,
            decoration: InputDecoration(
                labelText: 'Product Code',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(9))),
          ),
          Gap(20),
          TextField(
            autocorrect: false,
            controller: nameC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: 'Product Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(9))),
          ),
          Gap(20),
          TextField(
            autocorrect: false,
            controller: qtyC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Qunatity',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(9))),
          ),
          Gap(40),
          ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  if (codeC.text.isNotEmpty &&
                      nameC.text.isNotEmpty &&
                      qtyC.text.isNotEmpty) {
                    controller.isLoading(true);

                    Map<String, dynamic> result = await controller.addProduct({
                      "code": codeC.text,
                      "name": nameC.text,
                      "qty": int.parse(qtyC.text),
                    });
                    controller.isLoading(false);

                    Get.back();

                    Get.snackbar(result["error"] == true ? "Error" : "Succes",
                        result["message"]);
                  } else {
                    Get.snackbar("Error", "Semua data wajib diisi");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                  padding: EdgeInsets.symmetric(vertical: 20)),
              child: Obx(() => Text(
                  controller.isLoading.isFalse ? "Add Product" : "Loading...")))
        ],
      ),
    );
  }
}
