part of exitlive.gitlab;

class UsersApi {
  final GitLab _gitLab;

  UsersApi(this._gitLab);

  /// Gets [User] info
  ///
  /// See https://docs.gitlab.com/ee/api/notes.html#create-new-issue-note
  Future<User> getUser(int userId) async {
    final uri = this._gitLab.buildUri(
      ['users', userId.toString()],
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
        state = user.getStringOrNull("state"),
        avatarUrl = user.getStringOrNull("avatar_url"),
        webUrl = user.getStringOrNull("web_url"),
        bio = user.getStringOrNull("bio"),
        bioHtml = user.getStringOrNull("bio_html"),
        twitter = user.getStringOrNull("twitter"),
        linkedin = user.getStringOrNull("linkedin"),
        websiteUrl = user.getStringOrNull("website_url"),
        jobTitle = user.getStringOrNull("job_title"),
        organization = user.getStringOrNull("organization");

  final int id;
  String name;
  String username;
  String state;
  String avatarUrl;
  String webUrl;
  String email;

  String bio;
  String bioHtml;
  String twitter;
  String linkedin;
  String websiteUrl;
  String jobTitle;
  String organization;
}
