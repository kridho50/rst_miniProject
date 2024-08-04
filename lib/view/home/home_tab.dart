import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rst_superapp/controllers/certificate_controller.dart';

class HomeTab extends StatelessWidget {
  final CertificateController certificateController = Get.put(CertificateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificates'),
      ),
      body: Obx(() {
        if (certificateController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: certificateController.certificates.length,
            itemBuilder: (context, index) {
              final certificate = certificateController.certificates[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(certificate.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${certificate.name}'),
                      Text('Description: ${certificate.description}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.download),
                    onPressed: () {
                      certificateController.downloadFile(context,'https://allinpdf.com/Transmit/File_Download?DownloadPath=2024%2f08%2f04%2f26b66a20-a646-4f10-b167-2b481485e421.url-0001.pdf&FileName=rajasakti.co.ididjkn.html.pdf', '${certificate.name}.pdf');
                    },
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
