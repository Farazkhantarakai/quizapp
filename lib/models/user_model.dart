class User {
  String name;
  String email;

  String address;
  String image;
  User(
      {required this.name,
      required this.email,
      required this.address,
      required this.image});
//this will convert an object to a map
  Map<String, dynamic> toMap() {
    return {"name": name, "email": email, "address": address, "image": image};
  }

//this will convert a map to an object
  fromMap(Map<String, dynamic> data) {
    return User(
        name: data['name'],
        email: data['email'],
        address: data['password'],
        image: data['image']);
  }
}
