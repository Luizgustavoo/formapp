import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCustomCountCard extends StatelessWidget {
  const ShimmerCustomCountCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 5,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Color(0xFF123d68),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              Container(
                height: 20,
                width: 100,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
