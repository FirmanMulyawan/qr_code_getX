import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_code/app/data/product_model.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<ProductModel> allProducts = List<ProductModel>.empty().obs;

  void downloadCatalog() async {
    final pdf = pw.Document();
    // reset all products -> mengatasi duplikat
    allProducts([]);
    // isi data allProduct dari firebase
    var getData = await firestore.collection("products").get();
    for (var element in getData.docs) {
      allProducts.add(ProductModel.fromJson(element.data()));
    }

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        List<pw.TableRow> allData = List.generate(allProducts.length, (index) {
          ProductModel product = allProducts[index];

          return pw.TableRow(children: [
            pw.Padding(
                padding: pw.EdgeInsets.all(20),
                child: pw.Text("${index + 1}",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 10))),
            pw.Padding(
                padding: pw.EdgeInsets.all(20),
                child: pw.Text(product.code,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 10))),
            pw.Padding(
                padding: pw.EdgeInsets.all(20),
                child: pw.Text(product.name,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 10))),
            pw.Padding(
                padding: pw.EdgeInsets.all(20),
                child: pw.Text("${product.qty}",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 10))),
            pw.Padding(
                padding: pw.EdgeInsets.all(20),
                child: pw.BarcodeWidget(
                    color: PdfColor.fromHex("#000000"),
                    height: 50,
                    width: 50,
                    data: product.code,
                    barcode: pw.Barcode.qrCode())),
          ]);
        });

        return [
          pw.Center(
              child: pw.Text("Catalog Product",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 24))),
          pw.SizedBox(height: 20),
          pw.Table(
              border: pw.TableBorder.all(
                  color: PdfColor.fromHex("#000000"), width: 2),
              children: [
                pw.TableRow(children: [
                  // no
                  pw.Padding(
                      padding: pw.EdgeInsets.all(20),
                      child: pw.Text("No",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold))),
                  // kode barang
                  pw.Padding(
                      padding: pw.EdgeInsets.all(20),
                      child: pw.Text("Product Code",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold))),
                  // nama barang
                  pw.Padding(
                      padding: pw.EdgeInsets.all(20),
                      child: pw.Text("Product Name",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold))),
                  // qty
                  pw.Padding(
                      padding: pw.EdgeInsets.all(20),
                      child: pw.Text("Quantity",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold))),
                  // QR Code
                  pw.Padding(
                      padding: pw.EdgeInsets.all(20),
                      child: pw.Text("QR Code",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold))),
                ]),

                // isi data
                ...allData,
              ]),
        ];
      },
    ));

    // simpan
    Uint8List bytes = await pdf.save();

    // buat file kosong
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/myDocument.pdf");

    // memasukkan data di bytes -> file kosong
    await file.writeAsBytes(bytes);

    // open pdf
    await OpenFile.open(file.path);
  }

  Future<Map<String, dynamic>> getProductById(String code) async {
    try {
      var result = await firestore
          .collection("products")
          .where("code", isEqualTo: code)
          .get();

      if (result.docs.isEmpty) {
        // throw "error";
        return {"error": true, "message": "Tidak ada product ini"};
      }
      Map<String, dynamic> data = result.docs.first.data();
      return {
        "error": false,
        "message": "Berhasil mendapatkan detail product",
        "data": ProductModel.fromJson(data),
      };
    } catch (e) {
      return {"error": true, "message": "Tidak mendapatkan detail product"};
    }
  }
}
