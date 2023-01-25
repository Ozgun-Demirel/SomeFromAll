

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../../stateManager/riverpod/qrScanner/qrScannerRiverpod.dart';


class QrScanner extends ConsumerStatefulWidget {
  const QrScanner({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends ConsumerState<QrScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();

    controller!.pauseCamera();
  }


  @override
  Widget build(BuildContext context) {

    // Camera is being opened after the widget is built.
    // I did not spend much time to implement it otherwise.
    // You are welcome to change it if you can.
    Future.delayed(Duration(milliseconds: 20)).then((value) => controller!.resumeCamera());

    bool cameraStopped = false;

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(height: 10,),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: ElevatedButton(
                        onPressed: () async {
                          await controller?.toggleFlash();
                          setState(() {});
                        },
                        child: FutureBuilder(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            // uppercase and substring actions are just to capitalize the boolean.
                            // it was {false or {true} and now it is {False or {True}
                            return Text('Flash: ${snapshot.data.toString()[0].toUpperCase()}${snapshot.data.toString().substring(1).toLowerCase()}', style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: size.width/16), textAlign: TextAlign.center);
                          },
                        )),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: ElevatedButton(
                      onPressed: () async {

                        cameraStopped ? await controller?.resumeCamera() : controller?.pauseCamera();
                        cameraStopped = !cameraStopped;

                      },
                      child: Text('Pause/Resume', style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: size.width/16), textAlign: TextAlign.center),
                    ),
                  ),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    double scanArea = (size.width < 400 ||
        size.height < 400)
        ? 250
        : 400;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {

      // if camera is still open
      if (mounted) {
        QrScannerNotifier scannerProvider = ref.watch(qrScannerChangeNotifier);

        // if the qr code is valid as a String type, the value will be saved and camera will be closed
        if (scanData.code.runtimeType == String){
          scannerProvider.setLastScanned(scanData.code as String);

          controller.dispose();

          Navigator.of(context).pop();
        }

      }

    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}