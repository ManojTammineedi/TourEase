class User_Profile {
  String image;
  String name;
  String email;
  String phone;
  String aboutMeDescription;
  bool isGuide;

  // Constructor
  User_Profile(
      {required this.image,
      required this.name,
      required this.email,
      required this.phone,
      required this.aboutMeDescription,
      required this.isGuide});

  User_Profile copy({
    String? imagePath,
    String? name,
    String? phone,
    String? email,
    String? about,
  }) =>
      User_Profile(
        image: imagePath ?? this.image,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        aboutMeDescription: about ?? this.aboutMeDescription,
        isGuide: isGuide ?? this.isGuide,
      );

  static User_Profile fromJson(Map<String, dynamic> json) => User_Profile(
      image: json['imagePath'],
      name: json['name'],
      email: json['email'],
      aboutMeDescription: json['about'],
      phone: json['phone'],
      isGuide: json['isGuide']);

  Map<String, dynamic> toJson() => {
        'imagePath': image,
        'name': name,
        'email': email,
        'about': aboutMeDescription,
        'phone': phone,
        'isGuide': isGuide
      };
}
