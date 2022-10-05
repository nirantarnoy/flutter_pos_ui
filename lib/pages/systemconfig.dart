import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class SystemconfigPage extends StatefulWidget {
  @override
  State<SystemconfigPage> createState() => _SystemconfigPageState();
}

class _SystemconfigPageState extends State<SystemconfigPage> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice?> _devices = [];
  BluetoothDevice? _device;
  bool? _connected = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected!) {
      setState(() {
        _connected = true;
      });
    }
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text('${device!.name}'),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      show('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected!) {
          bluetooth.connect(_device!).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = true);
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ตั้งค่าระบบ',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  'Printer:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: DropdownButton(
                  items: _getDeviceItems(),
                  onChanged: (value) {
                    print('printer value is ${value}');
                    setState(() {
                      _device = value as BluetoothDevice;
                    });
                  },
                  value: _device,
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue)),
                      onPressed: () {
                        initPlatformState();
                      },
                      child: Text(
                        'Refresh',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              _connected! ? Colors.red : Colors.green)),
                      onPressed: _connected! ? _disconnect : _connect,
                      child: Text(
                        _connected! ? 'Disconnect' : 'Connect',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey)),
                      onPressed: _testPrint,
                      child: Text(
                        'Print Test',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _testPrint() async {
    print('conntected bt');
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    bluetooth.isConnected.then((isConnected) {
      if (isConnected!) {
        bluetooth.printCustom("G-POS", 3, 1);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("No: 001", "Date: 08/06/2021", 1);
        bluetooth.printLeftRight("Time: 21:45", "", 1);
        bluetooth.printNewLine();
        bluetooth.printCustom("-----------------------------------", 1, 1);
        bluetooth.printLeftRight("Items", "Qty", 1);
        bluetooth.printCustom("-----------------------------------", 1, 1);
        bluetooth.printLeftRight("PB", "1", 1);
        bluetooth.printLeftRight("PC", "4", 1);
        bluetooth.printLeftRight("M", "3", 1);
        bluetooth.printCustom("-----------------------------------", 1, 1);
        bluetooth.printLeftRight("TOTAL", "8", 3);
        // bluetooth.printImage(pathImage);
        // bluetooth.printCustom("Body left", 1, 0);
        // bluetooth.printCustom("Body right", 1, 2);
        // bluetooth.printNewLine();
        // //  bluetooth.printCustom("ผู้ขาย", 2, 1);
        // bluetooth.printNewLine();
        // bluetooth.printQRcode("Insert Your Own Text to Generate", 10, 10, 1);
        // bluetooth.printNewLine();
        // bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
    // bluetooth.isConnected.then((isConnected) {
    //   if (isConnected) {
    //     bluetooth.printCustom("HEADER", 3, 1);
    //     bluetooth.printNewLine();
    //     //    bluetooth.printImage(pathImage);
    //     bluetooth.printNewLine();
    //     bluetooth.printLeftRight("LEFT", "RIGHT", 0);
    //     bluetooth.printLeftRight("LEFT", "RIGHT", 1);
    //     bluetooth.printNewLine();
    //     bluetooth.printLeftRight("LEFT", "RIGHT", 2);
    //     bluetooth.printCustom("Body left", 1, 0);
    //     bluetooth.printCustom("Body right", 0, 2);
    //     bluetooth.printNewLine();
    //     bluetooth.printCustom("Terimakasih", 2, 1);
    //     bluetooth.printNewLine();
    //     bluetooth.printQRcode("Insert Your Own Text to Generate", 10, 10, 1);
    //     bluetooth.printNewLine();
    //     bluetooth.printNewLine();
    //     bluetooth.paperCut();
    //   }
    // });
  }
}
