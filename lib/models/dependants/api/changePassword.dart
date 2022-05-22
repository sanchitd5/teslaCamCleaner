class ChangePasswordAPIBody {
  bool skip;
  String oldPassword, newPassword;
  ChangePasswordAPIBody({
    required this.skip,
    required this.oldPassword,
    required this.newPassword,
  });
  Map<String, String> toJSON() => {
        'skip': skip.toString(),
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      };
}
