class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profile_image'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image': profileImage,
    };
  }
  
  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, profileImage: $profileImage)';
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          profileImage == other.profileImage;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      profileImage.hashCode;
}