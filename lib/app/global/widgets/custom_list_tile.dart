import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback ontap;
  final bool seta;

  const CustomListTile(this.icon, this.title, this.ontap, this.seta,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 2, 2, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
        ),
        child: ListTile(
          onTap: ontap,
          leading: Icon(
            icon,
            color: Colors.black87,
          ),
          title: Text(
            title,
            style: const TextStyle(
                fontFamily: 'Poppins', fontSize: 15, color: Colors.black38),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Colors.black26,
          ),
        ),
      ),
    );
  }
}
