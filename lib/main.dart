import 'package:flutter/material.dart';
import 'study_mode.dart';
import 'notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Study Reminder',
      debugShowCheckedModeBanner: false,
      home: StudyMode(),
    );
  }
}
