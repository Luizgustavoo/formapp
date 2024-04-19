class CountFamiliesAndPeople {
  final String message;
  final int familyUser;
  final int allFamily;
  final int peopleUser;
  final int allPeople;

  CountFamiliesAndPeople({
    required this.message,
    required this.familyUser,
    required this.allFamily,
    required this.peopleUser,
    required this.allPeople,
  });

  factory CountFamiliesAndPeople.fromJson(Map<String, dynamic> json) {
    return CountFamiliesAndPeople(
      message: json['message'],
      familyUser: json['family_user'],
      allFamily: json['all_family'],
      peopleUser: json['people_user'],
      allPeople: json['all_people'],
    );
  }
}
