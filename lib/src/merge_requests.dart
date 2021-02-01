part of exitlive.gitlab;

class MergeRequestsApi {
  final GitLab _gitLab;
  ProjectsApi _project;

  MergeRequestsApi(this._gitLab);

  MergeRequestsApi.withProject(this._gitLab, this._project);

  Future<MergeRequest> get(int iid) async {
    final pathSegments = ['merge_requests', '$iid'];
    final uri = buildUri(pathSegments);

    final json = await _gitLab.request(uri) as Map;

    return new MergeRequest.fromJson(json);
  }

  Future<MergeRequestApproval> getApprovalInfo(int iid) async {
    final pathSegments = ['merge_requests', '$iid', 'approval_state'];
    final uri = buildUri(pathSegments);

    final json = await _gitLab.request(uri) as Map;

    return new MergeRequestApproval.fromJson(json);
  }

  Future<MergeRequestApproval> approve(int iid) async {
    final pathSegments = ['merge_requests', '$iid', 'approve'];
    final uri = buildUri(pathSegments);

    final json = await _gitLab.request(uri) as Map;

    return new MergeRequestApproval.fromJson(json);
  }

  Future<MergeRequestApproval> unapprove(int iid) async {
    final pathSegments = ['merge_requests', '$iid', 'unapprove'];
    final uri = buildUri(pathSegments);

    final json = await _gitLab.request(uri) as Map;

    return new MergeRequestApproval.fromJson(json);
  }

  Future<List<MergeRequest>> list(
      {MergeRequestState state,
      MergeRequestOrderBy orderBy,
      MergeRequestSort sort,
      int authorId,
      List<String> assigneeId, // 'None', 'Any', or list of UserIds
      MergeRequestScope scope,
      int page,
      int perPage,
      List<int> iids}) async {
    final queryParameters = <String, dynamic>{};

    if (state != null) queryParameters['state'] = enumToString(state);
    if (orderBy != null) queryParameters['order_by'] = enumToString(orderBy);
    if (sort != null) queryParameters['sort'] = enumToString(sort);
    if (scope == null) queryParameters['scope'] = enumToString(scope);
    if (iids != null && iids.isNotEmpty)
      queryParameters['iids[]'] = iids.map((iid) => iid.toString());
    if (assigneeId != null && assigneeId.isNotEmpty)
      queryParameters['assignee_id'] = assigneeId;
    if (authorId != null) queryParameters['author_id'] = authorId.toString();

    final uri = buildUri(['merge_requests'],
        queryParameters: queryParameters, page: page, perPage: perPage);

    final jsonList = _responseToList(await _gitLab.request(uri));

    return jsonList.map((json) => new MergeRequest.fromJson(json)).toList();
  }

  /// Creates a new merge request.
  ///
  /// See https://docs.gitlab.com/ee/api/merge_requests.html#create-mr
  Future<MergeRequest> add(
    String title,
    String sourceBranch,
    String targetBranch, {
    List<int> assigneeIds,
    String description,
    int targetProjectId,
    List<String> labels,
    int milestoneId,
    bool removeSourceBranch,
    bool allowCollaboration,
    bool squash,
  }) async {
    final queryParameters = <String, dynamic>{
      "title": title,
      "source_branch": sourceBranch,
      "target_branch": targetBranch,
      if (assigneeIds != null) ..._encodeAssigneeIds(assigneeIds),
      if (description != null) "description": description,
      if (targetProjectId != null) "target_project_id": targetProjectId,
      if (labels != null) "labels": labels.join(','),
      if (milestoneId != null) "milestone_id": milestoneId,
      if (removeSourceBranch != null)
        "remove_source_branch": removeSourceBranch.toString(),
      if (allowCollaboration != null)
        "allow_collaboration": allowCollaboration.toString(),
      if (squash != null) "squash": squash.toString(),
    };

    final uri = buildUri(['merge_requests'], queryParameters: queryParameters);

    final json = await _gitLab.request(
      uri,
      method: HttpMethod.post,
    ) as Map<String, dynamic>;

    return MergeRequest.fromJson(json);
  }

  /// Accept a Merge Request by MRiid
  ///
  /// See https://docs.gitlab.com/ee/api/merge_requests.html#accept-mr
  Future<MergeRequest> accept(mergeRequestIid,
      {bool shouldRemoveSourceBranch = false,
      bool squash = false,
      bool mergeWhenPipelineSucceeds = false,
      String mergeCommitMessage,
      String squashCommitMessage}) async {
    final queryParameters = <String, dynamic>{
      if (shouldRemoveSourceBranch == true) "should_remove_source_branch": true,
      if (squash == true) "squash": true,
      if (mergeWhenPipelineSucceeds == true)
        "merge_when_pipeline_succeeds": true,
      if (mergeCommitMessage != null && mergeCommitMessage.isNotEmpty)
        "merge_commit_message": mergeCommitMessage,
      if (squashCommitMessage != null && squashCommitMessage.isNotEmpty)
        "squash_commit_message": squashCommitMessage
    };

    final uri = buildUri(
      ['merge_requests', mergeRequestIid.toString(), 'merge'],
      queryParameters: queryParameters,
    );

    final json = await _gitLab.request(
      uri,
      method: HttpMethod.put,
    ) as Map<String, dynamic>;

    return MergeRequest.fromJson(json);
  }

