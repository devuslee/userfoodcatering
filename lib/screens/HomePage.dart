import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CarouselController buttonCarouselController = CarouselController();
  final List<int> _items = [1, 2, 3, 4, 5];
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String balance = 'Loading...';
  String points = 'Loading...';
  String rank = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      balance = await getUserBalance();
      points = await getUserPoints();
      rank = await getUserRank();
      // Fetch points and rank similarly
      setState(() {}); // Update the UI after fetching data
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<List<String>> _getImageUrls() async {
    List<String> imageUrls = [];
    final ListResult result = await _storage.ref('menu').listAll();

    for (var item in result.items) {
      String downloadURL = await item.getDownloadURL();
      imageUrls.add(downloadURL);
    }

    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder<List<String>>(
            future: _getImageUrls(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No images found'));
              } else {
                List<String> imageUrls = snapshot.data!;
                return FlutterCarousel(
                  options: CarouselOptions(
                    height: 400.0,
                    aspectRatio: 2.0,
                    viewportFraction: 1.0,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                    autoPlay: true,
                  ),
                  items: imageUrls.asMap().entries.map((entry) {
                    int index = entry.key;
                    String url = entry.value;
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: 500,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'food_${index + 1}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl: url,
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => Text('Error: $error'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              }
            },
          ),
          const SizedBox(height: 20.0),
          Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Adjust padding as needed
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), // Add border
                borderRadius: BorderRadius.circular(8.0), // Add border radius for rounded corners
              ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ReusableContainer(text: "Wallet", textvalue: balance),
                ReusableContainer(text: "Points", textvalue: points),
                ReusableContainer(text: "Ranks", textvalue: rank),
              ],
            )
          )
        ],
      ),
    );
  }
}
