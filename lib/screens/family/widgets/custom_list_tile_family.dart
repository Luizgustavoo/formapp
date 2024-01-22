import 'package:flutter/material.dart';

class CustomListTileFamily extends StatelessWidget {
  const CustomListTileFamily({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
        child: Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('John Doe'),
            subtitle: const Text('(43) 99928-9380'),
            trailing: IconButton(
                onPressed: () {}, icon: const Icon(Icons.edit_rounded)),
          ),
        ),
      ),
    );
  }
}
