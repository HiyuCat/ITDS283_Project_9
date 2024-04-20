import 'dart:async';

import 'package:alarm/main.dart';
import 'package:alarm/setting.dart';
import 'package:alarm/timezone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List<Alarm> _alarms = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late Timer _timer;
  String _currentTime = DateFormat('HH:mm').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    // Initialize the local notifications plugin
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Start a timer to update the current time every minute
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _currentTime = DateFormat('HH:mm').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Time:',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              _currentTime,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: _buildAlarmList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final TimeOfDay? pickedTime = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DigitTimePicker(),
            ),
          );
          if (pickedTime != null) {
            setState(() {
              _alarms.add(Alarm(time: pickedTime, isOn: true));
            });
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 190, 9, 63),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClockPage()),
                );
              },
              icon: const Icon(
                IconData(0xee66, fontFamily: 'MaterialIcons'),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimeZoneClock()),
                );
              },
              icon: const Icon(
                IconData(0xe609, fontFamily: 'MaterialIcons'),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                IconData(0xf06bb, fontFamily: 'MaterialIcons'),
                color: Color.fromARGB(255, 190, 9, 63),
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

  Widget _buildAlarmList() {
    return ListView.builder(
      itemCount: _alarms.length,
      itemBuilder: (context, index) {
        final alarm = _alarms[index];
        return ListTile(
          title: Text(
            '${alarm.time.hour}:${alarm.time.minute.toString().padLeft(2, '0')}',
          ),
          leading: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _alarms.removeAt(index);
              });
            },
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: alarm.isOn,
                onChanged: (newValue) {
                  setState(() {
                    _alarms[index].isOn = newValue;
                    if (newValue) {
                      _scheduleNotification(alarm.time);
                    } else {
                      _cancelNotification(index);
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _scheduleNotification(TimeOfDay time) async {
    print('Scheduling notification for ${time.hour}:${time.minute}');
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Alarm',
      'Time to wake up!',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarms',
          channelDescription:
              'Channel for alarm notifications', // Added channelDescription
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _cancelNotification(int index) async {
    await flutterLocalNotificationsPlugin.cancel(index);
  }
}

class DigitTimePicker extends StatefulWidget {
  @override
  _DigitTimePickerState createState() => _DigitTimePickerState();
}

class _DigitTimePickerState extends State<DigitTimePicker> {
  int _selectedHour = 0;
  int _selectedMinute = 0;

  void _selectHour(int hour) {
    setState(() {
      _selectedHour = hour;
    });
  }

  void _selectMinute(int minute) {
    setState(() {
      _selectedMinute = minute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Time'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Selected Time: $_selectedHour:${_selectedMinute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildPicker('Hour', 24, _selectedHour, _selectHour),
                SizedBox(width: 20),
                _buildPicker('Minute', 60, _selectedMinute, _selectMinute),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  TimeOfDay(hour: _selectedHour, minute: _selectedMinute),
                );
              },
              child: Text('Set Alarm'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildPicker(
    String label, int max, int selectedValue, ValueChanged<int> onChanged) {
  return Column(
    children: <Widget>[
      Text(
        label,
        style: TextStyle(fontSize: 18),
      ),
      SizedBox(height: 10),
      Container(
        height: 200,
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListWheelScrollView(
          itemExtent: 50,
          physics: FixedExtentScrollPhysics(),
          children: List.generate(
            max,
            (index) => Center(
              child: Text(
                index.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: 24,
                  color: index == selectedValue ? Colors.blue : Colors.black,
                ),
              ),
            ),
          ),
          onSelectedItemChanged: (index) {
            onChanged(index);
          },
        ),
      ),
    ],
  );
}

class Alarm {
  TimeOfDay time;
  bool isOn;

  Alarm({required this.time, required this.isOn});
}
