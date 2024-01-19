import 'package:e_telka/core/presentation/theme.dart';
import 'package:e_telka/tasks/presentation/tasks_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.setLanguageCode("cs");
  // if (kDebugMode) {
  //   try {
  //     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  //     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e);
  //   }
  // }
  runApp(const EtelkaApp());
}

class EtelkaApp extends StatelessWidget {
  const EtelkaApp({super.key});

  final theme = const VecickyTheme();
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.setLanguageCode("cs");
    final providers = [EmailAuthProvider()];
    return GetMaterialApp(
        theme: theme.toThemeData(),
        initialRoute:
            FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/tasks',
        routes: {
          '/sign-in': (context) {
            return SignInScreen(
              auth: FirebaseAuth.instance,
              providers: providers,
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  Get.offAll(const TasksPage());
                }),
              ],
            );
          },
          '/tasks': (context) {
            return const TasksPage();
          },
        },
        title: 'E-telka',
        home: SignInScreen(
          providers: providers,
          auth: FirebaseAuth.instance,
          actions: [
            AuthStateChangeAction<SignedIn>((context, state) {
              Get.offAll(const TasksPage());
            }),
          ],
        ));
  }
}
