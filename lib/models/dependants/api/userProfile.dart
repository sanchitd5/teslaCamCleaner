class UserProfileAPIBody {
  late String sId;
  late bool firstLogin;
  late bool emailVerified;
  late bool isBlocked;
  late String firstName;
  late String lastName;
  late String emailId;
  late String phoneNumber;
  late String countryCode;
  String? initialPassword;
  late String registrationDate;

  UserProfileAPIBody({
    required this.sId,
    required this.firstLogin,
    required this.emailVerified,
    required this.isBlocked,
    required this.firstName,
    required this.lastName,
    required this.emailId,
    required this.phoneNumber,
    required this.countryCode,
    required this.initialPassword,
    required this.registrationDate,
  });

  UserProfileAPIBody.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstLogin = json['firstLogin'];
    emailVerified = json['emailVerified'];
    isBlocked = json['isBlocked'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    emailId = json['emailId'];
    phoneNumber = json['phoneNumber'];
    countryCode = json['countryCode'];
    initialPassword = json['initialPassword'];
    registrationDate = json['registrationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['firstLogin'] = firstLogin;
    data['emailVerified'] = emailVerified;
    data['isBlocked'] = isBlocked;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['emailId'] = emailId;
    data['phoneNumber'] = phoneNumber;
    data['countryCode'] = countryCode;
    data['initialPassword'] = initialPassword;
    data['registrationDate'] = registrationDate;
    return data;
  }
}
