import 'dart:async';

import 'package:flutter/material.dart';

Future<dynamic>showConfirmationDialog(
  BuildContext context, {
  String title = "Atenção!",
  String content = "Deseja realmente excluir?",
  String affirmative = "Confirmar",
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text("Cancelar".toUpperCase()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              affirmative.toUpperCase(),
              style: const TextStyle(
                  color: Colors.brown, fontWeight: FontWeight.bold),
            ),
          )
        ],
      );
    },
  );
}
