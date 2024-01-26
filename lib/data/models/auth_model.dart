// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:formapp/data/models/user_model.dart';

class Auth {
  User? user;
  String? accessToken;
  String? tokenType;
  String? expiresIn;
  Auth({
    this.user,
    this.accessToken,
    this.tokenType,
    this.expiresIn,
  });

  @override
  String toString() {
    return 'Auth(user: $user, accessToken: $accessToken, tokenType: $tokenType, expiresIn: $expiresIn)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user?.toMap(),
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
    };
  }

  factory Auth.fromMap(Map<String, dynamic> map) {
    return Auth(
      user: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      accessToken:
          map['access_token'] != null ? map['access_token'] as String : null,
      tokenType: map['token_type'] != null ? map['token_type'] as String : null,
      expiresIn: map['expires_in'] != null ? map['expires_in'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Auth.fromJson(String source) =>
      Auth.fromMap(json.decode(source) as Map<String, dynamic>);
}
