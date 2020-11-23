part of exitlive.gitlab;

/// The documentation for this API is here:
/// https://docs.gitlab.com/ee/api/jobs.html
class JobsApi {
  final GitLab _gitLab;
  ProjectsApi _project;

  JobsApi(this._gitLab);

  JobsApi.withProject(this._gitLab, this._project);

  Future<Job> get(int id) async {
    final uri = buildUri(['jobs', '$id']);

    final json = await _gitLab.request(uri) as Map;

    return new Job.fromJson(json);
  }

  Future<Job> cancel(int id) async {
    final uri = buildUri(['jobs', '$id', 'cancel']);

    final json = await _gitLab.request(uri, method: HttpMethod.post) as Map;

    return new Job.fromJson(json);
  }

  Future<List<Job>> list({List<JobScope> scopes, int page, int perPage}) async {
    final queryParameters = <String, dynamic>{};

    if (scopes != null && scopes.isNotEmpty) {
      if (scopes.length == 1) {
        queryParameters['scope'] = enumToString(scopes.first);
      } else {
        for (var i = 0; i < scopes.length; i++) {
          queryParameters['scope[$i]'] = enumToString(scopes[i]);
        }
      }
    }

    final uri = buildUri(['jobs'],
        queryParameters: queryParameters, page: page, perPage: perPage);
    final jsonList = _responseToList(await _gitLab.request(uri));

    return jsonList.map((json) => new Job.fromJson(json)).toList();
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

enum JobScope { created, pending, running, failed, success, canceled, skipped }

class Job {
  final Map originalJson;

  Job.fromJson(this.originalJson);

  int get id => originalJson['id'] as int;
  String get name => originalJson['name'] as String;
  String get ref => originalJson['ref'] as String;
  String get stage => originalJson['stage'] as String;
  String get status => originalJson['status'] as String;
  DateTime get startedAt =>
      DateTime.parse(originalJson['started_at'] as String);
  DateTime get createdAt =>
      DateTime.parse(originalJson['created_at'] as String);
  DateTime get finishedAt =>
      DateTime.parse(originalJson['finished_at'] as String);
  Commit get commit => new Commit.fromJson(originalJson['commit'] as Map);

  @override
  String toString() => 'Build id#$id ($name)';
}
