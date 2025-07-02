import 'package:flutter/material.dart';
import 'package:device_fault_registration_app/screens/query_results_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QueryBranchCodeScreen extends StatefulWidget {
  const QueryBranchCodeScreen({super.key});

  @override
  State<QueryBranchCodeScreen> createState() => _QueryBranchCodeScreenState();
}

class _QueryBranchCodeScreenState extends State<QueryBranchCodeScreen> {
  final TextEditingController _branchCodeController = TextEditingController();

  @override
  void dispose() {
    _branchCodeController.dispose();
    super.dispose();
  }

  void _queryDevices() {
    final String branchCode = _branchCodeController.text;
    if (branchCode.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QueryResultsScreen(branchCode: branchCode),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.enterBranchCode)), 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.queryDevice),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _branchCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.branchCode,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _queryDevices,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: Text(AppLocalizations.of(context)!.queryExistingDevice),
            ),
          ],
        ),
      ),
    );
  }
}


