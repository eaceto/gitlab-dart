part of exitlive.gitlab;

class UsersApi {
  final GitLab _gitLab;

  UsersApi(this._gitLab);

  /// Gets [User] info
  Future<User> getUser(int userId) async {
    final uri = this._gitLab.buildUri(
      ['users', userId.toString()],
    );

    final json = await this._gitLab.request(uri, method: HttpMethod.get)
        as Map<String, dynamic>;

    return User.fromJson(json);
  }

  /// Gets the current [User] info
  Future<User> me() async {
    final uri = this._gitLab.buildUri(
      ['user'],
    );

    final json = await this._gitLab.request(uri, method: HttpMethod.get)
        as Map<String, dynamic>;

    return User.fromJson(json);
  }
}

class User {
  User.fromJson(Map<String, dynamic> user)
      : id = user.getIntOrNull("id"),
        name = user.getStringOrNull("name"),
        username = user.getStringOrNull("username"),
        email = user.getStringOrNull("email"),
        publicEmail = user.getStringOrNull("public_email"),
        state = user.getStringOrNull("state"),
        avatarUrl = user.getStringOrNull("avatar_url"),
        webUrl = user.getStringOrNull("web_url"),
        bio = user.getStringOrNull("bio"),
        bioHtml = user.getStringOrNull("bio_html"),
        location = user.getStringOrNull("location"),
        skype = user.getStringOrNull("skype"),
        twitter = user.getStringOrNull("twitter"),
        linkedin = user.getStringOrNull("linkedin"),
        websiteUrl = user.getStringOrNull("website_url"),
        jobTitle = user.getStringOrNull("job_title"),
        organization = user.getStringOrNull("organization"),
        workInformation = user.getStringOrNull("work_information"),
        lastSignInAt = user.getStringOrNull("last_sign_in_at"),
        twoFactorEnabled = user.getBoolOr("two_factor_enabled", false);

  final int id;
  String name;
  String username;
  String state;
  String avatarUrl;
  String webUrl;
  String publicEmail;
  String email;
  String location;

  String bio;
  String bioHtml;
  String skype;
  String twitter;
  String linkedin;
  String websiteUrl;
  String jobTitle;
  String organization;
  String workInformation;
  String lastSignInAt;
  bool twoFactorEnabled;

  String displayedEmail() {
    if (this.email != null && this.email.isNotEmpty) {
      return this.email;
    }
    return this.publicEmail;
  }
}
