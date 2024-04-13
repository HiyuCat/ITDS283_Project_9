import 'package:flutter/material.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List<TimeOfDay> _alarms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarms'),
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
              _alarms.add(pickedTime);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildAlarmList() {
    return ListView.builder(
      itemCount: _alarms.length,
      itemBuilder: (context, index) {
        final alarm = _alarms[index];
        return ListTile(
          title:
              Text('${alarm.hour}:${alarm.minute.toString().padLeft(2, '0')}'),
        );
      },
    );
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
              'Selected Time:',
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
}
