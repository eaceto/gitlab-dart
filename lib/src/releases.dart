part of exitlive.gitlab;

class ReleasesApi {
  final GitLab _gitLab;
  final ProjectsApi _project;

  ReleasesApi(this._gitLab, this._project);

  /// Get a Release for the given tag.
  ///
  /// See https://docs.gitlab.com/ee/api/releases/index.html#get-a-release-by-a-tag-name
  Future<Release> get(String tagName) async {
    final uri = _project.buildUri(['releases', '$tagName']);
    final json = await _gitLab.request(uri) as Map<String, dynamic>;
    return new Release.fromJson(json);
  }

  /// Paginated list of Releases, sorted by released_at.
  ///
  /// See https://docs.gitlab.com/ee/api/releases/index.html#list-releases
  Future<List<Release>> list() async {
    final queryParameters = <String, dynamic>{};
    final uri =
        _project.buildUri(['releases'], queryParameters: queryParameters);

    final jsonList = _responseToList(await _gitLab.request(uri));

    return Release.fromJsonList(jsonList);
  }

  /// Create a Release. You need push access to the repository to create a Release.
  /// create from tagName
  /// See https://docs.gitlab.com/ee/api/releases/index.html#create-a-release
  Future<Release> createFromTag(
    String tagName,
    String description, {
    String ref,
    String name,
    String milestone,
  }) {
    return _create(description,
        ref: ref, tagName: tagName, name: name, milestone: milestone);
  }

  /// Create a Release. You need push access to the repository to create a Release.
  /// create from ref
  /// See https://docs.gitlab.com/ee/api/releases/index.html#create-a-release
  Future<Release> createFromRef(
    String ref,
    String description, {
    String tagName,
    String name,
    String milestone,
  }) {
    return _create(description,
        ref: ref, tagName: tagName, name: name, milestone: milestone);
  }

  /// Create a Release. You need push access to the repository to create a Release.
  /// create either from tagName or ref - one is present!
  /// See https://docs.gitlab.com/ee/api/releases/index.html#create-a-release
  Future<Release> _create(
    String description, {
    String ref,
    String tagName,
    String name,
    String milestone,
  }) async {
    final queryParameters = <String, dynamic>{
      'description': description,
      if (tagName != null) 'tag_name': tagName,
      if (name != null) 'name': name,
      if (ref != null) 'ref': ref,
      if (milestone != null) 'milestone': milestone
    };

    final uri =
        _project.buildUri(['releases'], queryParameters: queryParameters);

    final json = await _gitLab.request(
      uri,
      method: HttpMethod.post,
    ) as Map<String, dynamic>;

    return Release.fromJson(json);
  }

  /// Update a Release.
  ///
  /// See https://docs.gitlab.com/ee/api/releases/index.html#update-a-release
  Future<Release> update(
    String tagName, {
    String name,
    String description,
    String milestone,
  }) async {
    final queryParameters = <String, dynamic>{
      'tag_name': tagName,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (milestone != null) 'milestone': milestone
    };

    final uri =
        _project.buildUri(['releases'], queryParameters: queryParameters);

    final json = await _gitLab.request(
      uri,
      method: HttpMethod.put,
    ) as Map<String, dynamic>;

    return Release.fromJson(json);
  }

  /// Delete a Release. Deleting a Release will not delete the associated tag.
  ///
  /// See https://docs.gitlab.com/ee/api/releases/index.html#delete-a-release
  Future<void> delete(String tagName) async {
    final uri = _project.buildUri(
      ['releases', tagName],
    );

    await _gitLab.request(uri, method: HttpMethod.delete, asJson: false);
  }
}

class Release {
  Release.fromJson(Map<String, dynamic> release)
      : tagName = release.getStringOrNull("tag_name"),
        description = release.getStringOrNull("description"),
        descriptionHtml = release.getStringOrNull("description_html"),
        name = release.getStringOrNull("name"),
        createdAt = release.getISODateTimeOrNull("created_at"),
        releasedAt = release.getISODateTimeOrNull("released_at"),
        author = User.fromJson(release.getJsonMap("author")),
        commit = Commit.fromJson(release.getJsonMap("commit")),
        milestones = Milestone.fromJsonList(release["milestones"] as List),
        assets = Asset.fromJson(release.getJsonMap("assets")),
        commitPath = release.getStringOrNull("commit_path"),
        tagPath = release.getStringOrNull("tag_path"),
        evidenceSha = release.getStringOrNull("evidence_sha");

  static List<Release> fromJsonList(List releases) => releases
      ?.map((r) => r is Map<String, dynamic> ? Release.fromJson(r) : null)
      ?.where((release) => release != null)
      ?.toList();

  String tagName;
  String description;
  String descriptionHtml;
  String name;
  User author;
  DateTime createdAt;
  DateTime releasedAt;
  String commitPath;
  String tagPath;
  String evidenceSha;
  Commit commit;
  List<Milestone> milestones;
  Asset assets;
}
