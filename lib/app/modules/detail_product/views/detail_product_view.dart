import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../data/product_model.dart';
import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  DetailProductView({super.key});

  final ProductModel product = Get.arguments;
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    codeC.text = product.code;
    nameC.text = product.name;
    qtyC.text = "${product.qty}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Product'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: QrImageView(
                  data: product.code,
                  size: 200,
                  version: QrVersions.auto,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: codeC,
            keyboardType: TextInputType.number,
            readOnly: true,
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
                  if (nameC.text.isNotEmpty && qtyC.text.isNotEmpty) {
                    controller.isLoading(true);
                    Map<String, dynamic> result = await controller.editProduct({
                      "id": product.productId,
                      "name": nameC.text,
                      "qty": int.tryParse(qtyC.text) ?? 0,
                    });
                    controller.isLoading(false);

                    Get.snackbar(result["error"] == true ? "Error" : "Berhasil",
                        result["message"],
                        duration: Duration(seconds: 2));
                  } else {
                    Get.snackbar("Error", "Semua Data wajib diisi",
                        duration: Duration(seconds: 2));
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                  padding: EdgeInsets.symmetric(vertical: 20)),
              child: Obx(() => Text(controller.isLoading.isFalse
                  ? "Update Product"
                  : "Loading..."))),
          TextButton(
              onPressed: () {
                Get.defaultDialog(
                    title: "Delete Product",
                    middleText: "Are you sure to delete this product ?",
                    actions: [
                      OutlinedButton(
                          onPressed: () => Get.back(), child: Text("Cancel")),
                      ElevatedButton(
                          onPressed: () async {
                            controller.isLoadingDelete(true);
                            Map<String, dynamic> result = await controller
                                .deleteProduct(product.productId);
                            controller.isLoadingDelete(false);

                            Get.back();
                            Get.back();
                            Get.snackbar(
                                result["error"] == true ? "Error" : "Berhasil",
                                result["message"],
                                duration: Duration(seconds: 2));
                          },
                          child: Obx(() => controller.isLoadingDelete.isFalse
                              ? Text("Delete")
                              : Container(
                                  padding: EdgeInsets.all(2),
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                    strokeWidth: 1,
                                  ),
                                )))
                    ]);
              },
              child: Text(
                "Delete Product",
                style: TextStyle(color: Colors.red.shade900),
              ))
        ],
      ),
    );
  }
}
