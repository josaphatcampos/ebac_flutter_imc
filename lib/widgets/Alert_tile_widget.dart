import 'package:flutter/material.dart';

class AlertTile extends StatelessWidget {
  final String title;
  final String valor;

  const AlertTile({
    super.key,
    required this.title,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Text(valor),
      dense: true,
      visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity),
    );
  }
}