import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

enum BorderRadiusDirection { all, onlyTop, onlyBottom, none, left, right }

class CustomRoundedButton extends StatelessWidget {
  const CustomRoundedButton({
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
      case BorderRadiusDirection.left:
        borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        );
        break;
      case BorderRadiusDirection.right:
        borderRadius = const BorderRadius.only(
          topRight: Radius.circular(12),
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

class CustomFilterButton extends StatelessWidget {
  const CustomFilterButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.height = 50,
    this.borderRadiusDirection = BorderRadiusDirection.onlyTop,
  });

  final String text;
  final void Function() onPressed;
  final Color color;
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
      case BorderRadiusDirection.left:
        borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        );
        break;
      case BorderRadiusDirection.right:
        borderRadius = const BorderRadius.only(
          topRight: Radius.circular(12),
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

    return InkWell(
      borderRadius: borderRadius,
      onTap: onPressed,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .subtitleTextStyle
                .copyWith(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
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

class CustomThemeSwitchButton extends StatelessWidget {
  const CustomThemeSwitchButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.height = 50,
    this.subtitle,
    this.icon,
    this.borderColor,
  });

  final String text;
  final void Function() onPressed;
  final Color color;
  final double height;
  final String? subtitle;
  final IconData? icon;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    Widget btnContent;
    if (subtitle != null && icon == null) {
      btnContent = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .subtitleTextStyle
                .copyWith(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle!,
            maxLines: 3,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .subtitleTextStyle
                .copyWith(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      );
    } else {
      btnContent = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(height: 10),
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
        ],
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: borderColor != null
              ? Border.all(
                  color: borderColor!,
                  width: 1.5,
                )
              : null,
        ),
        child: Center(
          child: btnContent,
        ),
      ),
    );
  }
}
