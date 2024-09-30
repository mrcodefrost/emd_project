import 'package:emd_project/home/view/screens/story_view_screen.dart';
import 'package:emd_project/home/view/widgets/story_circle.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List users = [
    {
      "name": "John Doe",
      "profilePicUrl": "https://wallpapercave.com/wp/AYWg3iu.jpg",
    },
    {
      "name": "Daniel",
      "profilePicUrl": "https://wallpapercave.com/wp/AYWg3iu.jpg",
    },
    {
      "name": "Max",
      "profilePicUrl": "https://wallpapercave.com/wp/AYWg3iu.jpg",
    },
    {
      "name": "John Andrew",
      "profilePicUrl": "https://wallpapercave.com/wp/AYWg3iu.jpg",
    },
    {
      "name": "Benjamin",
      "profilePicUrl": "https://wallpapercave.com/wp/AYWg3iu.jpg",
    },
  ];

  void openStory() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => StoryView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram'),
      ),
      body: Column(
        children: [
          // Stories Section
          Container(
            height: 150,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return StoryCircle(
                    name: user['name'],
                    imageUrl: user['profilePicUrl'],
                    onTap: () {
                      openStory();
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
