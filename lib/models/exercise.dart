class Exercise {
  final String name;
  final String bodyPart;
  final String target;
  final String equipment;
  final String gifUrl;

  Exercise({
    required this.name,
    required this.bodyPart,
    required this.target,
    required this.equipment,
    required this.gifUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] ?? 'No name',
      bodyPart: json['bodyPart'] ?? 'Unknown',
      target: json['target'] ?? 'Unknown',
      equipment: json['equipment'] ?? 'None',
      gifUrl: json['gifUrl'] ?? '',
    );
  }
}

