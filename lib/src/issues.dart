part of exitlive.gitlab;

class IssuesApi {
  final GitLab _gitLab;
  ProjectsApi _project;

  IssuesApi(this._gitLab);

  IssuesApi.withProject(this._gitLab, this._project);

  Future<Issue> get(int id) async {
    final uri = buildUri(['issues', '$id']);

    final json = await _gitLab.request(uri) as Map;

    return new Issue.fromJson(json);
  }

  Future<List<Issue>> closedByMergeRequest(int mergeRequestIid,
      {int page, int perPage}) async {
    final uri = _project.buildUri(
      ['merge_requests', '$mergeRequestIid', 'closes_issues'],
      page: page,
      perPage: perPage,
    );

    final jsonList = (await _gitLab.request(uri) as List).cast<Map>();

    return jsonList.map((json) => new Issue.fromJson(json)).toList();
  }

  Future<List<Issue>> list(
      {IssueState state,
      IssueOrderBy orderBy,
      IssueSort sort,
      String milestone,
      List<String> labels,
      int page,
      int perPage}) async {
    final queryParameters = <String, dynamic>{};

    if (state != null) queryParameters['state'] = enumToString(state);
    if (orderBy != null) queryParameters['order_by'] = enumToString(orderBy);
    if (sort != null) queryParameters['sort'] = enumToString(sort);
    if (milestone != null) queryParameters['milestone'] = milestone;
    if (labels != null) queryParameters['labels'] = labels.join(',');

    final uri = buildUri(['issues'],
        queryParameters: queryParameters, page: page, perPage: perPage);

    final jsonList = _responseToList(await _gitLab.request(uri));

    return jsonList.map((json) => new Issue.fromJson(json)).toList();
  }

  /// Creates a new issue.
  ///
  /// See https://docs.gitlab.com/ee/api/issues.html#new-issue
  Future<Issue> add(
    String title, {
    String description,
    bool confidential,
    List<int> assigneeIds,
    int milestoneId,
    List<String> labels,
    DateTime dueDate,
    int mergeRequestToResolveDiscussionsOf,
    String discussionToResolve,
    int weight,
    int epicId,
  }) async {
    final queryParameters = <String, dynamic>{
      "title": title,
      if (description != null) "description": description,
      if (confidential != null) "confidential": confidential.toString(),
      if (assigneeIds != null) ..._encodeAssigneeIds(assigneeIds),
      if (milestoneId != null) "milestone_id": milestoneId,
      if (labels != null) "labels": labels.join(','),
      if (dueDate != null) "due_date": DateFormat.yMd().format(dueDate),
      if (mergeRequestToResolveDiscussionsOf != null)
        "merge_request_to_resolve_discussions_of":
            mergeRequestToResolveDiscussionsOf,
      if (discussionToResolve != null)
        "discussion_to_resolve": discussionToResolve,
      if (weight != null) "weight": weight,
      if (epicId != null) "epic_id": epicId,
    };

    final uri = buildUri(['issues'], queryParameters: queryParameters);

    final json = await _gitLab.request(
      uri,
      method: HttpMethod.post,
    ) as Map<String, dynamic>;

    return Issue.fromJson(json);
  }

  /// Updates an existing issue.
  ///
  /// See https://docs.gitlab.com/ee/api/issues.html#edit-issue
  Future<Issue> update(
    int issueIid, {
    String title,
    String description,
    bool confidential,
    List<int> assigneeIds,
    int milestoneId,
    List<String> labels,
    DateTime dueDate,
    int mergeRequestToResolveDiscussionsOf,
    String discussionToResolve,
    int weight,
    int epicId,
  }) async {
    final queryParameters = <String, dynamic>{
      if (title != null) "title": title,
      if (description != null) "description": description,
      if (confidential != null) "confidential": confidential.toString(),
      if (assigneeIds != null) ..._encodeAssigneeIds(assigneeIds),
      if (milestoneId != null) "milestone_id": milestoneId,
      if (labels != null) "labels": labels.join(','),
      if (dueDate != null) "due_date": DateFormat.yMd().format(dueDate),
      if (mergeRequestToResolveDiscussionsOf != null)
        "merge_request_to_resolve_discussions_of":
            mergeRequestToResolveDiscussionsOf,
      if (discussionToResolve != null)
        "discussion_to_resolve": discussionToResolve,
      if (weight != null) "weight": weight,
      if (epicId != null) "epic_id": epicId,
    };

    final uri = buildUri(
      ['issues', issueIid.toString()],
      queryParameters: queryParameters,
    );

    final json = await _gitLab.request(
      uri,
      method: HttpMethod.put,
    ) as Map<String, dynamic>;

    return Issue.fromJson(json);
  }

  /// Deletes an existing issue.
  ///
  /// See https://docs.gitlab.com/ee/api/issues.html#delete-an-issue
  Future<void> delete(int issueIid) async {
    final uri = buildUri(
      ['issues', issueIid.toString()],
    );

    await _gitLab.request(uri, method: HttpMethod.delete, asJson: false);
  }

  @visibleForTesting
  Uri buildUri(Iterable<String> pathSegments,
      {Map<String, dynamic> queryParameters, int page, int perPage}) {
    if (_project != null) {
      return _project.buildUri(pathSegments,
          queryParameters: queryParameters, page: page, perPage: perPage);
    }
    return _gitLab.buildUri(pathSegments,
        queryParameters: queryParameters, page: page, perPage: perPage);
  }
}

enum IssueState { opened, closed }
enum IssueOrderBy { createdAt, updatedAt }
enum IssueSort { asc, desc }

class Issue {
  final Map originalJson;

  Issue.fromJson(this.originalJson);

  int get projectId => originalJson['project_id'] as int;

  int get id => originalJson['id'] as int;

  int get iid => originalJson['iid'] as int;

  String get title => originalJson['title'] as String;

  String get description => originalJson['description'] as String;

  String get state => originalJson['state'] as String;

  List<String> get labels => (originalJson['labels'] as List).cast<String>();

  String get webUrl => originalJson['web_url'] as String;

  User get author => originalJson['author'] == null
      ? null
      : User.fromJson(originalJson['author'] as Map<String, dynamic>);

  List<User> get assignees => originalJson['assignees'] == null
      ? []
      : (originalJson['assignees'] as List)
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList(growable: false);

  DateTime get createdAt =>
      DateTime.parse(originalJson['created_at'] as String);

  DateTime get updatedAt =>
      DateTime.parse(originalJson['updated_at'] as String);

  bool get subscribed => originalJson['subscribed'] as bool;

  int get userNotesCount => originalJson['user_notes_count'] as int;

  DateTime get dueDate => originalJson['due_date'] == null
      ? null
      : DateTime.parse(originalJson['due_date'] as String);

  bool get confidential => originalJson['confidential'] as bool;

  int get weight => originalJson['weight'] as int;

  @override
  String toString() => 'Issue id#$id iid#$iid ($title)';
}
