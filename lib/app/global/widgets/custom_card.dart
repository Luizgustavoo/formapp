import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final VoidCallback? ontap;
  final String? imageUrl;

  const CustomCard({
    super.key,
    @required this.title,
    @required this.ontap,
    @required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: InkWell(
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        onTap: ontap,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imageUrl!,
                width: MediaQuery.of(context).size.height * .060,
              ),
              const SizedBox(height: 5),
              Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
