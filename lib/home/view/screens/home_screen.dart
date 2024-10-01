import 'package:emd_project/home/controllers/home_controller.dart';
import 'package:emd_project/home/view/screens/story_view_screen.dart';
import 'package:emd_project/home/view/widgets/story_circle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.find<HomeController>();

  void openStory(int index) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => StoryView(stories: homeController.data[index].stories!)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram'),
      ),
      body: Obx(
        () => Column(
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
    );
  }
}
