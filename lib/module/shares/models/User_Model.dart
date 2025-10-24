class UserProfile {
  final String hoten;
  final String ngaysinh;
  final String gioitinh;
  final String sdt;
  final String diachi;
  final String cccd;
  final String avatar;

  UserProfile({
    required this.hoten,
    required this.ngaysinh,
    required this.gioitinh,
    required this.sdt,
    required this.diachi,
    required this.cccd,
    required this.avatar,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      hoten: json['hoten'] ?? '',
      ngaysinh: json['ngaysinh'] ?? '',
      gioitinh: json['gioitinh'] ?? '',
      sdt: json['sdt'] ?? '',
      diachi: json['diachi'] ?? '',
      cccd: json['cccd'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hoten': hoten,
      'ngaysinh': ngaysinh,
      'gioitinh': gioitinh,
      'sdt': sdt,
      'diachi': diachi,
      'cccd': cccd,
      'avatar': avatar,
    };
  }
}

class UserModel {
  final String id;
  final String email;
  final String role;
  final UserProfile profile;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      profile: UserProfile.fromJson(json['profile'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'profile': profile.toJson(),
    };
  }
}
