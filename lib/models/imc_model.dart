
class ImcModel {
  final double altura;
  final double peso;
  final String mensagem;

  ImcModel({required this.altura, required this.peso, required this.mensagem});

  factory ImcModel.fromJson(Map json){
    return ImcModel(altura: json['altura'], peso: json['peso'], mensagem: json['mensagem']);
  }

  @override
  String toString() {
    return 'Altura: $altura, Peso: $peso, Mensagem: $mensagem';
  }

}