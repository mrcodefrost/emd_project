import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../model/api_model.dart';

class VideoStory extends StatelessWidget {
  final VideoPlayerController? videoController;
  final Stories currentStory;
  final String username;

  const VideoStory(
      {super.key,
      this.videoController,
      required this.currentStory,
      required this.username});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(child: VideoPlayer(videoController!)),
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username ?? '',
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentStory.text ?? '',
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentStory.textDescription ?? '',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
