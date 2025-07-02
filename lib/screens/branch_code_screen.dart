import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:device_fault_registration_app/screens/device_registration_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BranchCodeScreen extends StatefulWidget {
  final String registrationType;

  const BranchCodeScreen({super.key, required this.registrationType});

  @override
  State<BranchCodeScreen> createState() => _BranchCodeScreenState();
}

class _BranchCodeScreenState extends State<BranchCodeScreen> {
  final TextEditingController _branchCodeController = TextEditingController();
  String? _branchName;
  String? _branchType;
  List<dynamic> _branches = [];

  @override
  void initState() {
    super.initState();
    _loadBranchData();
  }

  Future<void> _loadBranchData() async {
    final String response = await rootBundle.loadString('assets/branches.json');
    final data = await json.decode(response);
    setState(() {
      _branches = data;
    });
  }

  void _mapBranchCode() {
    final String enteredCode = _branchCodeController.text;
    final branch = _branches.firstWhere(
      (b) => b['code'] == enteredCode,
      orElse: () => null,
    );

    setState(() {
      if (branch != null) {
        _branchName = branch['name'];
        _branchType = branch['type'];
      } else {
        _branchName = null;
        _branchType = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.enterBranchCode + ' (${widget.registrationType})'),
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
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _mapBranchCode();
                } else {
                  setState(() {
                    _branchName = null;
                    _branchType = null;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            if (_branchName != null)
              Column(
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.branchName}: $_branchName',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.branchType}: $_branchType',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeviceRegistrationScreen(
                            branchCode: _branchCodeController.text,
                            branchName: _branchName!,
                            branchType: _branchType!,
                            registrationType: widget.registrationType,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      textStyle: const TextStyle(fontSize: 24),
                    ),
                    child: Text(AppLocalizations.of(context)!.confirmRegistration),
                  ),
                ],
              )
            else
              Text(
                AppLocalizations.of(context)!.invalidBranchCode,
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}


