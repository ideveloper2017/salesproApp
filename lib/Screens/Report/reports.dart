import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Report/Screens/due_report_screen.dart';
import 'package:mobile_pos/Screens/Report/Screens/purchase_report.dart';
import 'package:mobile_pos/Screens/Report/Screens/sales_report_screen.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

class Reports extends StatefulWidget {
  const Reports({super.key, required this.isFromHome});
  final bool isFromHome;

  @override
  // ignore: library_private_types_in_public_api
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        title: Text(
          lang.S.of(context).reports,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: kMainColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: kWhite),
        automaticallyImplyLeading: widget.isFromHome ? false :  true,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ReportCard(
                pressed: () {
                  const PurchaseReportScreen().launch(context);
                },
                iconPath: 'images/purchase.png',
                title: lang.S.of(context).purchaseReportss),
            ReportCard(
                pressed: () {
                  const SalesReportScreen().launch(context);
                },
                iconPath: 'images/sales.png',
                title: lang.S.of(context).saleReportss),
            ReportCard(
                pressed: () {
                  const DueReportScreen().launch(context);
                },
                iconPath: 'images/duelist.png',
                title: lang.S.of(context).dueCollectionReports),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReportCard extends StatelessWidget {
  ReportCard({
    super.key,
    required this.pressed,
    required this.iconPath,
    required this.title,
  });

  // ignore: prefer_typing_uninitialized_variables
  var pressed;
  String iconPath, title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pressed,
      child: Card(
        elevation: 0.0,
        color: Colors.white,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image(
                height: 40,
                width: 40,
                image: AssetImage(iconPath),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                ),
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.arrow_forward_ios,
                color: kMainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
