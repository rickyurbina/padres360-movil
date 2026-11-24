class IncidenceModelResponse {
  bool success;
  List<IncidenceModel> incidences;

  IncidenceModelResponse({required this.success, required this.incidences});
}

class IncidenceModel {
  int id;
  String name;
  String type;
  bool? selected;
  bool? isRead;

  IncidenceModel({
    required this.id,
    required this.name,
    required this.type,
  });

  factory IncidenceModel.fromJson(Map<String, dynamic> json) {
    return IncidenceModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? ''
    );
  }
}
