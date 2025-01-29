import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(MyApp());
}

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

  void connectToDevice(BuildContext context, BluetoothDevice device) async {
    try {
      await device.connect(); // Example async operation
      if (!context.mounted) return; // Check if the context is still valid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Connected to ${device.platformName}')), // Use platformName instead of name
      );
    } catch (e) {
      if (!context.mounted) return; // Check if the context is still valid
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
                    result.device.platformName
                            .isEmpty // Use platformName instead of name
                        ? 'Unknown Device'
                        : result.device.platformName,
                  ),
                  subtitle: Text(result.device.remoteId
                      .toString()), // Use remoteId instead of id
                  onTap: () => connectToDevice(
                      context, result.device), // Pass context and device
                );
              },
            ),
          ),
          if (connectedDevice != null)
            ElevatedButton(
              onPressed: disconnectDevice,
              child: Text(
                  'Disconnect from ${connectedDevice!.platformName}'), // Use platformName
            ),
        ],
      ),
    );
  }
}
