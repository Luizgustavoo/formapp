import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCustomUserCard extends StatelessWidget {
  const ShimmerCustomUserCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(left: 0, right: 0, top: 5),
      child: ListTile(
        leading: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
          ),
        ),
        trailing: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: const Icon(
            Icons.message_outlined,
            size: 25,
            color: Colors.grey,
          ),
        ),
        title: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 20.0,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 14.0,
                color: Colors.white,
                margin: const EdgeInsets.only(top: 5),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 100.0,
                height: 14.0,
                color: Colors.white,
                margin: const EdgeInsets.only(top: 5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
