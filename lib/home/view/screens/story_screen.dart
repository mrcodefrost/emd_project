// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:flutter/material.dart';
// // import 'package:video_player/video_player.dart';
// //
// // import '../../model/story_model.dart';
// // import '../../model/user_model.dart';
// //
// // class StoryScreen extends StatefulWidget {
// //   final List<Story> stories;
// //
// //   const StoryScreen({
// //     super.key,
// //     required this.stories,
// //   });
// //
// //   @override
// //   State<StoryScreen> createState() => _StoryScreenState();
// // }
// //
// // class _StoryScreenState extends State<StoryScreen> with SingleTickerProviderStateMixin {
// //   late PageController _pageController;
// //   late VideoPlayerController _videoPlayerController;
// //   int _currentIndex = 0;
// //   late AnimationController _animationController;
// //
// //   void loadStory({required Story story, bool animateToPage = true}) {
// //     _animationController.stop();
// //     _animationController.reset();
// //     switch (story.mediaType) {
// //       case MediaType.image:
// //         _animationController.duration = story.duration;
// //         _animationController.forward();
// //         break;
// //       case MediaType.video:
// //         // _videoPlayerController = null;
// //         _videoPlayerController.dispose();
// //         _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(story.url))
// //           ..initialize().then((_) {
// //             setState(() {});
// //             if (_videoPlayerController.value.isInitialized) {
// //               _animationController.duration = _videoPlayerController.value.duration;
// //               _videoPlayerController.play();
// //               _animationController.forward();
// //             }
// //           });
// //         break;
// //     }
// //     if (animateToPage) {
// //       _pageController.animateToPage(
// //         _currentIndex,
// //         duration: const Duration(milliseconds: 1),
// //         curve: Curves.easeInOut,
// //       );
// //     }
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _pageController = PageController();
// //     _animationController = AnimationController(vsync: this);
// //
// //     final Story firstStory = widget.stories.first;
// //     loadStory(story: firstStory, animateToPage: false);
// //
// //     // _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.stories[2].url))
// //     //   ..initialize().then((val) => setState(() {}));
// //     //
// //     // _videoPlayerController.play();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _pageController.dispose();
// //     _videoPlayerController.dispose();
// //     _animationController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final story = widget.stories[_currentIndex];
// //
// //     void onTapDown(TapDownDetails details, BuildContext context) {
// //       final screenWidth = MediaQuery.of(context).size.width;
// //       final dx = details.globalPosition.dx;
// //
// //       if (dx < screenWidth / 3) {
// //         // tap on left
// //         if (_currentIndex - 1 >= 0) {
// //           setState(() {
// //             _currentIndex--;
// //             loadStory(story: widget.stories[_currentIndex]);
// //           });
// //         }
// //       } else if (dx > 2 * screenWidth / 3) {
// //         // tap on right
// //         if (_currentIndex + 1 < widget.stories.length) {
// //           setState(() {
// //             _currentIndex++;
// //             loadStory(story: widget.stories[_currentIndex]);
// //           });
// //         } else {
// //           // no more stories
// //           // exits
// //           Navigator.of(context).pop();
// //         }
// //       } else {
// //         // tap on middle
// //         if (story.mediaType == MediaType.video) {
// //           if (_videoPlayerController.value.isPlaying) {
// //             _videoPlayerController.pause();
// //             _animationController.stop();
// //           } else {
// //             _videoPlayerController.play();
// //             _animationController.forward();
// //           }
// //         }
// //       }
// //       _animationController.addStatusListener((status) {
// //         if (status == AnimationStatus.completed) {
// //           _animationController.stop();
// //           _animationController.reset();
// //
// //           if (_currentIndex + 1 < widget.stories.length) {
// //             setState(() {
// //               _currentIndex++;
// //               loadStory(story: widget.stories[_currentIndex]);
// //             });
// //           } else {
// //             // no more stories
// //             Navigator.of(context).pop();
// //           }
// //         }
// //       });
// //     }
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Instagram'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.only(left: 10.0),
// //         child: Column(
// //           children: [
// //             GestureDetector(
// //               onTapDown: (details) => onTapDown(details, context),
// //               child: PageView.builder(
// //                 physics: const NeverScrollableScrollPhysics(),
// //                 controller: _pageController,
// //                 itemCount: widget.stories.length,
// //                 itemBuilder: (context, index) {
// //                   final story = widget.stories[index];
// //                   switch (story.mediaType) {
// //                     case MediaType.image:
// //                       return CachedNetworkImage(
// //                         imageUrl: story.url,
// //                         fit: BoxFit.cover,
// //                       );
// //                     case MediaType.video:
// //                       if (_videoPlayerController.value.isInitialized) {
// //                         return FittedBox(
// //                           fit: BoxFit.cover,
// //                           child: SizedBox(
// //                             width: _videoPlayerController.value.size.width,
// //                             height: _videoPlayerController.value.size.height,
// //                             child: VideoPlayer(_videoPlayerController),
// //                           ),
// //                         );
// //                       }
// //                   }
// //                   return const SizedBox.shrink();
// //                 },
// //               ),
// //             ),
// //             Positioned(
// //               top: 40.0,
// //               left: 10.0,
// //               right: 10.0,
// //               child: Column(
// //                 children: <Widget>[
// //                   Row(
// //                     children: widget.stories
// //                         .asMap()
// //                         .map((i, e) {
// //                           return MapEntry(
// //                             i,
// //                             AnimatedBar(
// //                               animController: _animationController,
// //                               position: i,
// //                               currentIndex: _currentIndex,
// //                             ),
// //                           );
// //                         })
// //                         .values
// //                         .toList(),
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 1.5,
// //                       vertical: 10.0,
// //                     ),
// //                     child: UserInfo(user: story.user),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class AnimatedBar extends StatelessWidget {
// //   final AnimationController animController;
// //   final int position;
// //   final int currentIndex;
// //
// //   const AnimatedBar({
// //     super.key,
// //     required this.animController,
// //     required this.position,
// //     required this.currentIndex,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Flexible(
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 1.5),
// //         child: LayoutBuilder(
// //           builder: (context, constraints) {
// //             return Stack(
// //               children: <Widget>[
// //                 _buildContainer(
// //                   double.infinity,
// //                   position < currentIndex ? Colors.white : Colors.white.withOpacity(0.5),
// //                 ),
// //                 position == currentIndex
// //                     ? AnimatedBuilder(
// //                         animation: animController,
// //                         builder: (context, child) {
// //                           return _buildContainer(
// //                             constraints.maxWidth * animController.value,
// //                             Colors.white,
// //                           );
// //                         },
// //                       )
// //                     : const SizedBox.shrink(),
// //               ],
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // Container _buildContainer(double width, Color color) {
// //   return Container(
// //     height: 5.0,
// //     width: width,
// //     decoration: BoxDecoration(
// //       color: color,
// //       border: Border.all(
// //         color: Colors.black26,
// //         width: 0.8,
// //       ),
// //       borderRadius: BorderRadius.circular(3.0),
// //     ),
// //   );
// // }
// //
// // class UserInfo extends StatelessWidget {
// //   final User user;
// //
// //   const UserInfo({super.key, required this.user});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: <Widget>[
// //         CircleAvatar(
// //           radius: 20.0,
// //           backgroundColor: Colors.grey[300],
// //           backgroundImage: CachedNetworkImageProvider(
// //             user.profilePicUrl,
// //           ),
// //         ),
// //         const SizedBox(width: 10.0),
// //         Expanded(
// //           child: Text(
// //             user.name,
// //             style: const TextStyle(
// //               color: Colors.white,
// //               fontSize: 18.0,
// //               fontWeight: FontWeight.w600,
// //             ),
// //           ),
// //         ),
// //         IconButton(
// //           icon: const Icon(
// //             Icons.close,
// //             size: 30.0,
// //             color: Colors.white,
// //           ),
// //           onPressed: () => Navigator.of(context).pop(),
// //         ),
// //       ],
// //     );
// //   }
// // }
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:video_player/video_player.dart';
//
// import '../../model/story_model.dart';
// import '../../model/user_model.dart';
//
// class StoryScreen extends StatefulWidget {
//   final List<Story> stories;
//
//   const StoryScreen({super.key, required this.stories});
//
//   @override
//   _StoryScreenState createState() => _StoryScreenState();
// }
//
// class _StoryScreenState extends State<StoryScreen> with SingleTickerProviderStateMixin {
//   late PageController _pageController;
//   late AnimationController _animController;
//   late VideoPlayerController _videoController;
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     _animController = AnimationController(vsync: this);
//
//     final Story firstStory = widget.stories.first;
//     _loadStory(story: firstStory, animateToPage: false);
//
//     _animController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _animController.stop();
//         _animController.reset();
//         setState(() {
//           if (_currentIndex + 1 < widget.stories.length) {
//             _currentIndex += 1;
//             _loadStory(story: widget.stories[_currentIndex]);
//           } else {
//             // Out of bounds - loop story
//             // You can also Navigator.of(context).pop() here
//             _currentIndex = 0;
//             _loadStory(story: widget.stories[_currentIndex]);
//           }
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _animController.dispose();
//     _videoController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Story story = widget.stories[_currentIndex];
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTapDown: (details) => _onTapDown(details, story),
//         child: Stack(
//           children: <Widget>[
//             PageView.builder(
//               controller: _pageController,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: widget.stories.length,
//               itemBuilder: (context, i) {
//                 final Story story = widget.stories[i];
//                 switch (story.mediaType) {
//                   case MediaType.image:
//                     return CachedNetworkImage(
//                       imageUrl: story.url,
//                       fit: BoxFit.cover,
//                     );
//                   case MediaType.video:
//                     if (_videoController != null && _videoController.value.isInitialized) {
//                       return FittedBox(
//                         fit: BoxFit.cover,
//                         child: SizedBox(
//                           width: _videoController.value.size.width,
//                           height: _videoController.value.size.height,
//                           child: VideoPlayer(_videoController),
//                         ),
//                       );
//                     }
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),
//             Positioned(
//               top: 40.0,
//               left: 10.0,
//               right: 10.0,
//               child: Column(
//                 children: <Widget>[
//                   Row(
//                     children: widget.stories
//                         .asMap()
//                         .map((i, e) {
//                           return MapEntry(
//                             i,
//                             AnimatedBar(
//                               animController: _animController,
//                               position: i,
//                               currentIndex: _currentIndex,
//                             ),
//                           );
//                         })
//                         .values
//                         .toList(),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 1.5,
//                       vertical: 10.0,
//                     ),
//                     child: UserInfo(user: story.user),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _onTapDown(TapDownDetails details, Story story) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double dx = details.globalPosition.dx;
//     if (dx < screenWidth / 3) {
//       setState(() {
//         if (_currentIndex - 1 >= 0) {
//           _currentIndex -= 1;
//           _loadStory(story: widget.stories[_currentIndex]);
//         }
//       });
//     } else if (dx > 2 * screenWidth / 3) {
//       setState(() {
//         if (_currentIndex + 1 < widget.stories.length) {
//           _currentIndex += 1;
//           _loadStory(story: widget.stories[_currentIndex]);
//         } else {
//           // Out of bounds - loop story
//           // You can also Navigator.of(context).pop() here
//           _currentIndex = 0;
//           _loadStory(story: widget.stories[_currentIndex]);
//         }
//       });
//     } else {
//       if (story.mediaType == MediaType.video) {
//         if (_videoController.value.isPlaying) {
//           _videoController.pause();
//           _animController.stop();
//         } else {
//           _videoController.play();
//           _animController.forward();
//         }
//       }
//     }
//   }
//
//   void _loadStory({required Story story, bool animateToPage = true}) {
//     _animController.stop();
//     _animController.reset();
//     switch (story.mediaType) {
//       case MediaType.image:
//         _animController.duration = story.duration;
//         _animController.forward();
//         break;
//       case MediaType.video:
//         // _videoController = null;
//         _videoController?.dispose();
//         _videoController = VideoPlayerController.network(story.url)
//           ..initialize().then((_) {
//             setState(() {});
//             if (_videoController.value.isInitialized) {
//               _animController.duration = _videoController.value.duration;
//               _videoController.play();
//               _animController.forward();
//             }
//           });
//         break;
//     }
//     if (animateToPage) {
//       _pageController.animateToPage(
//         _currentIndex,
//         duration: const Duration(milliseconds: 1),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
// }
//
// class AnimatedBar extends StatelessWidget {
//   final AnimationController animController;
//   final int position;
//   final int currentIndex;
//
//   const AnimatedBar({
//     super.key,
//     required this.animController,
//     required this.position,
//     required this.currentIndex,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 1.5),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return Stack(
//               children: <Widget>[
//                 _buildContainer(
//                   double.infinity,
//                   position < currentIndex ? Colors.white : Colors.white.withOpacity(0.5),
//                 ),
//                 position == currentIndex
//                     ? AnimatedBuilder(
//                         animation: animController,
//                         builder: (context, child) {
//                           return _buildContainer(
//                             constraints.maxWidth * animController.value,
//                             Colors.white,
//                           );
//                         },
//                       )
//                     : const SizedBox.shrink(),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Container _buildContainer(double width, Color color) {
//     return Container(
//       height: 5.0,
//       width: width,
//       decoration: BoxDecoration(
//         color: color,
//         border: Border.all(
//           color: Colors.black26,
//           width: 0.8,
//         ),
//         borderRadius: BorderRadius.circular(3.0),
//       ),
//     );
//   }
// }
//
// class UserInfo extends StatelessWidget {
//   final User user;
//
//   const UserInfo({super.key, required this.user});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         CircleAvatar(
//           radius: 20.0,
//           backgroundColor: Colors.grey[300],
//           backgroundImage: CachedNetworkImageProvider(
//             user.profilePicUrl,
//           ),
//         ),
//         const SizedBox(width: 10.0),
//         Expanded(
//           child: Text(
//             user.name,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 18.0,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         IconButton(
//           icon: const Icon(
//             Icons.close,
//             size: 30.0,
//             color: Colors.white,
//           ),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ],
//     );
//   }
// }
