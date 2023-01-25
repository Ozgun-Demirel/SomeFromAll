

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


// final qrScannerProvider = Provider<QrScannerNotifier>((ref) => QrScannerNotifier(),);
final qrScannerChangeNotifier = ChangeNotifierProvider<QrScannerNotifier>((ref) => QrScannerNotifier(),);

class QrScannerNotifier extends ChangeNotifier{


  Future<List<String>> get previousScansList async {

    final prefs = await SharedPreferences.getInstance();

    String? previousScansString;
    try {
    previousScansString = prefs.getString('previousScans');}
    catch (err){
      return [];
    }

    if(previousScansString == null || previousScansString == "") return [];

    List<String> parsedSharedPreference = previousScansString.split(",");
    print(parsedSharedPreference);
    return parsedSharedPreference;
  }


  String? _lastQrScanned;
  String? get lastQrScanned => _lastQrScanned;

  Uri? get lastQrScannedUri => _lastQrScanned == null ? null : Uri.parse(_lastQrScanned!);


  Future<void> setLastScanned(String value) async {
    _lastQrScanned = value;
    List<String>? previousScansListLatest = await previousScansList;

    final prefs = await SharedPreferences.getInstance();
    if(previousScansListLatest.isEmpty) {
      await prefs.setString('previousScans', value);
    }
    else {
      previousScansListLatest.add(value);
      String previousScansListLatestString = previousScansListLatest.join(",");
      await prefs.setString('previousScans', "${previousScansListLatestString}");
    }
    notifyListeners();
  }

  Future<void> clearLastScanned() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("previousScans", "");
    notifyListeners();
  }

}




