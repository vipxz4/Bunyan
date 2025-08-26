import 'package:flutter/material.dart';

class HorizontalCardCarousel extends StatelessWidget {
  const HorizontalCardCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.height = 200,
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        clipBehavior: Clip.none, // To avoid shadows being clipped
      ),
    );
  }
}
