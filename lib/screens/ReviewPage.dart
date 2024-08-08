
import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReviewPage extends StatefulWidget {
  final List<dynamic> orderHistory;
  final int id;

  const ReviewPage({
    Key? key,
    required this.orderHistory,
    required this.id,
  }) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {


      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReusableAppBar(title: "Review", backButton: true),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.orderHistory.length,
                itemBuilder: (context, index) {
                  widget.orderHistory[index]['rating'] = 0;
                  widget.orderHistory[index]['comment'] = "";
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              child: Image.network(
                                widget.orderHistory[index]['imageURL'],
                                width: MediaQuery.of(context).size.width * 0.30,
                                height: MediaQuery.of(context).size.height * 0.30,
                                fit: BoxFit.cover,
                              ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(" ${widget.orderHistory[index]['name']}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  RatingBar.builder(
                                    initialRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemSize: 30.0,
                                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      widget.orderHistory[index]['rating'] = rating;
                                    },
                                  ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                                    Stack(
                                      children: [
                                        TextField(
                                        maxLines: 2,
                                        maxLength: 100,
                                        decoration: InputDecoration(
                                          hintText: 'Leave comments here...',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                                        ),
        
                                        onChanged: (value) {
                                          widget.orderHistory[index]['comment'] = value;
                                        },
                                      ),
                                      ],
                                    ),
        
                                ],
                              ),
                            ),
                          ),
                        ]
                      )
                    ),
                  );
                },
              ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
            ElevatedButton(
              onPressed: () {
                createReview(widget.orderHistory, widget.id);


                Navigator.pop(context,true);
              },
              child: Text("Submit Review"),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
          ],
        ),
      )
    );
  }
}
