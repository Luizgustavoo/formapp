class CountFamiliesAndPeople {
  final String message;
  final int familyUser;
  final int allFamily;
  final int peopleUser;
  final int liderUser;
  final int allPeople;
  final int allLider;

  CountFamiliesAndPeople(
      {required this.message,
      required this.familyUser,
      required this.allFamily,
      required this.peopleUser,
      required this.allPeople,
      required this.liderUser,
      required this.allLider});

  factory CountFamiliesAndPeople.fromJson(Map<String, dynamic> json) {
    return CountFamiliesAndPeople(
      message: json['message'],
      familyUser: json['family_user'],
      allFamily: json['all_family'],
      peopleUser: json['people_user'],
      allPeople: json['all_people'],
      allLider: json['all_lider'],
      liderUser: json['lider_user'],
    );
  }
}
