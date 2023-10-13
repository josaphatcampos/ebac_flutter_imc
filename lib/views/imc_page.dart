import 'package:ebac_imc/controllers/imc_controller.dart';
import 'package:ebac_imc/models/imc_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../widgets/Alert_tile_widget.dart';

class ImcPage extends StatefulWidget {
  const ImcPage({super.key});

  @override
  State<ImcPage> createState() => _ImcPageState();
}

class _ImcPageState extends State<ImcPage> with SingleTickerProviderStateMixin {
  final _controller = ImcController();

  late AnimationController _animationController;
  final Duration _duration = const Duration(milliseconds: 750);

  late Animation<Alignment> _alignAnimation;
  late Animation<Size?> _size;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: _duration);
    _alignAnimation = AlignmentTween(begin: Alignment.bottomCenter, end: Alignment.center).animate(_animationController);
    _size = SizeTween(begin: const Size(0,0), end: const Size(200, 200)).animate(_animationController);


    _animationController.addListener(() async {
      if(_animationController.isCompleted){
        await Future.delayed(_duration);
        _animationController.reverse();
        await Future.delayed(_duration);
        callDialog(context);
      }
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'IMC',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      maxLength: 4,
                      controller: _controller.alturaController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        counterText: '',
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        label: Text(
                          'Altura',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        hintText: 'Informe sua altura',
                        hintStyle:
                            TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15))),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      maxLength: 7,
                      controller: _controller.pesoController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        counterText: '',
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        label: Text(
                          'Peso',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        hintText: 'Informe seu peso',
                        hintStyle:
                            TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Row(
                children: [
                  Expanded(
                      child: ValueListenableBuilder<bool>(
                    valueListenable: _controller.btnCalcular,
                    builder: (context, value, child) {
                      return ElevatedButton(
                          onPressed: !value
                              ? null
                              : () {
                                  _animationController.forward();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'Calcular',
                            style: TextStyle(color: Colors.white),
                          ));
                    },
                  )),
                ],
              ),
            ),
            AnimatedBuilder(animation: _animationController, builder: (context, child) {
              return  Align(
                alignment: _alignAnimation.value,
                child: Container(
                  height: _size.value?.height,
                  width: _size.value?.width,
                  decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle
                  ),
                  child:  Lottie.asset('assets/lotties/success_person.json'),
                ),
              );
            },)

          ],
        ),
      ),
    );
  }

  void callDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        ImcModel imcmodel =
            _controller.processaImc();
        return AlertDialog(
          icon: Icon(
            _controller.valorImc <= 0
                ? Icons.block
                : Icons.balance,
            color: Colors.red,
            size: 33,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                  visible:
                      _controller.valorImc <= 0,
                  child: const Text(
                    "Campos incorretos!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  )),
              Visibility(
                visible: _controller.valorImc > 0,
                child: Column(
                  children: [
                    AlertTile(
                      title: 'Altura',
                      valor: imcmodel.altura
                          .toString(),
                    ),
                    AlertTile(
                      title: 'Peso',
                      valor:
                          imcmodel.peso.toString(),
                    ),
                    const Divider(
                      height: 1,
                    ),
                    AlertTile(
                      title: 'IMC',
                      valor: _controller.valorImc
                          .toString(),
                    ),
                    Text(
                      imcmodel.mensagem,
                      style: const TextStyle(
                          fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  FocusManager.instance.primaryFocus
                      ?.unfocus();
                },
                child: const Text('Fechar'))
          ],
        );
      },
    );
  }
}


