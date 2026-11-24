class EmergencyData {
  final int student;
  final String allergies;
  final bool autorization;
  final String bloodType;
  final String chronicDiseases;
  final String emergencyContacts;
  final String emergencyPhoneNumbers;
  final String? insuranceNumber;
  final String medicalInsurance;
  final String regularMedications;
  final int? teacher;

  EmergencyData({
    required this.student,
    this.allergies = '',
    this.autorization = true,
    this.bloodType = '',
    this.chronicDiseases = '',
    this.emergencyContacts = '',
    this.emergencyPhoneNumbers = '',
    this.insuranceNumber,
    this.medicalInsurance = '',
    this.regularMedications = '',
    this.teacher,
  });

  factory EmergencyData.fromJson(Map<String, dynamic> json) {
    return EmergencyData(
      student: json['student'] as int,
      allergies: json['allergies'] as String? ?? '',
      autorization: json['autorization'] as bool? ?? true,
      bloodType: json['blood_type'] as String? ?? 'O+',
      chronicDiseases: json['chronic_diseases'] as String? ?? '',
      emergencyContacts: json['emergency_contacts'] as String? ?? '',
      emergencyPhoneNumbers: json['emergency_phone_numbers'] as String? ?? '',
      insuranceNumber: json['insurance_number'] as String?,
      medicalInsurance: json['medical_insurance'] as String? ?? 'IMSS',
      regularMedications: json['regular_medications'] as String? ?? '',
      teacher: json['teacher'] as int?,
    );
  }

  // Convertir a JSON (snake_case para API)
  Map<String, dynamic> toJson() {
    return {
      'student': student,
      'allergies': allergies,
      'autorization': autorization,
      'blood_type': bloodType,
      'chronic_diseases': chronicDiseases,
      'emergency_contacts': emergencyContacts,
      'emergency_phone_numbers': emergencyPhoneNumbers,
      if (insuranceNumber != null) 'insurance_number': insuranceNumber,
      'medical_insurance': medicalInsurance,
      'regular_medications': regularMedications,
      if (teacher != null) 'teacher': teacher,
    };
  }

  factory EmergencyData.empty({required int studentId}) {
    return EmergencyData(
      student: studentId,
      allergies: '',
      autorization: true,
      bloodType: '',
      chronicDiseases: '',
      emergencyContacts: '',
      emergencyPhoneNumbers: '',
      medicalInsurance: '',
      regularMedications: '',
    );
  }
}