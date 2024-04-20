import 'dart:async';

import 'package:alarm/Scheduler_Calendar.dart';
import 'package:alarm/alarm_page.dart';

import 'package:alarm/setting.dart';
import 'package:alarm/timer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:intl/intl.dart';
import 'timezone.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm',
      theme: ThemeData(
        brightness: Brightness.dark, // Set the overall theme brightness to dark
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/main': (context) => ClockPage(),
        '/timezone': (context) => TimeZoneClock(),
        '/alarm_page': (context) => AlarmPage(),
        '/setting': (context) => SettingPage(),
        '/Sechedule_Calendar': (context) => ScheduState(),
        '/timer_page': (context) => TimerPage(),
      },
      home: const ClockPage(),
    );
  }
}

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _updateTime();
      });
    });
  }

  void _updateTime() {
    _currentTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 48, // Adjust size as needed
                  height: 48, // Adjust size as needed
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 113, 113, 113),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => TimerPage()),
                    );
                  },
                  icon: const Icon(
                    Icons.hourglass_bottom,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 300,
              height: 300,
              child: AnalogClock.dark(
                dateTime: _currentTime,
                dialBorderColor: Colors.grey,
                markingRadiusFactor: 0.95,
                hourHandColor: Colors.white,
                minuteHandColor: Colors.white,
                secondHandColor: Colors.red,
                hourNumbers: const [
                  '',
                  '',
                  '3',
                  '',
                  '',
                  '6',
                  '',
                  '',
                  '9',
                  '',
                  '',
                  '12'
                ],
                hourNumberColor: Colors.white,
                markingColor: Colors.white,
                markingWidthFactor: 0.5,
                dialBorderWidthFactor: 0.05,
                centerPointColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20), // Add some spacing
            Text(
              '${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              DateFormat('MMMM dd, yyyy').format(_currentTime),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(
                IconData(0xee66, fontFamily: 'MaterialIcons'),
              ),
              color: Color.fromARGB(255, 190, 9, 63),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TimeZoneClock()),
                );
              },
              icon: const Icon(
                IconData(0xe609, fontFamily: 'MaterialIcons'),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AlarmPage()),
                );
              },
              icon: const Icon(
                IconData(0xf06bb, fontFamily: 'MaterialIcons'),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                );
              },
              icon: const Icon(
                IconData(0xf0164, fontFamily: 'MaterialIcons'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
