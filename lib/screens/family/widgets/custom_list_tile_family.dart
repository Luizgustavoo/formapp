import 'package:flutter/material.dart';

class CustomListTileFamily extends StatelessWidget {
  const CustomListTileFamily({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return const CustomExpansion();
        });
  }
}

class CustomExpansion extends StatelessWidget {
  const CustomExpansion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 3),
      child: Card(
        child: ExpansionTile(
          leading: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit_rounded,
                color: Colors.orange.shade700,
                size: 20,
              )),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: const Text('Luiz Gustavo'),
          subtitle: const Text('(43) 99928-9380'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(),
                  const SizedBox(height: 10),
                  TextFormField(),
                  const SizedBox(height: 10),
                  TextFormField(),
                  const SizedBox(height: 10),
                  TextFormField(),
                  const SizedBox(height: 10),
                  TextFormField(),
                  const SizedBox(height: 10),
                  TextFormField(),
                  const SizedBox(height: 10),
                  TextFormField(),
                  const SizedBox(height: 10),
                  TextFormField(),
                  const SizedBox(height: 10),
                  TextFormField(),
                  const SizedBox(height: 10),
                  TextFormField(),
                  const SizedBox(height: 10),
                  TextFormField(),
                  const SizedBox(height: 10),
                  TextFormField(),
                  const SizedBox(height: 10),
                  TextFormField(),
                  const SizedBox(height: 10),
                  TextFormField(),
                  const SizedBox(height: 10),
                  TextFormField(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
