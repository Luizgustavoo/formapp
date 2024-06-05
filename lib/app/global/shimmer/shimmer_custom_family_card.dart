import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCustomFamilyCard extends StatelessWidget {
  const ShimmerCustomFamilyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(left: 0, right: 0, top: 5),
      child: ListTile(
        title: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 20.0,
            color: Colors.white,
          ),
        ),
        subtitle: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 20.0,
            color: Colors.white,
          ),
        ),
        trailing: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.edit_note_sharp,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
