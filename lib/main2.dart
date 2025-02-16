import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothDataReceiver extends StatefulWidget {
  const BluetoothDataReceiver({super.key});

  @override
  _BluetoothDataReceiverState createState() => _BluetoothDataReceiverState();
}

class _BluetoothDataReceiverState extends State<BluetoothDataReceiver> {
  FlutterBluePlus flutterBlue = FlutterBluePlus();

  BluetoothDevice? connectedDevice;
  List<int> receivedData = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.name == 'YourDeviceName') { // Replace with your device platformName
          _connectToDevice(result.device);
          break;
        }
      }
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    await device.connect();
    setState(() {
      connectedDevice = device;
    });

    _discoverServices(device);
  }

  void _discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.read) {
          List<int> lastValueStream = await characteristic.read();
          setState(() {
            receivedData = lastValueStream;
          });
        }

        if (characteristic.properties.notify) {
(true);
          characteristic.lastValueStream.listen((lastValueStream) {
            setState(() {
              receivedData = lastValueStream;
            });
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Data Receiver'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (connectedDevice != null)
              Text('Connected to: ${connectedDevice!.platformName}'),
            SizedBox(height: 20),
            Text('Received Data: ${String.fromCharCodes(receivedData)}'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    if (connectedDevice != null) {
      connectedDevice!.disconnect();
    }
    super.dispose();
  }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }