import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(BuildContext, int, String) onSearchPressed;
  final bool isLoading; // Adicionando esta propriedade

  const SearchWidget({
    Key? key,
    required this.controller,
    required this.onSearchPressed,
    required this.isLoading, // Passando isLoading como parâmetro
  }) : super(key: key);

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
        onChanged: (query) {
          // Verificar se não está carregando para evitar múltiplas pesquisas
          if (!widget.isLoading) {
            widget.onSearchPressed(context, 1, query);
          }
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
              if (!widget.isLoading) {
                widget.onSearchPressed(context, 1, widget.controller.text);
              }
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