  /// Updates an existing merge request.
  ///
  /// See https://docs.gitlab.com/ee/api/merge_requests.html#update-mr
  Future<MergeRequest> update(
    mergeRequestIid, {
    String title,
    String sourceBranch,
    String targetBranch,
    List<int> assigneeIds,
    String description,
    int targetProjectId,
    List<String> labels,
    int milestoneId,
    bool removeSourceBranch,
    bool allowCollaboration,
    bool squash,
  }) async {
    final queryParameters = <String, dynamic>{
      if (title != null) "title": title,
      if (sourceBranch != null) "source_branch": sourceBranch,
      if (targetBranch != null) "target_branch": targetBranch,
      if (assigneeIds != null) ..._encodeAssigneeIds(assigneeIds),
      if (description != null) "description": description,
      if (targetProjectId != null) "target_project_id": targetProjectId,
      if (labels != null) "labels": labels.join(','),
      if (milestoneId != null) "milestone_id": milestoneId,
      if (removeSourceBranch != null)
        "remove_source_branch": removeSourceBranch.toString(),
      if (allowCollaboration != null)
        "allow_collaboration": allowCollaboration.toString(),
      if (squash != null) "squash": squash.toString(),
    };

    final uri = buildUri(
      ['merge_requests', mergeRequestIid.toString()],
      queryParameters: queryParameters,
    );

    final json = await _gitLab.request(
      uri,
      method: HttpMethod.put,
    ) as Map<String, dynamic>;

    return MergeRequest.fromJson(json);
  }

  /// Deletes an existing merge request.
  ///
  /// See https://docs.gitlab.com/ee/api/merge_requests.html#delete-a-merge-request
  Future<void> delete(int mergeRequestIid) async {
    final uri = buildUri(
      ['merge_requests', mergeRequestIid.toString()],
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

enum MergeRequestState { merged, opened, closed }
enum MergeRequestOrderBy { createdAt, updatedAt }
enum MergeRequestSort { asc, desc }
enum MergeRequestScope { all, createdByMe, assignedToMe }

class MergeRequest {
  final Map originalJson;

  MergeRequest.fromJson(this.originalJson);

  int get id => originalJson['id'] as int;

  int get iid => originalJson['iid'] as int;

  String get targetBranch => originalJson['target_branch'] as String;

  String get sourceBranch => originalJson['source_branch'] as String;

  int get projectId => originalJson['project_id'] as int;

  String get title => originalJson['title'] as String;

  String get state => originalJson['state'] as String;

  List<String> get labels => (originalJson['labels'] as List).cast<String>();

  int get upvotes => originalJson['upvotes'] as int;

  int get downvotes => originalJson['downvotes'] as int;

  String get description => originalJson['description'] as String;

  String get webUrl => originalJson['web_url'] as String;

  User get author => originalJson['author'] == null
      ? null
      : User.fromJson(originalJson['author'] as Map<String, dynamic>);

  User get mergedBy => originalJson['merged_by'] == null
      ? null
      : User.fromJson(originalJson['merged_by'] as Map<String, dynamic>);

  List<User> get assignees => originalJson['assignees'] == null
      ? []
      : (originalJson['assignees'] as List)
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList(growable: false);

  bool get hasConflicts => originalJson['has_conflicts'] == null
      ? false
      : originalJson['has_conflicts'] as bool;

  bool get blockingDiscussionsResolved =>
      originalJson['blocking_discussions_resolved'] == null
          ? false
          : originalJson['blocking_discussions_resolved'] as bool;

  bool get mergeWhenPipelineSucceeds =>
      originalJson['merge_when_pipeline_succeeds'] == null
          ? false
          : originalJson['merge_when_pipeline_succeeds'] as bool;

  String get mergeStatus => originalJson['merge_status'] == null
      ? "unknown"
      : originalJson['merge_status'] as String;

  @override
  String toString() => 'MergeRequest id#$id iid#$iid ($title)';
}

class MergeRequestApproval {
  final Map originalJson;

  MergeRequestApproval.fromJson(this.originalJson);

  int get id => originalJson['id'] as int; // approval ID

  int get iid => originalJson['iid'] as int; // Merge Request ID

  int get projectId => originalJson['project_id'] as int; // Project ID

  String get title => originalJson['title'] as String;

  String get description => originalJson['description'] as String;

  String get state => originalJson['state'] as String;

  int get approvalsRequired => originalJson['approvals_required'] as int;

  int get approvalsLeft => originalJson['approvals_left'] as int;

  List<User> get approvedBy => originalJson['approved_by'] == null
      ? null
      : (originalJson['approved_by'] as List)
          .map((e) => e as Map<String, dynamic>)
          .map((e) => User.fromJson(e))
          .toList();

  @override
  String toString() =>
      'MergeRequest Approval id#$id iid#$iid projectId($projectId)';
}
