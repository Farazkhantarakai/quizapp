class User {
  String name;
  String email;

  String address;
  String image;
  List<String> quizes;
  User(
      {required this.name,
      required this.email,
      required this.address,
      required this.image,
      required this.quizes});
//this will convert an object to a map
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "address": address,
      "image": image,
      "quizes": quizes
    };
  }

//this will convert a map to an object
  fromMap(Map<String, dynamic> data) {
    return User(
        name: data['name'],
        email: data['email'],
        address: data['password'],
        image: data['image'],
        quizes: data['quizes']);
  }
}
