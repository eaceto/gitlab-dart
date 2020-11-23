import 'package:gitlab/gitlab.dart';
import 'package:test/test.dart';

import 'assets/json_data.dart' as data;
import 'src/mocks.dart';

void main() {
  group('MergeRequestsApi', () {
    MockGitLabHttpClient mockHttpClient;
    GitLab gitLab;
    ProjectsApi project;

    final projectId = 1337;

    final mergeRequestsMap = data.decodeMap(data.mergeRequest);
    final mergeRequestId = mergeRequestsMap['id'] as int;
    final mergeRequestIid = mergeRequestsMap['iid'] as int;

    setUp(() {
      mockHttpClient = new MockGitLabHttpClient();

      gitLab = getTestable(mockHttpClient);
      project = gitLab.project(projectId);
    });

    test('MergeRequest class properly maps the JSON', () async {
      final mergeRequest = new MergeRequest.fromJson(mergeRequestsMap);
      expect(mergeRequest.id, mergeRequestsMap['id']);
      expect(mergeRequest.iid, mergeRequestsMap['iid']);

      expect(mergeRequest.targetBranch, mergeRequestsMap['target_branch']);
      expect(mergeRequest.sourceBranch, mergeRequestsMap['source_branch']);

      expect(mergeRequest.projectId, mergeRequestsMap['project_id']);

      expect(mergeRequest.title, mergeRequestsMap['title']);
      expect(mergeRequest.state, mergeRequestsMap['state']);

      expect(mergeRequest.author.id, mergeRequestsMap['author']['id']);
      expect(
          mergeRequest.assignees[0].id, mergeRequestsMap['assignees'][0]['id']);

      expect(mergeRequest.labels, mergeRequestsMap['labels']);
      expect(mergeRequest.labels, ["No Promotion"]);

      expect(mergeRequest.upvotes, mergeRequestsMap['upvotes']);
      expect(mergeRequest.downvotes, mergeRequestsMap['downvotes']);

      expect(mergeRequest.description, mergeRequestsMap['description']);
      expect(mergeRequest.webUrl, mergeRequestsMap['web_url']);
    });

    test('.get()', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/merge_requests/$mergeRequestIid',
        responseBody: data.mergeRequest,
      );

      final mergeRequest = await project.mergeRequests.get(mergeRequestId);

      call.verifyCalled(1);
      expect(mergeRequest.id, mergeRequestId);
    });
    test('.list()', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/merge_requests?',
        responseBody: data.mergeRequests,
      );

      final mergeRequests = await project.mergeRequests.list();

      call.verifyCalled(1);
      expect(mergeRequests, hasLength(1));
    });
    test('.add', () async {
      final call = mockHttpClient.configureCall(
        path:
            '/projects/$projectId/merge_requests?title=Hello&source_branch=feature&target_branch=master',
        method: HttpMethod.post,
        responseBody: data.newMergeRequest,
      );

      final mergeRequest = await project.mergeRequests.add(
        "Hello",
        "feature",
        "master",
      );

      call.verifyCalled(1);
      expect(mergeRequest.title, "Hello");
    });
    test('.update', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/merge_requests/42?title=World',
        method: HttpMethod.put,
        responseBody: data.modifiedMergeRequest,
      );

      final mergeRequest =
          await project.mergeRequests.update(42, title: "World");

      call.verifyCalled(1);
      expect(mergeRequest.title, "World");
    });
    test('.update -- change assignees', () async {
      final call = mockHttpClient.configureCall(
        path:
            '/projects/$projectId/merge_requests/42?assignee_ids%5B%5D=1&assignee_ids%5B%5D=2&assignee_ids%5B%5D=3',
        method: HttpMethod.put,
        responseBody: data.modifiedMergeRequest,
      );

      await project.mergeRequests.update(42, assigneeIds: [1, 2, 3]);

      call.verifyCalled(1);
    });
    test('.update -- clear assignees', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/merge_requests/42?assignee_ids',
        method: HttpMethod.put,
        responseBody: data.modifiedMergeRequest,
      );

      await project.mergeRequests.update(42, assigneeIds: []);

      call.verifyCalled(1);
    });

    test('.update -- bools', () async {
      final call = mockHttpClient.configureCall(
        path:
            '/projects/$projectId/merge_requests/42?remove_source_branch=true&allow_collaboration=true&squash=true',
        method: HttpMethod.put,
        responseBody: data.modifiedIssue,
      );

      await project.mergeRequests.update(
        42,
        removeSourceBranch: true,
        allowCollaboration: true,
        squash: true,
      );

      call.verifyCalled(1);
    });

    test('.delete', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/merge_requests/42',
        method: HttpMethod.delete,
        responseStatusCode: 204,
      );

      await project.mergeRequests.delete(42);

      call.verifyCalled(1);
    });
  });
}
