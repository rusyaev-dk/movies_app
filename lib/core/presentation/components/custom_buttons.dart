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

class CustomSettingsButton extends StatelessWidget {
  const CustomSettingsButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.height = 55,
  });

  final IconData icon;
  final String text;
  final void Function() onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
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
    );
  }
}
