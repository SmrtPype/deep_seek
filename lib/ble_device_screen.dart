// ble_device_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleDeviceScreen extends StatefulWidget {
  final BluetoothDevice device;

  const BleDeviceScreen({super.key, required this.device});

  @override
  State<BleDeviceScreen> createState() => _BleDeviceScreenState();
}

class _BleDeviceScreenState extends State<BleDeviceScreen> {
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkConnectionStatus();
  }

  void _checkConnectionStatus() async {
    final isDeviceConnected = widget.device.isConnected;
    setState(() {
      isConnected = isDeviceConnected;
    });
  }

  void _disconnectDevice() async {
    await widget.device.disconnect();
    if (!mounted) return;
    setState(() {
      isConnected = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Disconnected from ${widget.device.platformName}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.platformName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Name: ${widget.device.platformName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Device ID: ${widget.device.remoteId}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Connection Status: ${isConnected ? "Connected" : "Disconnected"}',
              style: TextStyle(
                fontSize: 16,
                color: isConnected ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            if (isConnected)
              ElevatedButton(
                onPressed: _disconnectDevice,
                child: const Text('Disconnect'),
              ),
          ],
        ),
      ),
    );
  }
}