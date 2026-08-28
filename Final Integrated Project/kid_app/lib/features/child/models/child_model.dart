class ChildModel {
  final String id;
  final String parentId;
  final String name;
  final int age;
  final String avatar;
  final String learningLevel;
  final String createdAt;

  const ChildModel({
    required this.id,
    required this.parentId,
    required this.name,
    required this.age,
    required this.avatar,
    required this.learningLevel,
    required this.createdAt,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'] as String,
      parentId: (json['parentId'] as String?) ?? '',
      name: json['nickname'] as String,
      age: json['age'] as int,
      avatar: json['avatar'] as String,
      learningLevel: json['learningLevel'] as String,
      createdAt: (json['createdAt'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'nickname': name,
      'age': age,
      'avatar': avatar,
      'learningLevel': learningLevel,
      'createdAt': createdAt,
    };
  }

  ChildModel copyWith({
    String? id,
    String? parentId,
    String? name,
    int? age,
    String? avatar,
    String? learningLevel,
    String? createdAt,
  }) {
    return ChildModel(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      age: age ?? this.age,
      avatar: avatar ?? this.avatar,
      learningLevel: learningLevel ?? this.learningLevel,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
