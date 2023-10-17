import 'package:flutter/material.dart';
import 'package:gravilag/ui/gravilag_widget.dart';

main() => runApp(const GraviLagApp());

class GraviLagApp extends StatelessWidget {
  const GraviLagApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gravity Simulator',
      home: Scaffold(
        appBar: AppBar(title: const Text('Gravity Simulator')),
        body: const GraviLagWidget(),
      ),
    );
  }
}





