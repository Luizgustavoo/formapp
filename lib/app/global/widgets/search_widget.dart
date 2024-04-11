import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(BuildContext, int, String) onSearchPressed;
  final Function(BuildContext, int, String) onSubmitted;
  final bool isLoading; // Adicionando esta propriedade

  const SearchWidget(
      {Key? key,
      required this.controller,
      required this.onSearchPressed,
      required this.isLoading, // Passando isLoading como parâmetro
      required this.onSubmitted})
      : super(key: key);

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
        textInputAction: TextInputAction.send,
        onSubmitted: (query) {
          widget.onSearchPressed(context, 1, widget.controller.text);
          widget.controller.clear();
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: 'Digite um nome...',
          hintStyle: TextStyle(
            fontFamily: 'Poppinss',
            fontSize: 14,
            color: Colors.grey.shade800,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              // Verificar se não está carregando para evitar múltiplas pesquisas

              widget.onSearchPressed(context, 1, widget.controller.text);
              widget.controller.clear();
            },
            icon: const Icon(
              Icons.search,
              color: Color(0xFF1C6399),
            ),
          ),
        ),
      ),
    );
  }
}
