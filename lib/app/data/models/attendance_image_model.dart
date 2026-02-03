import 'dart:io';

class AttendanceImage {
  final int? id; // id no banco (imagem já existente)
  final String? url; // url vinda da API
  final File? file; // imagem nova escolhida

  AttendanceImage({this.id, this.url, this.file});

  bool get isFromApi => url != null;
  bool get isNew => file != null;
}
