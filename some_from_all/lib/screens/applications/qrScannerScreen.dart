

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_from_all/developSettings/VariableHolder.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../screenSubWidgets/home/applications/qrScanner/qrScanner.dart';
import '../../stateManager/riverpod/qrScanner/qrScannerRiverpod.dart';

class QrScannerScreen extends ConsumerWidget {
  static const routeName = "/QrScannerScreen";
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final QrScannerNotifier qrScannerProvider = ref.watch(qrScannerChangeNotifier);

    Size size = MediaQuery.of(context).size;

    double height = size.height;
    double width = size.width;


    return Scaffold(
      appBar: AppBar(
        title: const Text("Qr Scanner"),
      ),

      body: Padding(
        padding: EdgeInsets.only(left: width/40, right: width/40, top: height/40, bottom: height/80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("You can scan QR Codes and see your previous scans!", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: width/16), textAlign: TextAlign.center),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const QrScanner(),
                ));
              },
              child: Text('Scan QR Code!', style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: width/14),),
            ),

            ElevatedButton(
              child: Text("Clear History", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: width/14),),
              onPressed: () async {

                // show a dialog box to ask if they are sure to delete

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        backgroundColor: Color(0x00000000),
                        children: [
                          SizedBox(
                            width: size.width,
                            child: Card(
                              child: Column(
                                children: [
                                  SizedBox(height: size.height/16,),
                                  Text("Are you sure?", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: width/14),),
                                  SizedBox(height: size.height/16,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(onPressed: () async {
                                        await qrScannerProvider.clearLastScanned();
                                        Navigator.of(context).pop();
                                      }, child: SizedBox(
                                          height: size.height/12,
                                          width: size.width/5,
                                          child: Center(child: Text("Yes", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: width/14),),))),
                                      ElevatedButton(onPressed: (){
                                        Navigator.of(context).pop();
                                      }, child: SizedBox(
                                        height: size.height/12,
                                        width: size.width/5,
                                        child: Center(child: Text("Cancel", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: width/14),)),
                                      )),
                                    ],
                                  ),
                                  SizedBox(height: size.height/16,),

                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    });

              },
            ),

            Visibility(
              visible: qrScannerProvider.lastQrScanned != null,
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(backgroundColor: ColorPalette.highlightedColor),

                onPressed: () => launchUrl(qrScannerProvider.lastQrScannedUri as Uri), child: Text("Touch to open your last scan!", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: width/16), textAlign: TextAlign.center),),
            ),

            previousScans(qrScannerProvider, size),

          ],
        ),
      ),
    );
  }

  FutureBuilder previousScans(QrScannerNotifier qrScannerProvider, Size size) {

    return FutureBuilder<List<String>>(
      future: qrScannerProvider.previousScansList, // async work
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return const CircularProgressIndicator.adaptive();
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<String> resultList = snapshot.data ?? [];
              if (resultList.isEmpty) {
                return const Text("You do not have any previous scans!");
              } else {
                return Container(
                  height: size.height/4,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)
                  ),
                  child: ListView.builder(itemCount: resultList.length,itemBuilder: (context, index) {

                    return Card(
                      shadowColor: Colors.blueAccent,
                      elevation: 8,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(size.width / 20)),

                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.white, ColorPalette.highlightedColor],
                            )),

                        child: ListTile(
                          title: InkWell(
                            child: Text("${index+1} : ${resultList[index]}"),
                            onTap: () => launchUrl(Uri.parse(resultList[index])),
                          ),
                        ),
                      ),
                    );
                  },),
                );

              }

            }
        }
      },
    );
  }
}
