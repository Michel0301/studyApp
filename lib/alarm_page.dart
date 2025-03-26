import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// Tracks how many times the alarm has triggered.
int _alarmTriggerCount = 0;
bool get _isLocked => _alarmTriggerCount >= 3;

void _alarmTriggered() {
  _alarmTriggerCount++;
}

void _unlock() {
  _alarmTriggerCount = 0;
}

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final player = AudioPlayer();
  late String motivationalMessage;

  final List<String> messages = [
    "Your mom was right, it's the damn phone!",
    "Quit slacking—time to hit those books!",
    "Time to stop procrastinating and start studying!",
    "No more excuses—your future self is waiting!"
  ];

  @override
  void initState() {
    super.initState();
    // If we are not locked yet, increment the alarm count.
    if (!_isLocked) {
      _alarmTriggered();
    }
    // Pick a random funny message.
    motivationalMessage = messages[Random().nextInt(messages.length)];
    playAlarm();
  }

  void playAlarm() async {
    await player.play(AssetSource('alarm.mp3'));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If locked, show the locked overlay.
    if (_isLocked) {
      return const LockedScreen();
    }
    // Otherwise, show normal alarm screen.
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              motivationalMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                player.stop();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'OK, I\'m studying!',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LockedScreen extends StatefulWidget {
  const LockedScreen({super.key});

  @override
  State<LockedScreen> createState() => _LockedScreenState();
}

class _LockedScreenState extends State<LockedScreen> {
  int tapCount = 0;
  DateTime? firstTapTime;

  void _handleTap() {
    final now = DateTime.now();
    if (firstTapTime == null ||
        now.difference(firstTapTime!) > const Duration(seconds: 2)) {
      // Reset if more than 2 seconds pass between taps.
      firstTapTime = now;
      tapCount = 1;
    } else {
      tapCount++;
    }
    if (tapCount >= 3) {
      // Triple-tap detected => unlock.
      _unlock();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cover entire screen, preventing normal exit.
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'LOCKED',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Pay 0.001 BTC to unlock!',
                style: TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '3KXaSnjicY9gMfjMvbUkefw1Tz1MkPcRAr',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
