class UserModel {
  final String name;
  final int age;
  final String email;

  const UserModel({
    required this.email,
    required this.name,
    required this.age,
  });

  //fromJson
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['firstName'] as String,
      age: json['age'] as int,
      email: json['email'] as String,
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'firstName': name,
      'age': age,
      'email': email,
    };
  }
}
