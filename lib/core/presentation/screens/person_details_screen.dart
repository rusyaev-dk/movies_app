import 'package:flutter/material.dart';
import 'package:movies_app/core/presentation/components/person/person_details_body.dart';

class PersonDetailsScreen extends StatelessWidget {
  const PersonDetailsScreen({
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
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.share))],
      ),
      body: const PersonDetailsBody(),
    );
  }
}
