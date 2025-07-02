import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _printerIpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPrinterIp();
  }

  Future<void> _loadPrinterIp() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _printerIpController.text = prefs.getString('printerIp') ?? '';
    });
  }

  Future<void> _savePrinterIp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('printerIp', _printerIpController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.save)), 
    );
  }

  void _testPrinterConnection() {
    // TODO: Implement actual printer connection test logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.testConnection)), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _printerIpController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.printerIpAddress,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _savePrinterIp,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                  child: Text(AppLocalizations.of(context)!.save),
                ),
                ElevatedButton(
                  onPressed: _testPrinterConnection,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                  child: Text(AppLocalizations.of(context)!.testConnection),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


