import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerFamilyCard extends StatelessWidget {
  final bool stripe;

  const CustomShimmerFamilyCard({super.key, this.stripe = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Card(
        elevation: 3,
        color: stripe ? Colors.grey.shade300 : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildShimmerAvatar(),
                    const SizedBox(width: 10),
                    Expanded(child: _buildShimmerTitle()),
                  ],
                ),
                const SizedBox(height: 10),
                _buildShimmerSubtitle(),
                const SizedBox(height: 10),
                _buildShimmerContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerAvatar() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildShimmerTitle() {
    return Container(
      height: 20,
      color: Colors.grey[300],
    );
  }

  Widget _buildShimmerSubtitle() {
    return Container(
      height: 16,
      width: double.infinity,
      color: Colors.grey[300],
    );
  }

  Widget _buildShimmerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
          child: _buildShimmerLine(),
        ),
      ],
    );
  }

  Widget _buildShimmerLine() {
    return Container(
      height: 10,
      width: double.infinity,
      color: Colors.grey[300],
      margin: const EdgeInsets.symmetric(vertical: 3),
    );
  }
}
