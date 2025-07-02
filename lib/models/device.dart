class Device {
  final int? id;
  final String type;
  final String fault;
  final int count;
  final String notes;
  final String branchCode;
  final String branchName;
  final String branchType;
  final String registrationType;

  Device({
    this.id,
    required this.type,
    required this.fault,
    required this.count,
    required this.notes,
    required this.branchCode,
    required this.branchName,
    required this.branchType,
    required this.registrationType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'fault': fault,
      'count': count,
      'notes': notes,
      'branchCode': branchCode,
      'branchName': branchName,
      'branchType': branchType,
      'registrationType': registrationType,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'],
      type: map['type'],
      fault: map['fault'],
      count: map['count'],
      notes: map['notes'],
      branchCode: map['branchCode'],
      branchName: map['branchName'],
      branchType: map['branchType'],
      registrationType: map['registrationType'],
    );
  }
}

