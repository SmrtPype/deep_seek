import 'package:flutter/material.dart';
import 'package:flutter_application_1/ble_screen_state.dart';

Future<void> main() async => runApp(MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BLE Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BleScreen(),
    );
  }
}

class BleScreen extends StatefulWidget {
  const BleScreen({super.key});
  @override
  BleScreenState createState() => BleScreenState();
}
