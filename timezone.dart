import 'package:alarm/alarm_page.dart';
import 'package:alarm/main.dart';
import 'package:alarm/setting.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TimeZoneClock extends StatefulWidget {
  @override
  _TimeZoneClockState createState() => _TimeZoneClockState();
}

class _TimeZoneClockState extends State<TimeZoneClock> {
  Map<String, String> timezones = {
    'America/New_York': 'New York',
    'Europe/London': 'London',
    'Asia/Tokyo': 'Tokyo',
  };
  Map<String, String> times = {};

  @override
  void initState() {
    super.initState();
    fetchTimes();
  }

  Future<void> fetchTimes() async {
    for (var timezone in timezones.keys) {
      final response = await http
          .get(Uri.parse('http://worldtimeapi.org/api/timezone/$timezone'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String time = data['datetime'];
        setState(() {
          times[timezone] = time;
        });
      } else {
        throw Exception('Failed to load time for $timezone');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timezone Clock'),
      ),
      body: ListView.builder(
        itemCount: timezones.length,
        itemBuilder: (context, index) {
          final timezone = timezones.keys.toList()[index];
          final location = timezones.values.toList()[index];
          final time = times[timezone] ?? 'Loading...';
          return ListTile(
            title: Text(location),
            subtitle: Text(time),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchTimes,
        backgroundColor: Color.fromARGB(255, 190, 9, 63),
        child: Icon(
          Icons.refresh,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ClockPage()),
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
                color: Color.fromARGB(255, 190, 9, 63),
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

void main() {
  runApp(MaterialApp(
    home: TimeZoneClock(),
  ));
}
