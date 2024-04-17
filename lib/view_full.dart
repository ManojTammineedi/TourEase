import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tourease/pages/tourist_details_page.dart';
import 'package:tourease/widget/distance.dart';

class ViewFull extends StatefulWidget {
  @override
  _ViewFullState createState() => _ViewFullState();
}

class _ViewFullState extends State<ViewFull> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'View All location',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 20,
          color: Colors.black,
          icon: const Icon(Ionicons.chevron_back),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('recommended_places')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: Unable to load data');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final nearbyPlaces = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Column(
              children: nearbyPlaces.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    height: 135,
                    width: double.maxFinite,
                    child: Card(
                      elevation: 0.4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TouristDetailsPage(
                                image: data['image'],
                                rating: data['rating'],
                                location: data['location'],
                                description: data['description'],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  data['image'],
                                  height: double.maxFinite,
                                  width: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['location'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 10),
                                    // DISTANCE WIDGET
                                    Distance(
                                      fromLocation:
                                          'Accra', // Your starting location
                                      toLocation: data[
                                          'location'], // Get location from Firestore
                                    ),

                                    const Spacer(),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow.shade700,
                                          size: 14,
                                        ),
                                        Text(
                                          data['rating'].toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        const Spacer(),
                                        RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              text: "${data['price']}rs",
                                              children: const [
                                                TextSpan(
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black54,
                                                    ),
                                                    text: "/ Person")
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
