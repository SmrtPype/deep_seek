# flutter_application_1

This app was created with the help of many iterations of asking DeepSeek for assistance and corrections (sometimes on its own generated code).

* **2025-01-28 v0.0.3**
    * Changed many depreciated parameters based on suggestions by DeepSeek

* **2025-01-28 v0.0.2**
    * Changed widget_test.dart line 16 from  await tester.pumpWidget(const MyApp()); to  await tester.pumpWidget(MyApp());

* **2025-01-28 v0.0.1**
    * This version uses Chrome as the target device.
        * When the app is run it displays a "Scan for BLE" button
        * After the button is clicked, it scans for devices
        * The list of devices during test at Abidin's Apps displayed 9 unknown or unsupported devices (including their MAC Address).
        * Upon selecting a device to pair, the display shows the device name as Unknow Device and a 24 character string.
        * If you wait a few second the "Scan for BLE Devices" button return and if you select it you will see that you have paired with the device you selected in the previous step.
        * There is no disconnect button.
        * Also, the rasPI device connect to eht internal Abidin's Apps network was not seen.
    * DeepSeek server was busy at the time of this writing so I could not follow up on more questions.