class Person {
  late int id;
  late String name;
  late String role;
  late String about;
  late String linkedin;
  late String department;
  late String image;
  late String department_image;
  late String uuid;

  Person(
      {this.id = 0,
      required this.name,
      required this.role,
      required this.about,
      required this.department,
      required this.uuid,
      this.image = '',
      this.department_image = ''});

  Person.fromJson(Map json) {
    this.id = json['id'] ?? 0;
    this.name = json['full_name'] ?? 'Default Full Name';
    this.role = json['role'] ?? 'Default Role';
    this.about = json['about'] ?? 'Default About';
    this.department = json['department'] ?? 'Default Department';
    this.uuid = json['uuid'];
    this.image =
        'https://pwqrcfdxmgfavontopyn.supabase.co/storage/v1/object/public/users/' +
            uuid +
            '.jpeg';
    this.department_image =
        'https://pwqrcfdxmgfavontopyn.supabase.co/storage/v1/object/public/departments/' +
            department +
            '.jpeg';
  }

  Person.empty()
      : id = 0,
        about = 'default about',
        department = 'default department',
        name = 'default name',
        role = 'default role',
        department_image = 'default department image link',
        image = 'default image link';

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
