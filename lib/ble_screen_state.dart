import 'package:flutter/material.dart';
import 'package:flutter_application_1/ble_device_screen.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleScreenState extends State<BleScreen> {
  FlutterBluePlus flutterBlue = FlutterBluePlus(); // Updated line
  List<ScanResult> scanResults = [];
  bool isScanning = false;
  BluetoothDevice? connectedDevice;

  @override
  void initState() {
    super.initState();
    FlutterBluePlus.isScanning.listen((scanning) {
      setState(() {
        isScanning = scanning;
      });
    });
  }

  void startScan() async {
    scanResults.clear();
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
    });
  }

  // Update the connectToDevice method in BleScreen
void connectToDevice(BuildContext context, BluetoothDevice device) async {
  try {
    await device.connect();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connected to ${device.platformName}'),
      ),
    );

    // Navigate to the new screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BleDeviceScreen(device: device),
      ),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to connect: $e')),
    );
  }

  }

  void disconnectDevice() async {
    if (connectedDevice != null) {
      // Store the device name before disconnecting
      final deviceName = connectedDevice!.platformName;

      // Disconnect the device
      await connectedDevice!.disconnect();

      // Check if the widget is still mounted before using the context
      if (!mounted) return;

      // Update the state to reflect the disconnection
      setState(() {
        connectedDevice = null;
      });

      // Show a SnackBar to notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Disconnected from $deviceName')),
      );
    }
  }

 // BleScreen widget remains mostly unchanged
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('BLE Scanner'),
    ),
    body: Column(
      children: [
        ElevatedButton(
          onPressed: isScanning ? null : startScan,
          child: Text(isScanning ? 'Scanning...' : 'Scan for BLE Devices'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: scanResults.length,
            itemBuilder: (context, index) {
              ScanResult result = scanResults[index];
              return ListTile(
                title: Text(
                  result.device.platformName.isEmpty
                      ? 'Unknown Device'
                      : result.device.platformName,
                ),
                subtitle: Text(result.device.remoteId.toString()),
                onTap: () => connectToDevice(context, result.device),
              );
            },
          ),
        ),
      ],
    ),
  );
 }
}