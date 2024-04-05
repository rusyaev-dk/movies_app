import 'package:flutter/material.dart';
import 'package:movies_app/core/themes/theme.dart';

class CustomGradientButton extends StatelessWidget {
  const CustomGradientButton({
    super.key,
    this.onPressed,
    required this.text,
    this.width = 110,
    this.height = 45,
  });

  final void Function()? onPressed;
  final String text;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primaryContainer,
              ],
              stops: const [0.65, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .subtitleTextStyle
                  .copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

enum BorderRadiusDirection {
  all,
  onlyTop,
  onlyBottom,
  none,
}

class CustomSettingsButton extends StatelessWidget {
  const CustomSettingsButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.height = 55,
    this.borderRadiusDirection = BorderRadiusDirection.onlyTop,
  });

  final IconData icon;
  final String text;
  final void Function() onPressed;
  final double height;
  final BorderRadiusDirection borderRadiusDirection;

  @override
  Widget build(BuildContext context) {
    dynamic borderRadius;
    switch (borderRadiusDirection) {
      case BorderRadiusDirection.onlyTop:
        borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        );
        break;
      case BorderRadiusDirection.onlyBottom:
        borderRadius = const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        );
        break;
      case BorderRadiusDirection.none:
        borderRadius = BorderRadius.zero;
        break;
      case BorderRadiusDirection.all:
        borderRadius = BorderRadius.circular(12);
        break;
    }

    return Material(
      borderRadius: borderRadius,
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onPressed,
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 20),
              Text(
                text,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .subtitleTextStyle
                    .copyWith(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
  });

  final void Function() onPressed;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .subtitleTextStyle
                .copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          )
        ],
      ),
    );
  }
}
