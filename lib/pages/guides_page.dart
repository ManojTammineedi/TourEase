import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tourease/model/guide_profile.dart';

class Guide {
  String username;
  String image;
  String rating;
  String email;
  String about;

  Guide(this.username, this.image, this.rating, this.email, this.about);
}

class FollowingPage extends StatefulWidget {
  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Select your guide',
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
      body: StreamBuilder<QuerySnapshot?>(
        stream: FirebaseFirestore.instance.collection('guides').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final users = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Guide(
                data['username'] ?? '',
                data['image'] ?? '',
                data['rating'] ?? '',
                data['email'] ?? '',
                data['about'] ?? '',
              );
            }).toList();

            return Container(
              padding: EdgeInsets.only(right: 20, left: 20),
              color: Colors.white,
              height: double.infinity,
              width: double.infinity,
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GuidesProfilePage(guide: users[index]),
                        ),
                      );
                    },
                    child: userComponent(user: users[index]),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget userComponent({required Guide user}) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(user.image),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    user.email,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Ionicons.star,
                color: Colors.yellow[800],
                size: 15,
              ),
              Text(
                '${user.rating}', // Display the rating
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FollowingPage(),
  ));
}
