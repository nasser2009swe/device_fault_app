import 'package:flutter/material.dart';
import 'package:device_fault_registration_app/models/device.dart';
import 'package:device_fault_registration_app/database/database_helper.dart';
import 'package:device_fault_registration_app/services/print_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeviceRegistrationScreen extends StatefulWidget {
  final String branchCode;
  final String branchName;
  final String branchType;
  final String registrationType;

  const DeviceRegistrationScreen({
    super.key,
    required this.branchCode,
    required this.branchName,
    required this.branchType,
    required this.registrationType,
  });

  @override
  State<DeviceRegistrationScreen> createState() => _DeviceRegistrationScreenState();
}

class _DeviceRegistrationScreenState extends State<DeviceRegistrationScreen> {
  int _currentStep = 0;
  String? _deviceType;
  String? _faultType;
  int _deviceCount = 1;
  final TextEditingController _notesController = TextEditingController();
  final List<Device> _registeredDevices = [];

  final List<String> _deviceTypes = [
    'Computer',
    'Laptop',
    'Printer',
    'Tablet',
    'Monitor',
  ];

  final List<String> _faultTypes = [
    'Broken screen',
    'Windows installation',
    'Printing issue',
    'Other',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _nextStep() {
    setState(() {
      if (_currentStep < 4) {
        _currentStep++;
      } else {
        _addDevice();
        _showConfirmationDialog();
      }
    });
  }

  void _previousStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  void _addDevice() {
    final newDevice = Device(
      type: _deviceType!,
      fault: _faultType!,
      count: _deviceCount,
      notes: _notesController.text,
      branchCode: widget.branchCode,
      branchName: widget.branchName,
      branchType: widget.branchType,
      registrationType: widget.registrationType,
    );
    _registeredDevices.add(newDevice);
    _resetForm();
  }

  void _resetForm() {
    setState(() {
      _currentStep = 0;
      _deviceType = null;
      _faultType = null;
      _deviceCount = 1;
      _notesController.clear();
    });
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmRegistration),
          content: Text(AppLocalizations.of(context)!.doYouWantToAddAnotherDevice),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetForm();
              },
              child: Text(AppLocalizations.of(context)!.addAnotherDevice),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSummaryScreen();
              },
              child: Text(AppLocalizations.of(context)!.finish),
            ),
          ],
        );
      },
    );
  }

  void _showSummaryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryScreen(registeredDevices: _registeredDevices),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.deviceRegistration),
        centerTitle: true,
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: _nextStep,
        onStepCancel: _previousStep,
        steps: <Step>[
          Step(
            title: Text(AppLocalizations.of(context)!.deviceType),
            content: DropdownButtonFormField<String>(
              value: _deviceType,
              hint: Text(AppLocalizations.of(context)!.deviceType),
              items: _deviceTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _deviceType = newValue;
                });
              },
            ),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: Text(AppLocalizations.of(context)!.faultType),
            content: DropdownButtonFormField<String>(
              value: _faultType,
              hint: Text(AppLocalizations.of(context)!.faultType),
              items: _faultTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _faultType = newValue;
                });
              },
            ),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: Text(AppLocalizations.of(context)!.numberOfDevices),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (_deviceCount > 1) _deviceCount--;
                    });
                  },
                ),
                Text(
                  '$_deviceCount',
                  style: const TextStyle(fontSize: 24),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _deviceCount++;
                    });
                  },
                ),
              ],
            ),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: Text(AppLocalizations.of(context)!.notes),
            content: TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.notes + ' (${AppLocalizations.of(context)!.noNotes})',
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            isActive: _currentStep >= 3,
            state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: Text(AppLocalizations.of(context)!.summary),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${AppLocalizations.of(context)!.deviceType}: ${_deviceType ?? AppLocalizations.of(context)!.noNotes}'),
                Text('${AppLocalizations.of(context)!.faultType}: ${_faultType ?? AppLocalizations.of(context)!.noNotes}'),
                Text('${AppLocalizations.of(context)!.numberOfDevices}: $_deviceCount'),
                Text('${AppLocalizations.of(context)!.notes}: ${_notesController.text.isEmpty ? AppLocalizations.of(context)!.noNotes : _notesController.text}'),
              ],
            ),
            isActive: _currentStep >= 4,
            state: _currentStep > 4 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
    );
  }
}

class SummaryScreen extends StatelessWidget {
  final List<Device> registeredDevices;

  const SummaryScreen({super.key, required this.registeredDevices});

  Future<void> _saveDataLocally(BuildContext context) async {
    final dbHelper = DatabaseHelper();
    for (var device in registeredDevices) {
      await dbHelper.insertDevice(device);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.saveDataLocally)), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.summary),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: registeredDevices.length,
                itemBuilder: (context, index) {
                  final device = registeredDevices[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${AppLocalizations.of(context)!.deviceType}: ${device.type}'),
                          Text('${AppLocalizations.of(context)!.faultType}: ${device.fault}'),
                          Text('${AppLocalizations.of(context)!.numberOfDevices}: ${device.count}'),
                          Text('${AppLocalizations.of(context)!.notes}: ${device.notes.isEmpty ? AppLocalizations.of(context)!.noNotes : device.notes}'),
                          Text('${AppLocalizations.of(context)!.branchCode}: ${device.branchCode}'),
                          Text('${AppLocalizations.of(context)!.branchName}: ${device.branchName}'),
                          Text('${AppLocalizations.of(context)!.branchType}: ${device.branchType}'),
                          Text('${AppLocalizations.of(context)!.registrationType}: ${device.registrationType}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    await PrintService().printFaultData(registeredDevices, AppLocalizations.of(context)!.summary);
                  },
                  child: Text(AppLocalizations.of(context)!.print),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement Open a support ticket functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppLocalizations.of(context)!.openSupportTicket)), 
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.openSupportTicket),
                ),
                ElevatedButton(
                  onPressed: () => _saveDataLocally(context),
                  child: Text(AppLocalizations.of(context)!.saveDataLocally),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


