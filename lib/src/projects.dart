part of exitlive.gitlab;

class ProjectsApi {
  final GitLab _gitLab;

  int id;

  ProjectsApi(this._gitLab);

  ProjectsApi.withProjectId(this._gitLab, this.id);

  MergeRequestsApi _mergeRequestsApi;

  MergeRequestsApi get mergeRequests =>
      _mergeRequestsApi ??= MergeRequestsApi.withProject(_gitLab, this);

  IssuesApi _issuesApi;

  IssuesApi get issues => _issuesApi ??= IssuesApi.withProject(_gitLab, this);

  /// Get the [IssueNotesApi] for an [issue].
  ///
  /// This call doesn't do anything by itself, other than return the
  /// configured object.
  /// You can safely store the returned object and reuse it.
  IssueNotesApi issueNotes(Issue issue) => issueNotesByIid(issue.iid);

  /// Get the [IssueNotesApi] for an [issueIid].
  ///
  /// This call doesn't do anything by itself, other than return the
  /// configured object.
  /// You can safely store the returned object and reuse it.
  IssueNotesApi issueNotesByIid(int issueIid) => IssueNotesApi(
        _gitLab,
        this,
        issueIid,
      );

  /// Get the [IssueDiscussionsApi] for an [issue].
  ///
  /// This call doesn't do anything by itself, other than return the
  /// configured object.
  /// You can safely store the returned object and reuse it.
  IssueDiscussionsApi issueDiscussions(Issue issue) =>
      issueDiscussionsByIid(issue.iid);

  /// Get the [IssueDiscussionsApi] for an [issueIid].
  ///
  /// This call doesn't do anything by itself, other than return the
  /// configured object.
  /// You can safely store the returned object and reuse it.
  IssueDiscussionsApi issueDiscussionsByIid(int issueIid) =>
      IssueDiscussionsApi(
        _gitLab,
        this,
        issueIid,
      );

  SnippetsApi _snippetsApi;

  SnippetsApi get snippets =>
      _snippetsApi ??= SnippetsApi.withProject(_gitLab, this);

  CommitsApi _commitsApi;

  CommitsApi get commits => _commitsApi ??= new CommitsApi(_gitLab, this);

  JobsApi _jobsApi;

  JobsApi get jobs => _jobsApi ??= JobsApi.withProject(_gitLab, this);

  PipelinesApi _pipelinesApi;

  PipelinesApi get pipelines =>
      _pipelinesApi ??= PipelinesApi.withProject(_gitLab, this);

  ReleasesApi _releasesApi;

  ReleasesApi get releases => _releasesApi ??= new ReleasesApi(_gitLab, this);

  /// Fetch info of the current project
  Future<Project> project({int projectId}) async {
    if (projectId == null) {
      projectId = id;
    }
    final queryParameters = <String, dynamic>{};
    queryParameters['statistics'] = true;

    final uri = _gitLab.buildUri(['projects', projectId.toString()],
        queryParameters: queryParameters);

    final json = await _gitLab.request(uri) as Map<String, dynamic>;

    return new Project.fromJson(json);
  }

  /// List all [Project] visible by the user's access token.
  Future<List<Project>> listAllProjects(
      {int page,
      int perPage,
      String orderBy,
      String search,
      bool membership = true}) async {
    final queryParameters = <String, dynamic>{};

    if (orderBy != null && orderBy.isNotEmpty) {
      queryParameters['order_by'] = orderBy;
    } else {
      queryParameters['order_by'] = 'updated_at';
    }
    if (search != null && search.isNotEmpty) queryParameters['search'] = search;
    queryParameters['membership'] = membership.toString();

    final uri = _gitLab.buildUri(['projects'],
        queryParameters: queryParameters, page: page, perPage: perPage);

    final jsonList = _responseToList(await _gitLab.request(uri));

    return jsonList.map((json) => new Project.fromJson(json)).toList();
  }

  /// List all [User]'s [Project]s.
  Future<List<Project>> listMyProjects(int userId,
      {int page, int perPage, String orderBy, String search}) async {
    final queryParameters = <String, dynamic>{};

    if (orderBy != null && orderBy.isNotEmpty) {
      queryParameters['order_by'] = orderBy;
    } else {
      queryParameters['order_by'] = 'updated_at';
    }
    if (search != null && search.isNotEmpty) queryParameters['search'] = search;

    final uri = _gitLab.buildUri(['users', userId.toString(), 'projects'],
        queryParameters: queryParameters, page: page, perPage: perPage);

    final jsonList = _responseToList(await _gitLab.request(uri));

    return jsonList.map((json) => new Project.fromJson(json)).toList();
  }

  @visibleForTesting
  Uri buildUri(Iterable<String> pathSegments,
      {Map<String, dynamic> queryParameters, int page, int perPage}) {
    dynamic _addQueryParameter(String key, dynamic value) =>
        (queryParameters ??= new Map<String, dynamic>())[key] = '$value';

    if (page != null) _addQueryParameter('page', page);
    if (perPage != null) _addQueryParameter('per_page', perPage);

    return _gitLab.buildUri(['projects', id.toString()]..addAll(pathSegments),
        queryParameters: queryParameters, page: page, perPage: perPage);
  }
}

//Ref: https://docs.gitlab.com/ee/api/projects.html#list-all-projects
class Project {
  final Map originalJson;

  Project.fromJson(this.originalJson);

  int get id => originalJson['id'] as int;

  String get description => originalJson['description'] as String;
  String get defaultBranch => originalJson['default_branch'] as String;
  String get visibility => originalJson['visibility'] as String;
  String get repoSshUrl => originalJson['ssh_url_to_repo'] as String;
  String get repoHttpsUrl => originalJson['http_url_to_repo'] as String;
  String get repoWebUrl => originalJson['web_url'] as String;
  String get webUrl => originalJson['web_url'] as String;

  String get name => originalJson['name'] as String;
  String get nameWithNamespace => originalJson['name_with_namespace'] as String;

  int get openIssuesCount => originalJson['open_issues_count'] as int;
  int get starCount => originalJson['star_count'] as int;
  int get forksCount => originalJson['forks_count'] as int;

  String get avatarUrl => originalJson['avatar_url'] as String;

  @override
  String toString() => 'Project id#$id ($name)';
}
