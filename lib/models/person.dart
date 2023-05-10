class Person {
  int id;
  String name;
  String role;
  String about;
  late String linkedin;
  String department;
  String image;
  String department_image;

  Person(
      {this.id = 0,
      required this.name,
      required this.role,
      required this.about,
      required this.department,
      this.image = '',
      this.department_image = ''});

  Person.fromJson(Map json)
      : id = json['id'] ?? 0,
        name = json['full_name'] ?? 'Default Full Name',
        role = json['role'] ?? 'Default Role',
        about = json['about'] ?? 'Default About',
        department = json['department'] ?? 'Default Department',
        image =
            'https://pwqrcfdxmgfavontopyn.supabase.co/storage/v1/object/public/users/40a8216a-d486-42c5-bf96-85e8bf5664d6.jpeg',
        department_image =
            'https://pwqrcfdxmgfavontopyn.supabase.co/storage/v1/object/public/departments/electronics.jpeg';

  static Map toMap(Person person) {
    return {
      'full_name': person.name,
      'role': person.role,
      'about': person.about,
      'department': person.department,
    };
  }

  set setRole(String value) {
    role = value;
    //notifyListeners();
  }

  set setAbout(String value) {
    about = value;
    //notifyListeners();
  }

  set setDepartment(String value) {
    department = value;
  }
}
