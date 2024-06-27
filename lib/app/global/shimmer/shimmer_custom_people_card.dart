import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class ShimmerCustomPeopleCard extends StatelessWidget {
  const ShimmerCustomPeopleCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.only(left: 0, right: 0, top: 2),
        child: ListTile(
          onTap: () {},
          dense: true,
          titleAlignment: ListTileTitleAlignment.center,
          leading: CircleAvatar(
            radius: 15,
            child: ClipOval(
              child: SizedBox(
                width: 30,
                height: 30,
                child: _buildLeading(),
              ),
            ),
          ),
          title: _buildTitle(),
          trailing: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: const Icon(
              Icons.remove_red_eye,
              size: 25,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeading() {
    return const CircleAvatar(
      radius: 15,
    );
  }

  Widget _buildTitle() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 20.0,
        color: Colors.white,
      ),
    );
  }
}
