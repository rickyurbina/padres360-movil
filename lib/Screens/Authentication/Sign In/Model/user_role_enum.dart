enum UserRole {
  PRINCIPAL('Dirección'),
  TEACHING_SERVICES('Servicios Docentes'),
  SCHOOL_SERVICES('Servicios Escolares'),
  EDUCATIONAL_GUIDANCE('Orientación Educativa'),
  PREFECTURE('Prefectura'),
  NURSING('Enfermería'),
  TEACHER('Docentes'),
  PARENT('Papás'),
  DEFAULT('default');

  const UserRole(this.label);
  final String label;

  /// Convierte desde string al enum
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
          (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => UserRole.DEFAULT,
    );
  }
}
