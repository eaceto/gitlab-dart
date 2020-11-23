import 'package:gitlab/gitlab.dart';
import 'package:test/test.dart';

import 'assets/json_data.dart' as data;
import 'src/mocks.dart';

void main() {
  group('IssuesApi', () {
    MockGitLabHttpClient mockHttpClient;
    GitLab gitLab;
    ProjectsApi project;

    final projectId = 1337;

    final Map issueMap = data.decodeMap(data.issue);
    final issueId = issueMap['id'] as int;

    setUp(() {
      mockHttpClient = MockGitLabHttpClient();
      gitLab = getTestable(mockHttpClient);
      project = gitLab.project(projectId);
    });

    test('Issue class properly maps the JSON', () async {
      final issue = new Issue.fromJson(issueMap);
      expect(issue.projectId, issueMap['project_id']);
      expect(issue.id, issueMap['id']);
      expect(issue.iid, issueMap['iid']);

      expect(issue.title, issueMap['title']);
      expect(issue.description, issueMap['description']);

      expect(issue.state, issueMap['state']);
      expect(issue.labels, ["Feature", "Bug"]);
      expect(issue.labels, issueMap['labels']);

      expect(issue.webUrl, issueMap['web_url']);
      expect(issue.author.id, issueMap['author']['id']);
      expect(issue.assignees[0].id, issueMap['assignees'][0]['id']);

      expect(issue.createdAt, DateTime.parse(issueMap['created_at'] as String));
      expect(issue.updatedAt, DateTime.parse(issueMap['updated_at'] as String));

      expect(issue.subscribed, issueMap['subscribed']);

      expect(issue.userNotesCount, issueMap['user_notes_count']);

      expect(issue.dueDate, isNull);
      issue.originalJson['due_date'] = '2016-01-04T15:31:46.176Z';
      expect(issue.dueDate,
          DateTime.parse(issue.originalJson['due_date'] as String));

      expect(issue.confidential, issueMap['confidential']);
      expect(issue.weight, issueMap['weight']);
    });

    test('.get()', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/issues/$issueId',
        responseBody: data.issue,
      );

      final issue = await project.issues.get(issueId);

      call.verifyCalled(1);
      expect(issue.id, issueId);
    });
    test('.list()', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/issues?',
        responseBody: data.issues,
      );

      final issues = await project.issues.list();

      call.verifyCalled(1);
      expect(issues, hasLength(1));
      expect(issues.first.id, 76);
    });
    test('.add', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/issues?title=Hello',
        method: HttpMethod.post,
        responseBody: data.newIssue,
      );

      final issue = await project.issues.add("Hello");

      call.verifyCalled(1);
      expect(issue.title, "Hello");
    });
    test('.update', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/issues/42?title=World',
        method: HttpMethod.put,
        responseBody: data.modifiedIssue,
      );

      final issue = await project.issues.update(42, title: "World");

      call.verifyCalled(1);
      expect(issue.title, "World");
    });

    test('.update -- change assignees', () async {
      final call = mockHttpClient.configureCall(
        path:
            '/projects/$projectId/issues/42?assignee_ids%5B%5D=1&assignee_ids%5B%5D=2&assignee_ids%5B%5D=3',
        method: HttpMethod.put,
        responseBody: data.modifiedIssue,
      );

      await project.issues.update(42, assigneeIds: [1, 2, 3]);

      call.verifyCalled(1);
    });
    test('.update -- clear assignees', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/issues/42?assignee_ids',
        method: HttpMethod.put,
        responseBody: data.modifiedIssue,
      );

      await project.issues.update(42, assigneeIds: []);

      call.verifyCalled(1);
    });
    test('.update -- bools', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/issues/42?confidential=true',
        method: HttpMethod.put,
        responseBody: data.modifiedIssue,
      );

      await project.issues.update(42, confidential: true);

      call.verifyCalled(1);
    });

    test('.delete', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/issues/42',
        method: HttpMethod.delete,
        responseStatusCode: 204,
      );

      await project.issues.delete(42);

      call.verifyCalled(1);
    });
    test('.closedByMergeRequest()', () async {
      final mergeRequestIid = 123;

      final call = mockHttpClient.configureCall(
        path:
            '/projects/$projectId/merge_requests/$mergeRequestIid/closes_issues',
        responseBody: data.issuesClosedByMR,
      );

      final issues = await project.issues.closedByMergeRequest(mergeRequestIid);

      call.verifyCalled(1);
      expect(issues, hasLength(1));
      expect(issues.first.id, 1);
    });
  });
}
