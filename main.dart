import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'alarm_page.dart';
import 'Scheduler_Calendar.dart';

void main() {
  runApp(const MyApp());
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
    // Update the time every second
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
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlarmPage()),
              );
            },
            child: const Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.timer,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    "Timer",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 50),
                  ),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor:
                  const Color.fromARGB(255, 113, 113, 113), // <-- Button color
              foregroundColor:
                  const Color.fromARGB(255, 153, 8, 87), // <-- Splash color
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
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
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlarmPage()),
                );
              },
              icon: const Icon(
                IconData(0xee66, fontFamily: 'MaterialIcons'),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                IconData(0xe609, fontFamily: 'MaterialIcons'),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScheduState()),
                );
              },
              icon: const Icon(
                IconData(0xf06bb, fontFamily: 'MaterialIcons'),
              ),
            ),
            IconButton(
              onPressed: () {},
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
