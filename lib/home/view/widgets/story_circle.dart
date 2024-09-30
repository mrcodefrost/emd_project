import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StoryCircle extends StatelessWidget {
  final String imageUrl;
  final String name;
  final VoidCallback onTap;

  const StoryCircle({super.key, required this.imageUrl, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                gradient: const LinearGradient(colors: instagramColorsGradient),
                border: Border.all(color: Colors.transparent, width: 4),
                shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[200],
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 40,
                  backgroundImage: imageProvider,
                ),
                placeholder: (context, url) => const SizedBox(
                  width: 80, // Adjust to match the CircleAvatar radius, double the radius
                  height: 80,
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                ),
                errorWidget: (context, url, error) => const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.error),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(name),
      ]),
    );
  }
}

const instagramColorsGradient = [
  Color(0xff405DE6),
  Color(0xff5B51D8),
  Color(0xff833AB4),
  Color(0xffC13584),
  Color(0xffE1306C),
  Color(0xffFD1D1D),
  Color(0xffF56040),
  Color(0xffF77737),
  Color(0xffFCAF45),
  Color(0xffFFDC80),
];
