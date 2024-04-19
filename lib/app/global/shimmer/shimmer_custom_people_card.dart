import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCustomPeopleCard extends StatelessWidget {
  const ShimmerCustomPeopleCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      child: Card(
        margin: const EdgeInsets.all(3),
        elevation: 3,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ExpansionTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              childrenPadding:
                  const EdgeInsets.only(left: 18, right: 18, bottom: 5),
              title: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[300],
                    ),
                    title: Container(
                      height: 18,
                      color: Colors.white,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 12,
                          width: 100,
                          color: Colors.white,
                        ),
                        const Divider(
                          height: 3,
                          thickness: 2,
                          color: Color(0xFF123d68),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Atendimentos:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Divider(
                      height: 3,
                      thickness: 2,
                      color: Color(0xFF123d68),
                    ),
                    SizedBox(
                      height: 120, // Adjust the height as needed
                      child: ListView.builder(
                        itemCount: 3, // Adjust the number of shimmer items
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 18,
                                  width: 150,
                                  color: Colors.white,
                                ),
                                Container(
                                  height: 18,
                                  width: 50,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
