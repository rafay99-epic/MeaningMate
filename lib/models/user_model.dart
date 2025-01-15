class UserModel {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;

  // Constructor
  UserModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  // Convert UserModel to a map (for easy storage or network communication)
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
    };
  }

  // Convert a map to a UserModel (used for deserialization)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['fullName'],
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phoneNumber'],
    );
  }

  // Optionally, to make the user data more readable
  @override
  String toString() {
    return 'UserModel(fullName: $fullName, email: $email, phoneNumber: $phoneNumber)';
  }
}
