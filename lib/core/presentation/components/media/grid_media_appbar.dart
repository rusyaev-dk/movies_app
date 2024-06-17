import 'package:flutter/material.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/uikit/text/app_text_sheme.dart';

class GridMediaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GridMediaAppBar({
    super.key,
    required this.queryType,
  });

  final ApiMediaQueryType queryType;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        queryType.asAppBarTitle(),
        style: AppTextScheme.of(context).headline,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 55);
}
