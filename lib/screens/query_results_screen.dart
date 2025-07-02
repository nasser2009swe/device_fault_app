import 'package:flutter/material.dart';
import 'package:device_fault_registration_app/models/device.dart';
import 'package:device_fault_registration_app/database/database_helper.dart';
import 'package:device_fault_registration_app/services/print_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QueryResultsScreen extends StatefulWidget {
  final String branchCode;

  const QueryResultsScreen({super.key, required this.branchCode});

  @override
  State<QueryResultsScreen> createState() => _QueryResultsScreenState();
}

class _QueryResultsScreenState extends State<QueryResultsScreen> {
  late Future<List<Device>> _devicesFuture;

  @override
  void initState() {
    super.initState();
    _devicesFuture = DatabaseHelper().getDevicesByBranchCode(widget.branchCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppLocalizations.of(context)!.queryDevice}: ${widget.branchCode}'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Device>>(
        future: _devicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noDataFound));
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final device = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${AppLocalizations.of(context)!.deviceType}: ${device.type}'),
                              Text('${AppLocalizations.of(context)!.faultType}: ${device.fault}'),
                              Text('${AppLocalizations.of(context)!.numberOfDevices}: ${device.count}'),
                              Text('${AppLocalizations.of(context)!.notes}: ${device.notes.isEmpty ? AppLocalizations.of(context)!.noNotes : device.notes}'),
                              Text('${AppLocalizations.of(context)!.registrationType}: ${device.registrationType}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await PrintService().printFaultData(snapshot.data!, '${AppLocalizations.of(context)!.queryDevice}: ${widget.branchCode}');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      textStyle: const TextStyle(fontSize: 24),
                    ),
                    child: Text(AppLocalizations.of(context)!.print),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}


