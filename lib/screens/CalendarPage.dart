import 'dart:collection';


import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';

import '../reusableWidgets/reusableColor.dart';
import '../reusableWidgets/reusableFunctions.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'MoreOrderDetailsPage.dart';
import 'ReviewPage.dart';


final kToday = DateTime.now();

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {


  DateTime focusedDay = DateTime.now();
  String selectedDateTime = DateTime.now().toString().split(" ")[0];
  DateTime selectedDate = DateTime.now();

  Map<DateTime, List<Map<String, dynamic>>> calendarData = {};

  LinkedHashMap<DateTime, List<Map<String, dynamic>>> kEvents = LinkedHashMap(
    equals: isSameDay,
    hashCode: getHashCode,
  );


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      calendarData = await getCalendarData();

      if (mounted) {
        setState(() {
          kEvents.addAll(calendarData);
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }



  List<dynamic> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReusableAppBar(title: "Calendar", backButton: true),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
              child: Container(
                decoration: BoxDecoration(
                  color: lightGrey,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    TableCalendar(
                      focusedDay: focusedDay,
                      firstDay: DateTime(1990),
                      lastDay: DateTime(2050),
                      selectedDayPredicate: (day) {
                        return isSameDay(selectedDate, day);
                      },
                      onDaySelected: (selectedDay, newfocusedDay) {
                        setState(() {
                          focusedDay = newfocusedDay;
                          selectedDate = selectedDay;
                          selectedDateTime = selectedDate.toString().split(" ")[0];
                        });
                      },
                      eventLoader: _getEventsForDay,
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Month',
                      },
                      // CalendarBuilders for custom styling.
                      // calendarBuilders: CalendarBuilders(
                      //   selectedBuilder: (context, date, events) => Container(
                      //     margin: const EdgeInsets.all(4.0),
                      //     alignment: Alignment.center,
                      //     decoration: BoxDecoration(
                      //       color: Colors.blue,
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     child: Text(
                      //       date.day.toString(),
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //   ),
                      // ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ],
                ),
              ),
            ),
            // Generate event containers for the selected day
            ..._getEventsForDay(selectedDate).map((event) {
              return Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: BoxDecoration(
                        color: lightPeach,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 1,
                            decoration: BoxDecoration(
                              color: darkPeach,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Pickup Order"),
                                  IconButton(
                                    icon: Icon(Icons.more_horiz),
                                    onPressed: () async {
                                      bool isRefresh = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MoreOrderDetailsPage(
                                            orderDetails: event,
                                          ),
                                        ),
                                      );

                                      if (isRefresh) {
                                        setState(() {
                                          fetchData();
                                        });
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('5-G-1, Promenade,'),
                                        Text('Pickup Time: ${HourFormatter(event['desiredPickupTime'])}'),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Total"),
                                        Text('RM${NumberFormat('##0.00').format(event['total'])}'),
                                      ],
                                    ),
                                  ],
                                ),
                                Text('Pickup Date: ${DayMonthYearFormatter(event['desiredPickupTime'])}'),
                                Text(event['specialRemarks'].isEmpty
                                    ? 'Special Remarks: None'
                                    : 'Special Remarks: ${event['specialRemarks']}'),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Payment Method: ${event["paymentMethod"]}'),
                                    Spacer(),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text('Status: '),
                                        Baseline(
                                          baseline: 0,
                                          baselineType: TextBaseline.alphabetic,
                                          child: Container(
                                              height: MediaQuery.of(context).size.height * 0.045,
                                              decoration: BoxDecoration(
                                                  color:
                                                  event['status'] == 'Pending' ? darkYellow :
                                                  event['status'] == "Cancelled" ? Colors.red :
                                                  Colors.green,
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  (event['status'] == "Completed and Reviewed") ? "Reviewed" : event['status'],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(color: Colors.grey[300]),
                                for (var order in event['orderHistory'])
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(order['name']),
                                      Text(order['quantity'].toString()),
                                    ],
                                  ),

                                if (event['status'] == "Completed")
                                  Column(
                                    children: [
                                      Divider(color: Colors.grey[300]),
                                      Text("Thanks for ordering with us! Please leave a review!"),
                                      ElevatedButton(
                                        child: Text("Leave a review",
                                          style: TextStyle(
                                            color: selectedButtonColor,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: backGroundColor,
                                          side: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        onPressed: () async {
                                          bool isRefresh = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReviewPage(
                                                orderHistory: event['orderHistory'],
                                                id: event['orderID'],
                                                desiredPickupTime: event['desiredPickupTime'],
                                              ),
                                            ),
                                          );
                                          if (isRefresh) {
                                            setState(() {
                                              fetchData();
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}