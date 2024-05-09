import 'dart:convert';

class VoiceSettings {
  double volume;
  double rate;
  double pitch;
  VoiceSettings({
    required this.volume,
    required this.rate,
    required this.pitch,
  });

  VoiceSettings copyWith({
    double? volume,
    double? rate,
    double? pitch,
  }) {
    return VoiceSettings(
      volume: volume ?? this.volume,
      rate: rate ?? this.rate,
      pitch: pitch ?? this.pitch,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'volume': volume});
    result.addAll({'rate': rate});
    result.addAll({'pitch': pitch});
  
    return result;
  }

  factory VoiceSettings.fromMap(Map<String, dynamic> map) {
    return VoiceSettings(
      volume: map['volume']?.toDouble() ?? 0.0,
      rate: map['rate']?.toDouble() ?? 0.0,
      pitch: map['pitch']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory VoiceSettings.fromJson(String source) => VoiceSettings.fromMap(json.decode(source));
  factory VoiceSettings.fromJsonJson(String source) => VoiceSettings.fromJson(json.decode(source));

  @override
  String toString() => 'VoiceSettings(volume: $volume, rate: $rate, pitch: $pitch)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is VoiceSettings &&
      other.volume == volume &&
      other.rate == rate &&
      other.pitch == pitch;
  }

  @override
  int get hashCode => volume.hashCode ^ rate.hashCode ^ pitch.hashCode;
}
