import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

Future<void> pdfGenerator(name) async {
  var key = utf8.encode('p@ssw0rd');
  var bytes = utf8.encode('$name');

  final certificate = Font.ttf(await rootBundle.load('assets/Certificate.ttf'));

  var hmacSHA256 = new Hmac(sha256, key);
  var digest = hmacSHA256.convert(bytes);

  final _pdf = pdf.Document();
  final _assetImage = await pdfImageFromImageProvider(
    pdf: _pdf.document,
    image: AssetImage(
      'assets/images/DSC_logo.png',
    ),
  );
  _pdf.addPage(
    pdf.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => pdf.Center(
        child: pdf.Container(
          margin: pdf.EdgeInsets.all(16),
          width: double.maxFinite,
          color: PdfColors.deepOrange50,
          child: pdf.Column(
            mainAxisAlignment: pdf.MainAxisAlignment.start,
            crossAxisAlignment: pdf.CrossAxisAlignment.center,
            children: [
              pdf.SizedBox(
                height: 65,
              ),
               pdf.Container(
                width: 320,
                child: pdf.Image(_assetImage),
              ),
              pdf.SizedBox(
                height: 60,
              ),
              pdf.Text(
                'Certificate of Participation',
                style: pdf.TextStyle(
                  fontSize: 35,
                  font: certificate,
                  fontWeight: pdf.FontWeight.bold,
                  color: PdfColors.grey800,
                ),
              ),
              pdf.SizedBox(height: 55),
              pdf.Text(
                'Presented to:',
                style: pdf.TextStyle(
                  fontSize: 25,
                  fontWeight: pdf.FontWeight.normal,
                  color: PdfColors.grey600,
                ),
              ),
              pdf.SizedBox(
                height: 30,
              ),
              pdf.Text(
                name,
                textAlign: pdf.TextAlign.center,
                style: pdf.TextStyle(
                  fontSize: 24,
                  fontWeight: pdf.FontWeight.bold,
                  color: PdfColors.grey800,
                ),
              ),
              pdf.SizedBox(height: 30),
              pdf.Text(
                'for attending DSC Event - Flutter Bootcamp.',
                style: pdf.TextStyle(
                  fontSize: 17,
                  fontWeight: pdf.FontWeight.normal,
                  color: PdfColors.grey600,
                ),
              ),
              pdf.SizedBox(
                height: 75,
              ),
              // pdf.Text('$digest',
              // style: pdf.TextStyle(fontSize: 10),
              // ),
              pdf.BarcodeWidget(
                  barcode: pdf.Barcode.qrCode(),
                  data: digest.toString(),
                  height: 80,
                  width: 80)
            ],
          ),
        ),
      ),
    ),
  );
  var path = await getApplicationDocumentsDirectory();
  File('${path.path}/$name.pdf').writeAsBytesSync(_pdf.save());
}

Future<String> getApplicationDocumentsDirectoryPath() async {
  final Directory applicationDocumentsDirectory =
      await getApplicationDocumentsDirectory();
  return applicationDocumentsDirectory.path;
}
