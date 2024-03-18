import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCustomFamilyCard extends StatelessWidget {
  const ShimmerCustomFamilyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Card(
        elevation: 3,
        color: Colors.grey[300], // Shimmer color
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 22,
                  ),
                  title: Container(
                    height: 16,
                    color: Colors.white,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: 200,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 12,
                        width: 150,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 12,
                        width: 200,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 3,
                  thickness: 2,
                  color: Color(0xFF123d68),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        color: Colors.white,
                      ),
                      Container(
                        height: 32,
                        width: 32,
                        color: Colors.white,
                      ),
                      Container(
                        height: 32,
                        width: 32,
                        color: Colors.white,
                      ),
                      Container(
                        height: 32,
                        width: 32,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
