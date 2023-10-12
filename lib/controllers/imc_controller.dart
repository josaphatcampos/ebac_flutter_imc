import 'package:ebac_imc/models/imc_model.dart';
import 'package:flutter/cupertino.dart';

class ImcController {
  final alturaController = TextEditingController();
  final pesoController = TextEditingController();
  double valorImc = 0.0;

  ValueNotifier<bool> btnCalcular = ValueNotifier(false);

  ImcController() {
    alturaController.addListener(() {
      _habilitabtn();
    });

    pesoController.addListener(() {
      _habilitabtn();
    });
  }

  void _habilitabtn() {
    btnCalcular.value = alturaController.value.text.isNotEmpty &&
        pesoController.value.text.isNotEmpty;
  }

  ImcModel processaImc() {
    valorImc = double.tryParse(_calcularImc().toStringAsFixed(2)) as double;
    String mensagem = _mensagemImc(valorImc);

    try{
      double altura = double.parse(alturaController.text.replaceAll(',', '.'));
      double peso = double.parse(pesoController.text.replaceAll(',', '.'));

      return ImcModel(
          altura: altura,
          peso: peso,
          mensagem: mensagem);
    }catch(e){
      return ImcModel(altura: 0, peso: 0, mensagem: mensagem);
    }


  }

  double _calcularImc() {
    try{
      double result = double.parse(pesoController.text.replaceAll(',', '.')) /
          (double.parse(alturaController.text.replaceAll(',', '.')) *
              double.parse(alturaController.text.replaceAll(',', '.')));
      return result;
    }catch (e){
      return 0;
    }
  }

  String _mensagemImc(double imc) {
    switch (imc) {
      case < 16:
        return 'Baixo peso muito grave = abaixo de 16';
      case >= 16 && < 17:
        return 'Baixo peso grave = entre 16 e 16,99';
      case >= 17 && < 18.50:
        return 'Baixo peso = entre 17 e 18,49';
      case >= 18.50 && < 25:
        return 'Peso normal = entre 18,5 e 24,99';
      case >= 25 && < 30:
        return 'Sobre peso = entre 25 e 29,99';
      case >= 30 && < 35:
        return 'Obesidade grau I = entre 30 e 34,99';
      case >= 35 && < 39.99:
        return 'Obesidade grau II = entre 35 e 39,99';
      default:
        return 'Obesidade grau III (obesidade mórbida) = maior que 40';
    }
  }

  void dispose() {
    alturaController.dispose();
    pesoController.dispose();
  }
}
