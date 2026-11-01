import 'package:flutter/material.dart';
import 'package:smartclothes/app/smart_clothes_app.dart';
import 'package:smartclothes/core/services/firebase/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Attempt Firebase initialization. If no project is configured, the app
  // continues without Firebase — see docs/firebase-setup.md.
  await FirebaseService.initialize();

  runApp(const SmartClothesApp());
}
