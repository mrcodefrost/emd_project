import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../model/api_model.dart';

class StoryView extends StatefulWidget {
  final List<Stories> stories;
  final Function onNextUser;
  final Function onPreviousUser;

  const StoryView(
      {super.key,
      required this.stories,
      required this.onNextUser,
      required this.onPreviousUser});

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  int currentStoryIndex = 0;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.stories.isNotEmpty) {
      _loadStory(widget.stories[currentStoryIndex]);
    }
  }

  void _loadStory(Stories story) {
    // Dispose of any existing video controller
    _disposeVideoController();

    // Check if the current story is a video and initialize the controller
    if (story.mediaType == 'video') {
      _videoController = VideoPlayerController.network(story.mediaUrl!)
        ..initialize().then((_) {
          setState(() {}); // Trigger rebuild once video initializes
          _videoController?.play(); // Auto-play video
          _videoController?.setLooping(false); // Play video only once
          _videoController?.addListener(() {
            // Check if the video has ended to navigate to the next story
            if (_videoController!.value.position ==
                _videoController!.value.duration) {
              _goToNextStory();
            }
          });
        });
    }
  }

  // Dispose video controllers when no longer needed
  void _disposeVideoController() {
    if (_videoController != null) {
      _videoController?.dispose();
      _videoController = null;
    }
  }

  void _goToNextStory() {
    setState(() {
      if (currentStoryIndex < widget.stories.length - 1) {
        currentStoryIndex++;
      } else {
        widget.onNextUser(); // Move to the next user's stories
      }
      _disposeVideoController(); // Dispose previous video controller
      _loadStory(widget.stories[currentStoryIndex]); // Load new story
    });
  }

  // Navigate to the previous story
  void _goToPreviousStory() {
    setState(() {
      if (currentStoryIndex > 0) {
        currentStoryIndex--;
      } else {
        widget.onPreviousUser(); // Move to the previous user's stories
      }
      _disposeVideoController(); // Dispose previous video controller
      _loadStory(widget.stories[currentStoryIndex]); // Load new story
    });
  }

  // // Navigate to the next story
  // void _goToNextStory() {
  //   setState(() {
  //     if (currentStoryIndex < widget.stories.length - 1) {
  //       currentStoryIndex++;
  //     } else {
  //       Navigator.pop(context); // Exit story view if no more stories
  //     }
  //     _disposeVideoController(); // Dispose previous video controller
  //     _loadStory(widget.stories[currentStoryIndex]); // Load new story
  //   });
  // }

  // Handle onTapDown to move to next/previous stories within the same user
  void onTapDown(TapDownDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;

    setState(() {
      // If user taps on the left side, navigate to the previous story
      if (dx < screenWidth / 2 && currentStoryIndex > 0) {
        currentStoryIndex--;
      }
      // If user taps on the right side, navigate to the next story
      else if (dx >= screenWidth / 2 &&
          currentStoryIndex < widget.stories.length - 1) {
        currentStoryIndex++;
      } else {
        Navigator.pop(context);
      }

      _disposeVideoController(); // Dispose video controller to prevent memory leaks
      _loadStory(widget.stories[currentStoryIndex]); // Load new story
    });
  }

  // void onTapDown(TapDownDetails details) {
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final dx = details.globalPosition.dx;
  //
  //   setState(() {
  //     // If user taps on the left side, navigate to the previous story
  //     if (dx < screenWidth / 2 && currentStoryIndex > 0) {
  //       currentStoryIndex--;
  //     }
  //     // If user taps on the right side, navigate to the next story
  //     else if (dx >= screenWidth / 2 &&
  //         currentStoryIndex < widget.stories.length - 1) {
  //       currentStoryIndex++;
  //     } else {
  //       Navigator.pop(context);
  //     }
  //
  //     _disposeVideoController(); // Dispose video controller to prevent memory leaks
  //     _loadStory(widget.stories[currentStoryIndex]); // Load new story
  //   });
  // }

  @override
  void dispose() {
    _disposeVideoController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStory = widget.stories[currentStoryIndex];

    return GestureDetector(
      onTapDown: (details) => onTapDown(details),
      onLongPress: () {
        // pause
      },
      onHorizontalDragEnd: (details) {
        // Detect horizontal swipe gestures for user story navigation
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          widget.onPreviousUser(); // Swipe Right: Move to previous user
        } else if (details.primaryVelocity != null &&
            details.primaryVelocity! < 0) {
          widget.onNextUser(); // Swipe Left: Move to next user
        }
      },
      child: Scaffold(
        body: Center(
          child: currentStory.mediaType == 'image'
              ? ImageStory(currentStory: currentStory)
              : (_videoController != null &&
                      _videoController!.value.isInitialized)
                  ? VideoStory(
                      videoController: _videoController,
                      currentStory: currentStory,
                    ) // Display video player
                  : const CircularProgressIndicator(), // Show a loader while the video initializes
        ),
      ),
    );
  }
}

class ImageStory extends StatelessWidget {
  final Stories currentStory;

  const ImageStory({super.key, required this.currentStory});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Image.network(
            currentStory.mediaUrl!,
            fit: BoxFit.cover, // Make image cover the entire screen
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: Column(
                children: [
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

class VideoStory extends StatelessWidget {
  final VideoPlayerController? videoController;
  final Stories currentStory;

  const VideoStory(
      {super.key, this.videoController, required this.currentStory});

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
                children: [
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

// List<double> progressValue = [];
//
// @override
// void initState() {
//   super.initState();
//
//   for (int i = 0; i < userStories.length; i++) {
//     progressValue.add(0.0);
//   }
//
//   print(progressValue);
//
//   // startWatching();
// }

// void startWatching() {
//   Timer.periodic(Duration(milliseconds: 100), (timer) {
//     print(progressValue[currentStoryIndex]);
//     print(currentStoryIndex);
//     if (progressValue[currentStoryIndex] + 0.1 < 1.0) {
//       setState(() {
//         progressValue[currentStoryIndex] += 0.1;
//       });
//     } else {
//       setState(() {
//         progressValue[currentStoryIndex] = 1.0;
//         timer.cancel();
//       });
//     }
//
//     if (currentStoryIndex < userStories.length - 1) {
//       currentStoryIndex++;
//
//       // restart the timer for next story
//       startWatching();
//     }
//     // no more stories
//     else {
//       logg.e('Why not executed ');
//       Navigator.pop(context);
//     }
//   });
// }

// void onTapDown(TapDownDetails details) {
//   final screenWidth = MediaQuery.of(context).size.width;
//   final dx = details.globalPosition.dx;
//
//   // user taps on first half
//
//   if (dx < screenWidth / 2) {
//     setState(() {
//       // if not the first story
//       if (currentStoryIndex > 0) {
//         // set previous and current story watched percentage back to 0
//         // progressValue[currentStoryIndex - 1] = 0.0;
//         // progressValue[currentStoryIndex] = 0.0;
//
//         // go back to previous story
//         currentStoryIndex--;
//       }
//     });
//   }
//   // user taps on right
//
//   else {
//     setState(() {
//       // if no more stories
//       if (currentStoryIndex < userStories.length - 1) {
//         // finishing current story
//         // progressValue[currentStoryIndex] = 1.0;
//         // go to next story
//         currentStoryIndex++;
//       }
//       // no more stories
//       else {
//         // progressValue[currentStoryIndex] = 1.0;
//         Navigator.pop(context);
//       }
//     });
//   }
// }
