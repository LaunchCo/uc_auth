import 'package:flutter/material.dart';

abstract class HomeScreen extends StatelessWidget {
  final Map<String, String> data;

  const HomeScreen({super.key, required this.data});
}