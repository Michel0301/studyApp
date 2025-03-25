import 'package:flutter/material.dart';
import 'alarm_page.dart';

class StudyMode extends StatefulWidget {
  const StudyMode({super.key});

  @override
  State<StudyMode> createState() => _StudyModeState();
}

class _StudyModeState extends State<StudyMode> with WidgetsBindingObserver {
  bool studyModeActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && studyModeActive) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const AlarmPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('🔒🔒🔒        LOCK IN        🔒🔒🔒', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: studyModeActive ? Colors.redAccent : Colors.greenAccent,
          ),
          child: Text(studyModeActive ? '⏹️ Deactivate study mode' : '▶️ Activate study mode',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
          onPressed: () {
            setState(() {
              studyModeActive = !studyModeActive;
            });
          },
        ),
      ),
    );
  }
}
