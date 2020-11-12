import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void main() => runApp(DateSelection());

class DateSelection extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DateSelectionPicker(),
    );
  }
}

class DateSelectionPicker extends StatefulWidget {
  @override
  DateSelectionPickerState createState() => DateSelectionPickerState();
}

class DateSelectionPickerState extends State<DateSelectionPicker> {
  List<DateTime> _blackoutDateCollection;
  List<DateTime> _activeDates;

  @override
  void initState() {
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    _activeDates = [
      today,
      today.add(Duration(days: 5)),
      today.add(Duration(days: 10)),
      today.add(Duration(days: 15)),
      today.add(Duration(days: 20)),
      today.add(Duration(days: 25)),
      today.add(Duration(days: 30)),
      today.add(Duration(days: 35))
    ];
    _blackoutDateCollection = <DateTime>[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: SfDateRangePicker(
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.single,
                monthViewSettings: DateRangePickerMonthViewSettings(
                  blackoutDates: _blackoutDateCollection,
                ),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  blackoutDateTextStyle: TextStyle(
                      color: Colors.grey, decoration: TextDecoration.lineThrough),
                ),
                onViewChanged: viewChanged,
              ),
            )
          ],
        ));
  }

  void viewChanged(DateRangePickerViewChangedArgs args) {
    DateTime date;
    DateTime startDate = args.visibleDateRange.startDate;
    DateTime endDate = args.visibleDateRange.endDate;
    List<DateTime> _blackDates = <DateTime>[];
    for (date = startDate;
    date.isBefore(endDate) || date == endDate;
    date = date.add(const Duration(days: 1))) {
      if (_activeDates.contains(date)) {
        continue;
      }

      _blackDates.add(date);
    }
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _blackoutDateCollection = _blackDates;
      });
    });
  }
}
