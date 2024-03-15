class Genre {
  final String sexo;
  final int total;

  Genre({required this.sexo, required this.total});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      sexo: json['sexo'],
      total: json['total'],
    );
  }
}
