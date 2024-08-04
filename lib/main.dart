import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core package
import 'package:security_guard_app/controllers/visitor_controller.dart';
import 'package:security_guard_app/views/auth/home/home_screen.dart';
// import 'package:security_guard_app/views/visitor_management/visitor_registration_screen.dart';
import 'package:security_guard_app/views/visitor_management.dart/visitorlist_screen.dart';
import 'package:security_guard_app/views/visitor_management.dart/visitor_registration_screen.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure proper binding
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize Firebase
  Get.put(VisitorController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MyGate Clone',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/sign_up', page: () => SignUpScreen()),
        GetPage(
            name: '/visitor_registration',
            page: () => VisitorRegistrationScreen()),
        GetPage(name: '/visitor_list', page: () => VisitorListScreen()),
        GetPage(
          name: '/home_screen',
          page: () => HomeScreen(),
        ),
      ],
    );
  }
}
