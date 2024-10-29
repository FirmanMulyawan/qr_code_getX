import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  String? uid; // cek kondisi user login

  late FirebaseAuth auth;

  Future<Map<String, dynamic>> login(String email, String pass) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: pass);

      return {"error": false, "message": "Berhasil Login"};
    } on FirebaseAuthException catch (err) {
      return {"error": true, "message": "${err.message}"};
    } catch (e) {
      return {"error": true, "message": "Tidak dapat login"};
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      await auth.signOut();

      return {"error": false, "message": "Berhasil Logout"};
    } on FirebaseAuthException catch (err) {
      return {"error": true, "message": "${err.message}"};
    } catch (e) {
      return {"error": true, "message": "Tidak dapat Logout"};
    }
  }

  @override
  void onInit() {
    auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((event) {
      uid = event?.uid;
    });

    super.onInit();
  }
}
