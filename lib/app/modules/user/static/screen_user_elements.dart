import 'package:flutter/material.dart';

class ScreenUserElements {
  static const String listagemUsuariosTitle = 'Listagem de Usuários';
  static const String cadastroUsuarioTitle = 'Cadastro de Usuário';
  static const String alteracaoUsuarioTitle = 'Alteração de Usuário';
  static const String mensagemParaUsuarioTitle = 'Mensagem para';
  static const String mensagemConfirmacaoAtivarUsuario =
      'Tem certeza que deseja ativar novamente o usuário';
  static const String mensagemConfirmacaoDesativarUsuario =
      'Tem certeza que deseja desativar o usuário';

  static Widget defaultAvatar() {
    return const CircleAvatar(
      radius: 25,
      backgroundImage: AssetImage('assets/images/default_avatar.jpg'),
    );
  }

  static Widget editIcon(BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 25),
    );
  }

  static Widget messageIcon(BuildContext context, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.message_outlined, size: 25, color: Colors.green),
    );
  }

  static Widget deleteIcon(BuildContext context, {required bool status}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: status ? Colors.red.shade500 : Colors.green,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                status
                    ? const Icon(Icons.delete_outline,
                        color: Colors.white, size: 25)
                    : const Icon(
                        Icons.check_rounded,
                        size: 25,
                        color: Colors.white,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future createUserModal({
    required BuildContext context,
    required String tipoOperacao,
    required String titulo,
    required Widget child,
  }) {
    return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: child,
      ),
    );
  }

  static Future messageModal({
    required BuildContext context,
    required String titulo,
    required Widget child,
  }) {
    return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: child,
      ),
    );
  }
}
