import 'dart:convert';

class ReaderModel {
   String name;
   String gender;
   String identifier;
   String locale;
  ReaderModel({
    required this.name,
    required this.gender,
    required this.identifier,
    required this.locale,
  });

  ReaderModel copyWith({
    String? name,
    String? gender,
    String? identifier,
    String? locale,
  }) {
    return ReaderModel(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      identifier: identifier ?? this.identifier,
      locale: locale ?? this.locale,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'name': name});
    result.addAll({'gender': gender});
    result.addAll({'identifier': identifier});
    result.addAll({'locale': locale});
  
    return result;
  }

  factory ReaderModel.fromMap(Map<String, dynamic> map) {
    return ReaderModel(
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      identifier: map['identifier'] ?? '',
      locale: map['locale'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ReaderModel.fromJson(String source) => ReaderModel.fromMap(json.decode(source));
  factory ReaderModel.fromJsonJson(String source) => ReaderModel.fromJson(json.decode(source));

  @override
  String toString() {
    return 'ReaderModel(name: $name, gender: $gender, identifier: $identifier, locale: $locale)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ReaderModel &&
      other.name == name &&
      other.gender == gender &&
      other.identifier == identifier &&
      other.locale == locale;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      gender.hashCode ^
      identifier.hashCode ^
      locale.hashCode;
  }
}
