import 'package:Padres360/Screens/EmergencyData/Model/emergency_data_model.dart';

class EmergencyDataResponse {
  final bool success;
  final EmergencyData? data;

  EmergencyDataResponse({
    required this.success,
    this.data,
  });

  factory EmergencyDataResponse.fromJson(Map<String, dynamic> json) {
    return EmergencyDataResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null
          ? EmergencyData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (data != null) 'data': data!.toJson(),
    };
  }

  @override
  String toString() {
    return 'EmergencyDataResponse(success: $success, data: $data)';
  }
}

