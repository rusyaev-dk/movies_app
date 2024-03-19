import 'package:flutter/widgets.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: Text("Home"),
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return const Size(double.infinity, 75);
  }
}
