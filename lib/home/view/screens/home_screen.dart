import 'package:emd_project/home/controllers/home_controller.dart';
import 'package:emd_project/home/view/screens/story_view_screen.dart';
import 'package:emd_project/home/view/widgets/story_circle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.find<HomeController>();
  int currentUserIndex = 0;

  void openStory(int index) {
    setState(() {
      currentUserIndex = index;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryView(
          stories: homeController.data[currentUserIndex].stories!,
          onNextUser: goToNextUser,
          onPreviousUser: goToPreviousUser,
          username: homeController.data[currentUserIndex].userName!,
        ),
      ),
    );
  }

  // Move to the next user's stories
  void goToNextUser() {
    if (currentUserIndex < homeController.data.length - 1) {
      setState(() {
        currentUserIndex++;
      });

      // Navigate to the next user's first story
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StoryView(
            stories: homeController.data[currentUserIndex].stories!,
            onNextUser: goToNextUser,
            onPreviousUser: goToPreviousUser,
            username: homeController.data[currentUserIndex].userName!,
          ),
        ),
      );
    }
  }

  // Move to the previous user's stories
  void goToPreviousUser() {
    if (currentUserIndex > 0) {
      setState(() {
        currentUserIndex--;
      });

      // Navigate to the previous user's first story
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StoryView(
            stories: homeController.data[currentUserIndex].stories!,
            onNextUser: goToNextUser,
            onPreviousUser: goToPreviousUser,
            username: homeController.data[currentUserIndex].userName!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram'),
      ),
      body: Obx(
        () => LiquidPullToRefresh(
          onRefresh: () async => await homeController.onRefresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: homeController.data.length,
                        itemBuilder: (context, index) {
                          final user = homeController.data[index];
                          return StoryCircle(
                            name: user.userName!,
                            imageUrl: user.profilePicture!,
                            onTap: () {
                              openStory(index);
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
