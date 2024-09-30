import 'dart:async';

import 'package:emd_project/home/temp/story_1.dart';
import 'package:flutter/material.dart';

import '../../temp/story_2.dart';
import '../widgets/progress_bar.dart';

class StoryView extends StatefulWidget {
  const StoryView({super.key});

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  int currentStoryIndex = 0;
  final List userStories = [
    Story1(),
    Story2(),
  ];

  List<double> progressValue = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < userStories.length; i++) {
      progressValue.add(0.0);
    }

    print(progressValue);

    startWatching();
  }

  void startWatching() {
    Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        print(progressValue[currentStoryIndex]);
        print(currentStoryIndex);
        if (progressValue[currentStoryIndex] + 0.01 < 1.0) {
          progressValue[currentStoryIndex] += 0.01;
        } else {
          progressValue[currentStoryIndex] = 1.0;
          timer.cancel();
        }

        if (currentStoryIndex < userStories.length) {
          currentStoryIndex++;

          // restart the timer for next story
          startWatching();
        }
        // no more stories
        else {
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Stack(
        children: [
          userStories[currentStoryIndex],
          ProgressBar(
            progressValue: progressValue[currentStoryIndex],
          ),
        ],
      ),
    );
  }
}
