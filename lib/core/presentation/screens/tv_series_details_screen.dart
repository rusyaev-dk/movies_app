import 'package:flutter/material.dart';
import 'package:movies_app/core/presentation/components/tv_series/tv_series_details_body.dart';

class TVSeriesDetailsScreen extends StatelessWidget {
  const TVSeriesDetailsScreen({
    super.key,
    required this.appBarTitle,
  });

  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.star_border))
        ],
      ),
      body: const TVSeriesDetailsBody(),
    );
  }
}
