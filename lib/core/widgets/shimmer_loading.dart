import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child;
  const ShimmerLoading({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1A1A22),
      highlightColor: const Color(0xFF2A2A35),
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(51),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class NBAFootballCardShimmer extends StatelessWidget {
  const NBAFootballCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A22),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const ShimmerBox(width: 44, height: 44, borderRadius: 12),
                const SizedBox(height: 8),
                const ShimmerBox(width: 60, height: 12),
              ],
            ),
            const Column(
              children: [
                ShimmerBox(width: 40, height: 24),
                SizedBox(height: 8),
                ShimmerBox(width: 30, height: 12),
              ],
            ),
            Column(
              children: [
                const ShimmerBox(width: 44, height: 44, borderRadius: 12),
                const SizedBox(height: 8),
                const ShimmerBox(width: 60, height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class F1CardShimmer extends StatelessWidget {
  const F1CardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A22),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(width: 80, height: 10),
                ShimmerBox(width: 60, height: 10),
              ],
            ),
            const SizedBox(height: 12),
            const ShimmerBox(width: 150, height: 18),
            const SizedBox(height: 8),
            const ShimmerBox(width: 100, height: 12),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ShimmerBox(width: 4, height: 16),
                          SizedBox(width: 8),
                          ShimmerBox(width: 100, height: 12),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          ShimmerBox(width: 4, height: 16),
                          SizedBox(width: 8),
                          ShimmerBox(width: 80, height: 12),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GolfCardShimmer extends StatelessWidget {
  const GolfCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A22),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(width: 140, height: 16),
                ShimmerBox(width: 60, height: 24),
              ],
            ),
            const SizedBox(height: 16),
            ...List.generate(3, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const ShimmerBox(width: 32, height: 32, borderRadius: 16),
                  const SizedBox(width: 12),
                  const Expanded(child: ShimmerBox(width: 100, height: 14)),
                  const SizedBox(width: 12),
                  const ShimmerBox(width: 40, height: 14),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class TennisCardShimmer extends StatelessWidget {
  const TennisCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A22),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(width: 120, height: 10),
            const SizedBox(height: 16),
            Row(
              children: [
                const ShimmerBox(width: 36, height: 36, borderRadius: 18),
                const SizedBox(width: 12),
                const Expanded(child: ShimmerBox(width: 100, height: 14)),
                const ShimmerBox(width: 40, height: 18),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const ShimmerBox(width: 36, height: 36, borderRadius: 18),
                const SizedBox(width: 12),
                const Expanded(child: ShimmerBox(width: 100, height: 14)),
                const ShimmerBox(width: 40, height: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RallyCardShimmer extends StatelessWidget {
  const RallyCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A22),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerBox(width: 40, height: 10),
            const SizedBox(height: 8),
            const ShimmerBox(width: 180, height: 18),
            const SizedBox(height: 12),
            const ShimmerBox(width: double.infinity, height: 120, borderRadius: 16),
          ],
        ),
      ),
    );
  }
}
