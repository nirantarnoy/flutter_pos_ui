import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_pos_ui/models/customer.dart';
import 'package:flutter_pos_ui/models/invoice.dart';
import 'package:flutter_pos_ui/models/supplier.dart';
import 'package:flutter_pos_ui/utils.dart';
import 'package:flutter_pos_ui/api/pdf_api.dart';
import 'package:flutter_pos_ui/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document(version: PdfVersion.pdf_1_5, compress: true);
    //  final font = await PdfGoogleFonts.promptLight();
    final font = await rootBundle.load("assets/fonts/Kanit-Regular.ttf");

    // pdf.addPage(MultiPage(
    //   pageFormat: PdfPageFormat.roll57,
    //   orientation: PageOrientation.portrait,
    //   build: (context) => [
    //     // buildHeader(invoice),
    //     // SizedBox(height: 3 * PdfPageFormat.cm),
    //     buildTitle(invoice),
    //     buildInvoice(invoice, pw.Font.ttf(font)),
    //     Divider(),
    //     buildTotal(invoice),
    //   ],
    //   //footer: (context) => buildFooter(invoice),
    // ));

    pdf.addPage(Page(
      pageFormat: PdfPageFormat.roll57,
      orientation: PageOrientation.portrait,
      build: (context) {
        return Column(children: <Widget>[
          Container(
            width: double.infinity,
            child: buildTitle(
              invoice,
              pw.Font.ttf(font),
            ),
          ),
          buildInvoice(invoice, pw.Font.ttf(font)),
          Divider(color: PdfColors.grey400),
          buildTotal(invoice, pw.Font.ttf(font)),
        ]);
      },
      //footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'gpos_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: invoice.info.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.address),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
        ],
      );

  static Widget buildTitle(Invoice invoice, Font font) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'GPOS',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.1 * PdfPageFormat.cm),
          Text("วันที่ ${DateTime.now()}",
              style: TextStyle(fontSize: 5.0, font: font)),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice, Font font) {
    final headers = ['สินค้า', 'จำนวน', 'ราคา', 'รวม'];
    final data = invoice.items.map((item) {
      final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        item.description,
        '${item.quantity}',
        '${item.unitPrice}',
        '${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle:
          TextStyle(fontWeight: FontWeight.bold, font: font, fontSize: 6),
      headerDecoration: BoxDecoration(color: PdfColors.grey100),
      cellHeight: 10,
      cellPadding: EdgeInsets.all(2),
      cellStyle: TextStyle(font: font, fontSize: 5),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice, Font font) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final vatPercent = invoice.items.first.vat;
    final vat = netTotal * vatPercent;
    final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                    title: 'รวม',
                    value: Utils.formatPrice(netTotal),
                    unite: true,
                    titleStyle: TextStyle(
                        font: font, fontSize: 5, fontWeight: FontWeight.bold)),
                buildText(
                    title: 'Vat ${vatPercent * 100} %',
                    value: Utils.formatPrice(vat),
                    unite: true,
                    titleStyle: TextStyle(
                        font: font, fontSize: 5, fontWeight: FontWeight.bold)),
                Divider(color: PdfColors.grey400),
                buildText(
                  title: 'รวมทั้งสิ้น',
                  titleStyle: TextStyle(
                    fontSize: 5,
                    fontWeight: FontWeight.bold,
                    font: font,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Address', value: invoice.supplier.address),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
