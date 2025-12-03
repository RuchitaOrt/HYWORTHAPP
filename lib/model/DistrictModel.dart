class District {
  final String id;
  final String name;

  District({required this.id, required this.name});

  factory District.fromMap(Map<String, dynamic> map) {
    return District(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
