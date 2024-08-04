import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/certificate.dart';
import '../certificate_service.dart';

class CertificateController extends GetxController {
 var isLoading = true.obs;
  var certificates = <Certificate>[].obs;

  @override
  void onInit() {
    fetchCertificates();
    super.onInit();
  }

  void fetchCertificates() async {
    try {
      isLoading(true);
      var fetchedCertificates = await CertificateService().fetchCertificates();
      certificates.assignAll(fetchedCertificates);
    } finally {
      isLoading(false);
    }
  }

  Future<void> requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      // Permission granted
    } else {
      // Handle permission denial
      print('Storage permission is denied');
    }
  }

  Future<void> downloadFile(BuildContext context, String url, String filename) async {
    await requestPermission(); // Request permission before downloading

  // Show progress dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('Downloading'),
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Expanded(child: Text('Downloading file...')),
          ],
        ),
      );
    },
  );

  try {
    var dio = Dio();
    final directory = await getExternalStorageDirectory();
    final path = '${directory!.path}/$filename';
    
    await dio.download(
      url,
      path,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print('${(received / total * 100).toStringAsFixed(0)}%');
        }
      },
    );
    print('File downloaded to: $path');
    
    // Close progress dialog
    Navigator.of(context).pop();

    // Open the file after downloading
    OpenFile.open(path);
  } catch (e) {
    print('Download failed: $e');
    
    // Close progress dialog and show error message
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to download file.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
}