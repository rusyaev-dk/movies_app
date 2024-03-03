import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.voteAverage,
    required this.width,
  });

  final String imageUrl;
  final String title;
  final double voteAverage;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(imageUrl),
        ),
        // borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Text(
            "$voteAverage",
            style: const TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }
}
