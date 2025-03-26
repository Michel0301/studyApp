import 'dart:async';
import 'package:flutter/material.dart';
import 'alarm_page.dart';
import 'notification_service.dart';

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> with WidgetsBindingObserver {
  int sessionDuration = 25; // in minutes
  int breakDuration = 5; // in minutes
  bool isSession = true;
  int remainingSeconds = 25 * 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    resetTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    NotificationService().cancelNotification(0);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When the app resumes and the timer hasn't finished, trigger the alarm.
    if (state == AppLifecycleState.resumed && remainingSeconds > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AlarmPage()),
      );
    }
  }

  void resetTimer() {
    setState(() {
      remainingSeconds = (isSession ? sessionDuration : breakDuration) * 60;
    });
    updateNotification();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
        updateNotification();
      } else {
        setState(() {
          isSession = !isSession;
          resetTimer();
        });
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    NotificationService().cancelNotification(0);
  }

  void updateNotification() {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final timeString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    NotificationService().showNotification(
      id: 0,
      title: isSession ? 'Study session' : 'Break',
      body: 'Time Remaining: $timeString',
    );
  }

  String get timeDisplay {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Study timer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              isSession ? 'Study session' : 'Break',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              timeDisplay,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: startTimer,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: stopTimer,
                  child: const Text('Stop'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    stopTimer();
                    resetTimer();
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Configure timer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Session: '),
                DropdownButton<int>(
                  value: sessionDuration,
                  items: [15, 20, 25, 30, 35, 40]
                      .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text('$e min'),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        sessionDuration = value;
                        if (isSession) resetTimer();
                      });
                    }
                  },
                ),
                const SizedBox(width: 20),
                const Text('Break: '),
                DropdownButton<int>(
                  value: breakDuration,
                  items: [3, 5, 7, 10]
                      .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text('$e min'),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        breakDuration = value;
                        if (!isSession) resetTimer();
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
