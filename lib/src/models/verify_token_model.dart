class VerifyTokenResponse {
  final String? status;
  final String? message;
  final UserData? data;

  VerifyTokenResponse({this.status, this.message, this.data});

  factory VerifyTokenResponse.fromJson(Map<String, dynamic> json) {
    // Check for JSON-RPC "result" field
    if (json.containsKey('result')) {
      final result = json['result'];
      if (result is Map<String, dynamic>) {
        final userLoginData = result['user_login'];
        UserData? userData;
        if (userLoginData is Map<String, dynamic>) {
          userData = UserData.fromRpcJson(userLoginData);
        }

        return VerifyTokenResponse(
          status: (result['success'] == true || result['status'] == 'success')
              ? 'success'
              : 'error',
          message: result['message'] as String?,
          data: userData,
        );
      }
    }

    return VerifyTokenResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? UserData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class UserData {
  final int? uid;
  final String? name;
  final String? userRole;
  // Add more fields here as needed based on API response
  // The user mentioned "more fields need to come in"
  final String? email;
  final String? mobile;
  final String? image;

  UserData({
    this.uid,
    this.name,
    this.userRole,
    this.email,
    this.mobile,
    this.image,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      uid: json['uid'] as int?,
      name: json['name'] as String?,
      userRole: json['user_role'] as String?,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      image: json['image'] as String?,
    );
  }

  factory UserData.fromRpcJson(Map<String, dynamic> json) {
    return UserData(
      uid: json['user_Id'] as int?,
      name: json['name'] ?? json['user_login'] as String?,
      userRole: json['user_role'] as String?,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      image: json['image'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserData &&
        other.uid == uid &&
        other.name == name &&
        other.userRole == userRole &&
        other.email == email &&
        other.mobile == mobile &&
        other.image == image;
  }

  @override
  int get hashCode {
    return Object.hash(uid, name, userRole, email, mobile, image);
  }
}
