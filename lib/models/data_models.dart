import 'dart:convert';

class User {
  final int idUser;
  final String userRole;
  final String fullName;
  final String email;
  final String password;
  final String status;
  final DateTime registrationDate;

  User({
    required this.idUser,
    required this.userRole,
    required this.fullName,
    required this.email,
    required this.password,
    this.status = "Activo",
    DateTime? registrationDate,
  }) : registrationDate = registrationDate ?? DateTime.now();

  // Métodos de conversión
  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'userRole': userRole,
      'fullName': fullName,
      'email': email,
      'password': password,
      'status': status,
      'registrationDate': registrationDate.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      idUser: map['idUser'],
      userRole: map['userRole'],
      fullName: map['fullName'],
      email: map['email'],
      password: map['password'],
      status: map['status'],
      registrationDate: DateTime.parse(map['registrationDate']),
    );
  }

  String toJson() => json.encode(toMap());
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}

class Activity {
  final int idActivity;
  final int idUser;
  final String title;
  final String description;
  String status;
  final String priority;
  final DateTime registrationDate;

  Activity({
    required this.idActivity,
    required this.idUser,
    required this.title,
    required this.description,
    this.status = "Registrado",
    required this.priority,
    DateTime? registrationDate,
  }) : registrationDate = registrationDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'idActivity': idActivity,
      'idUser': idUser,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'registrationDate': registrationDate.toIso8601String(),
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      idActivity: map['idActivity'],
      idUser: map['idUser'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      priority: map['priority'],
      registrationDate: DateTime.parse(map['registrationDate']),
    );
  }

  String toJson() => json.encode(toMap());
  factory Activity.fromJson(String source) =>
      Activity.fromMap(json.decode(source));
}

class EventActivity {
  final int idEvent;
  final int idUser;
  final int idActivity;
  final String eventEntity;
  final String? sentimentActivity;
  final String eventType;
  final DateTime eventRegistrationDate;

  EventActivity({
    required this.idEvent,
    required this.idUser,
    required this.idActivity,
    required this.eventEntity,
    this.sentimentActivity,
    required this.eventType,
    DateTime? eventRegistrationDate,
  }) : eventRegistrationDate = eventRegistrationDate ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'idEvent': idEvent,
      'idUser': idUser,
      'idActivity': idActivity,
      'eventEntity': eventEntity,
      'sentimentActivity': sentimentActivity,
      'eventType': eventType,
      'eventRegistrationDate': eventRegistrationDate.toIso8601String(),
    };
  }

  factory EventActivity.fromMap(Map<String, dynamic> map) {
    return EventActivity(
      idEvent: map['idEvent'],
      idUser: map['idUser'],
      idActivity: map['idActivity'],
      eventEntity: map['eventEntity'],
      sentimentActivity: map['sentimentActivity'],
      eventType: map['eventType'],
      eventRegistrationDate: DateTime.parse(map['eventRegistrationDate']),
    );
  }

  String toJson() => json.encode(toMap());
  factory EventActivity.fromJson(String source) =>
      EventActivity.fromMap(json.decode(source));
}

class DataLists {
  // --- usersList ---
  static List<User> usersList = [
    User(
      idUser: 1,
      userRole: "Padre",
      fullName: "Admin Padre",
      email: "padre@pokoplus.com",
      password: "123456",
    ),
    User(
      idUser: 2,
      userRole: "Hijo",
      fullName: "Pequeño Héroe",
      email: "hijo@pokoplus.com",
      password: "123456",
    ),
  ];

  static User? findUserByEmail(String email) {
    try {
      return usersList.firstWhere((u) => u.email == email);
    } catch (e) {
      return null;
    }
  }

  // --- activityList ---
  static List<Activity> activityList = [
    Activity(
      idActivity: 1,
      idUser: 2,
      title: "Tender la cama",
      description: "Dejar el cuarto ordenado",
      priority: "Alta",
    ),
    Activity(
      idActivity: 2,
      idUser: 2,
      title: "Lavar platos",
      description: "Ayudar en la cocina",
      priority: "Media",
    ),
    Activity(
      idActivity: 3,
      idUser: 2,
      title: "Sacar la basura",
      description: "Llevar la bolsa al contenedor",
      priority: "Baja",
    ),
    Activity(
      idActivity: 4,
      idUser: 2,
      title: "Estudiar Matemáticas",
      description: "Repasar sumas",
      priority: "Alta",
      status: "En progreso",
    ),
    Activity(
      idActivity: 5,
      idUser: 2,
      title: "Guardar juguetes",
      description: "Limpiar zona de juegos",
      priority: "Media",
      status: "Terminado",
    ),
  ];

  static Activity? findActivityById(int idActivity) {
    try {
      return activityList.firstWhere((a) => a.idActivity == idActivity);
    } catch (e) {
      return null;
    }
  }

  // --- eventActivityList ---
  static List<EventActivity> eventActivityList = [];

  // Métodos genéricos para cumplir con los requerimientos (ejemplo para Activity)
  static void addActivity(Activity act) => activityList.add(act);
  static void removeActivity(int id) =>
      activityList.removeWhere((a) => a.idActivity == id);
  static List<Activity> filterActivities(String status) =>
      activityList.where((a) => a.status == status).toList();
  static void sortActivitiesByPriority() =>
      activityList.sort((a, b) => a.priority.compareTo(b.priority));

  static void updateActivity(Activity updatedActivity) {
    final index = activityList.indexWhere(
      (a) => a.idActivity == updatedActivity.idActivity,
    );
    if (index != -1) {
      activityList[index] = updatedActivity;
    }
  }
}
