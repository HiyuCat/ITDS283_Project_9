import 'package:alarm/alarm_page.dart';
import 'package:alarm/main.dart';
import 'package:alarm/timezone.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Alarm snooze time'),
              subtitle: Text('setting your alarm snooze time'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Add functionality to navigate to detailed setting page
              },
            ),
            Divider(),
            ListTile(
              title: Text('Your timezone'),
              subtitle: Text('Select your timezone'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Add functionality to navigate to detailed setting page
              },
            ),
            // Add more settings as needed
          ],
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
              onPressed: () {},
              icon: const Icon(
                IconData(0xf0164, fontFamily: 'MaterialIcons'),
                color: Color.fromARGB(255, 190, 9, 63),
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
    home: SettingPage(),
  ));
}
