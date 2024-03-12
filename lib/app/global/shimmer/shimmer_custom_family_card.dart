import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCustomFamilyCard extends StatelessWidget {
  const ShimmerCustomFamilyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[400],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 15,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 150,
                            height: 12,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 200,
                            height: 10,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 12,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 150,
                      height: 12,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 200,
                      height: 12,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
