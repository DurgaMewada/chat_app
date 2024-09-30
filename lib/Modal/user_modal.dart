class UsersModal {
  String? name, email, image, phone, token;

  UsersModal(
      {required this.name,
      required this.email,
      required this.image,
      required this.phone,
      required this.token});

  factory UsersModal.fromMap(Map m1) {
    return UsersModal(
        name: m1['name'],
        email: m1['email'],
        image: m1['image'],
        phone: m1['phone'],
        token: m1['token']);
  }
}
