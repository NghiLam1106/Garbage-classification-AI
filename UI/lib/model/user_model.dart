class UserModel {
  final String uid;
  final String name;
  final String email;
  final String avatar;
  final String role;
  final String phoneNumber;
  final String address;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.avatar,
    required this.role,
    required this.phoneNumber,
    required this.address,
  });

  // Chuyển đổi từ Map (Firestore) thành đối tượng UserModel
  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      uid: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      avatar: data['avatar'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      role: data['role'] ?? 'user',
    );
  }

  // Chuyển đổi đối tượng UserModel thành Map (lưu vào Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'avatar': avatar,
      'role': role,
      'phoneNumber': phoneNumber,
      'address': address,
      'createdAt': DateTime.now(),
    };
  }
}
