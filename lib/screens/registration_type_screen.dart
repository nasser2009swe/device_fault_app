import 'package:flutter/material.dart';
import 'package:device_fault_registration_app/screens/branch_code_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationTypeScreen extends StatelessWidget {
  const RegistrationTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectRegistrationType),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BranchCodeScreen(registrationType: 'Tasaheel'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: Text(AppLocalizations.of(context)!.tasaheel),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BranchCodeScreen(registrationType: 'Mashroey'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: Text(AppLocalizations.of(context)!.mashroey),
            ),
          ],
        ),
      ),
    );
  }
}


