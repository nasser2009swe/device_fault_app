import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:device_fault_registration_app/models/device.dart';
import 'package:flutter/services.dart';

class PrintService {
  Future<void> printFaultData(List<Device> devices, String title) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load("assets/fonts/NotoSansArabicUI-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  title,
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: ttf),
                  textDirection: pw.TextDirection.rtl,
                ),
              ),
              pw.SizedBox(height: 20),
              for (var device in devices)
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey),
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('نوع الجهاز: ${device.type}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: ttf)),
                      pw.Text('نوع العطل: ${device.fault}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: ttf)),
                      pw.Text('عدد الأجهزة: ${device.count}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: ttf)),
                      pw.Text('ملاحظات: ${device.notes.isEmpty ? 'لا يوجد' : device.notes}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: ttf)),
                      pw.Text('رمز الفرع: ${device.branchCode}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: ttf)),
                      pw.Text('اسم الفرع: ${device.branchName}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: ttf)),
                      pw.Text('نوع الفرع: ${device.branchType}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: ttf)),
                      pw.Text('نوع التسجيل: ${device.registrationType}', textDirection: pw.TextDirection.rtl, style: pw.TextStyle(font: ttf)),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}

