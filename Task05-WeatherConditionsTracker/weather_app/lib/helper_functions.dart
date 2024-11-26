import 'package:flutter/material.dart';

Widget buildStyledText(String text) {
  return Text(
    text,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget showLoadingIndicator(message) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const CircularProgressIndicator(
        color: Colors.white,
      ),
      const SizedBox(height: 16),
      Text(
        message,
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
      ),
    ],
  );
}
