import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int currentButtonIndex = 0;

  List allHistory = [];

  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      allHistory = await returnAllOrderHistory();
      print(allHistory[0]);
      setState(() {}); // Update the UI after fetching data
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentButtonIndex = 0;
                      });
                    },
                    child: Text(
                      'All',
                      style: TextStyle(
                        color: currentButtonIndex == 0 ? Colors.white : Colors.blue,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentButtonIndex == 0 ? Colors.blue : Colors.white,
                      side: BorderSide(
                        color: Colors.grey,
                      ),

                    )
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentButtonIndex = 1;
                      });
                    },
                    child: Text(
                      'Active',
                      style: TextStyle(
                        color: currentButtonIndex == 1 ? Colors.white : Colors.blue,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentButtonIndex == 1 ? Colors.blue : Colors.white,
                      side: BorderSide(
                        color: Colors.grey,
                      ),
                    )
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentButtonIndex = 2;
                      });
                    },
                    child: Text(
                      'Past',
                      style: TextStyle(
                        color: currentButtonIndex == 2 ? Colors.white : Colors.blue,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentButtonIndex == 2 ? Colors.blue : Colors.white,
                      side: BorderSide(
                        color: Colors.grey,
                      ),

                    )
                ),
              ],
            ),
            if (currentButtonIndex == 0)
              Column(
                children: [
                  for (var order in allHistory)
                    ListTile(
                      title: Text(order.orderHistory[0]['name'].toString()),
                      subtitle: Text(order.total.toString()),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                ],
              ),
            if (currentButtonIndex == 1)
              Column(
                children: [
                  ListTile(
                    title: Text('Order 1'),
                    subtitle: Text('Order 1 details'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    title: Text('Order 2'),
                    subtitle: Text('Order 2 details'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            if (currentButtonIndex == 2)
              Column(
                children: [
                  ListTile(
                    title: Text('Order 3'),
                    subtitle: Text('Order 3 details'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
          ],
        ),
      )
    );
  }
}
