class Person {
  String name;
  String role;
  String about;
  late String linkedin;
  String department;
  String image;
  String department_image;

  Person(
      {required this.name,
      required this.role,
      required this.about,
      required this.department,
      this.image = '',
      this.department_image = ''});

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
