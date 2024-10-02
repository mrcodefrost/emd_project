import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../model/api_model.dart';
import '../widgets/image_story.dart';
import '../widgets/video_story.dart';

class StoryView extends StatefulWidget {
  final List<Stories> stories;
  final Function onNextUser;
  final Function onPreviousUser;
  final String username;

  const StoryView(
      {super.key,
      required this.stories,
      required this.onNextUser,
      required this.onPreviousUser,
      required this.username});

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  int currentStoryIndex = 0;
  VideoPlayerController? _videoController;
  Timer? _imageTimer;
  bool isPaused = false;

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
    _cancelImageTimer();

    // if the current story is a video then initialize the controller
    if (story.mediaType == 'video') {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(story.mediaUrl!))
            ..initialize().then((_) {
              setState(() {}); // Trigger rebuild once video initializes
              _videoController?.play(); // Auto-play video
              _videoController?.setLooping(false); // Play video only once
              _videoController?.addListener(() {
                //  if the video has ended then navigate to the next story
                if (_videoController!.value.position ==
                    _videoController!.value.duration) {
                  _goToNextStory();
                }
              });
            });
    } else if (story.mediaType == 'image') {
      _startImageTimer(); // Start timer for images
    }
  }

  // Timer for images
  void _startImageTimer() {
    _imageTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!isPaused) {
        _goToNextStory();
      }
    });
  }

  // Cancel any running image timers
  void _cancelImageTimer() {
    _imageTimer?.cancel();
    _imageTimer = null;
  }

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
        widget.onNextUser();
      }
      _disposeVideoController(); // Dispose previous video controller
      _cancelImageTimer();
      _loadStory(widget.stories[currentStoryIndex]);
    });
  }

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

      _disposeVideoController();
      _loadStory(widget.stories[currentStoryIndex]);
    });
  }

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
      onHorizontalDragEnd: (details) {
        // Detect horizontal swipe gestures for user story navigation
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          widget.onPreviousUser(); // Swipe Right: Move to previous user
        } else if (details.primaryVelocity != null &&
            details.primaryVelocity! < 0) {
          widget.onNextUser(); // Swipe Left: Move to next user
        }
      },
      onLongPress: () {
        setState(() {
          isPaused = true; // Pause the story on long press
          _videoController?.pause(); // Pause video if it's playing
          _cancelImageTimer(); // Cancel image timer
        });
      },
      onLongPressUp: () {
        setState(() {
          isPaused = false; // Resume the story when long press is released
          if (currentStory.mediaType == 'video') {
            _videoController?.play(); // Resume video if it's paused
          } else if (currentStory.mediaType == 'image') {
            _startImageTimer(); // Resume timer for image
          }
        });
      },
      child: Scaffold(
        body: Center(
          child: currentStory.mediaType == 'image'
              ? ImageStory(
                  currentStory: currentStory,
                  username: widget.username,
                )
              : (_videoController != null &&
                      _videoController!.value.isInitialized)
                  ? VideoStory(
                      videoController: _videoController,
                      currentStory: currentStory,
                      username: widget.username,
                    )
                  : const CircularProgressIndicator(), // loader while video is loading
        ),
      ),
    );
  }
}

// ==================  Ignore below code ====================
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

// // Navigate to the previous story
// void _goToPreviousStory() {
//   setState(() {
//     if (currentStoryIndex > 0) {
//       currentStoryIndex--;
//     } else {
//       widget.onPreviousUser();
//     }
//     _disposeVideoController(); // Dispose previous video controller
//     _loadStory(widget.stories[currentStoryIndex]); // Load new story
//   });
// }
