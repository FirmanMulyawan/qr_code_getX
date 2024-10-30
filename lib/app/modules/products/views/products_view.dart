import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code/app/data/product_model.dart';
import 'package:qr_code/app/routes/app_pages.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.streamProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("No Products"),
              );
            }

            List<ProductModel> allProducts = [];

            for (var element in snapshot.data!.docs) {
              allProducts.add(ProductModel.fromJson(element.data()));
            }

            return ListView.builder(
              itemCount: allProducts.length,
              padding: EdgeInsets.all(20),
              itemBuilder: (context, index) {
                ProductModel product = allProducts[index];

                return Card(
                  elevation: 5,
                  margin: EdgeInsets.only(bottom: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.detailProduct);
                    },
                    borderRadius: BorderRadius.circular(9),
                    child: Container(
                      height: 100,
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.code,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                // Gap(5),
                                Text(product.name),
                                Text(" jumlah ${product.qty}"),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: QrImageView(
                              data: product.code,
                              size: 200,
                              version: QrVersions.auto,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
