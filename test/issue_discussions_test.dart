import 'package:gitlab/gitlab.dart';
import 'package:test/test.dart';

import 'assets/json_data.dart' as data;
import 'src/mocks.dart';

void main() {
  group('DiscussionsApi for Issues', () {
    MockGitLabHttpClient mockHttpClient;
    GitLab gitLab;
    IssueDiscussionsApi issueDiscussions;

    final projectId = 1337;
    final issue = Issue.fromJson(data.decodeMap(data.issue));

    final discussionJson = data.decodeList(data.issueDiscussions);
    final discussionId = discussionJson.first["id"] as String;

    setUp(() {
      mockHttpClient = MockGitLabHttpClient();
      gitLab = getTestable(mockHttpClient);
      issueDiscussions = gitLab.project(projectId).issueDiscussions(issue);
    });

    test('Discussion class properly maps the JSON', () async {
      for (var discussioinItem in discussionJson) {
        final discussionJson = discussioinItem as Map<String, dynamic>;
        final Discussion discussion = Discussion.fromJson(discussionJson);

        int i = 0;
        for (var noteItem in discussionJson['notes']) {
          final noteJson = noteItem as Map<String, dynamic>;
          final authorJson = noteJson["author"] as Map<String, dynamic>;

          final Note note = discussion.notes[i++];
          final User author = note.author;

          expect(note.id, noteJson['id']);
          expect(note.type, noteJson['type']);
          expect(note.body, noteJson['body']);
          expect(note.createdAt,
              DateTime.parse(noteJson['created_at'].toString()));
          expect(note.updatedAt,
              DateTime.parse(noteJson['updated_at'].toString()));
          expect(note.isSystemNote, noteJson['system']);

          expect(note.noteableId, noteJson['noteable_id']);
          expect(note.noteableType, noteJson['noteable_type']);
          expect(note.noteableIid, noteJson['noteable_iid']);

          expect(author.id, authorJson['id']);
          expect(author.name, authorJson['name']);
          expect(author.state, authorJson['state']);
          expect(author.avatarUrl, authorJson['avatar_url']);
          expect(author.webUrl, authorJson['web_url']);
        }
      }
    });

    test('.get()', () async {
      final call = mockHttpClient.configureCall(
        path:
            '/projects/$projectId/issues/${issue.iid}/discussions/$discussionId',
        responseBody: data.discussionWithThread,
      );

      final discussion = await issueDiscussions.get(discussionId);

      call.verifyCalled(1);
      expect(discussion.id, discussionId);
    });
    test('.list()', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/issues/${issue.iid}/discussions?',
        responseBody: data.issueDiscussions,
      );

      final discussions = await issueDiscussions.list();

      call.verifyCalled(1);
      expect(discussions, hasLength(2));
      expect(discussions.first.id, discussionId);
    });
    test('.create()', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/issues/${issue.iid}/discussions?body=Hello',
        method: HttpMethod.post,
        responseBody: data.newDiscussion,
      );

      final discussion = await issueDiscussions.create("Hello");

      call.verifyCalled(1);
      expect(discussion.notes.first.body, "Hello");
    });
    test('.addNote(discussionId)', () async {
      final call = mockHttpClient.configureCall(
        path:
            '/projects/$projectId/issues/${issue.iid}/discussions/$discussionId/notes?body=Hello',
        method: HttpMethod.post,
        responseBody: data.newNote,
      );

      final note = await issueDiscussions.addNote(discussionId, "Hello");

      call.verifyCalled(1);
      expect(note.body, "Hello");
    });

    test('.update(discussionId)', () async {
      final call = mockHttpClient.configureCall(
        path:
            '/projects/$projectId/issues/${issue.iid}/discussions/$discussionId/notes/42?body=World',
        method: HttpMethod.put,
        responseBody: data.modifiedNote,
      );

      final note = await issueDiscussions.updateNote(discussionId, 42, "World");

      call.verifyCalled(1);
      expect(note.body, "World");
    });
    test('.delete(discussionId)', () async {
      final call = mockHttpClient.configureCall(
          path:
              '/projects/$projectId/issues/${issue.iid}/discussions/$discussionId/notes/42',
          method: HttpMethod.delete,
          responseStatusCode: 204);

      await issueDiscussions.deleteNote(discussionId, 42);

      call.verifyCalled(1);
    });
  });
}
