import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(BuildContext, int, String) onSearchPressed;

  const SearchWidget(
      {super.key, required this.controller, required this.onSearchPressed});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: TextField(
        controller: widget.controller,
        onSubmitted: (query) {
          widget.onSearchPressed(context, 1, query);
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: 'Pesquisar Família...',
          hintStyle: TextStyle(
            fontFamily: 'Poppinss',
            fontSize: 14,
            color: Colors.grey.shade800,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              widget.onSearchPressed(context, 1, widget.controller.text);
            },
            icon: const Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
