import 'package:gitlab/gitlab.dart';
import 'package:test/test.dart';

import 'assets/json_data.dart' as data;
import 'src/mocks.dart';

void main() {
  group('NotesApi for Issues', () {
    MockGitLabHttpClient mockHttpClient;
    GitLab gitLab;
    IssueNotesApi issueNotes;

    final projectId = 1337;
    final issue = Issue.fromJson(data.decodeMap(data.issue));

    final notesJson = data.decodeList(data.issueNotes);

    setUp(() {
      mockHttpClient = MockGitLabHttpClient();
      gitLab = getTestable(mockHttpClient);
      issueNotes = gitLab.project(projectId).issueNotes(issue);
    });

    test('Note class properly maps the JSON', () async {
      for (var item in notesJson) {
        final noteJson = item as Map<String, dynamic>;
        final authorJson = noteJson["author"] as Map<String, dynamic>;

        final Note note = Note.fromJson(noteJson);
        final User author = note.author;

        expect(note.id, noteJson['id']);
        expect(note.type, noteJson['type']);
        expect(note.body, noteJson['body']);
        expect(
            note.createdAt, DateTime.parse(noteJson['created_at'].toString()));
        expect(
            note.updatedAt, DateTime.parse(noteJson['updated_at'].toString()));
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
    });

    test('.get()', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/issues/${issue.iid}/notes/302',
        responseBody: data.note302,
      );

      final note = await issueNotes.get(302);

      call.verifyCalled(1);
      expect(note.id, 302);
    });
    test('.list()', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/issues/${issue.iid}/notes?',
        responseBody: data.issueNotes,
      );

      final notes = await issueNotes.list();

      call.verifyCalled(1);
      expect(notes, hasLength(2));
      expect(notes.first.id, 302);
    });
    test('.create()', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/issues/${issue.iid}/notes?body=Hello',
        method: HttpMethod.post,
        responseBody: data.newNote,
      );

      final note = await issueNotes.create("Hello");

      call.verifyCalled(1);
      expect(note.body, "Hello");
    });
    test('.update()', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/issues/${issue.iid}/notes/42?body=World',
        method: HttpMethod.put,
        responseBody: data.modifiedNote,
      );

      final note = await issueNotes.update(42, "World");

      call.verifyCalled(1);
      expect(note.body, "World");
    });
    test('.delete()', () async {
      final call = mockHttpClient.configureCall(
          path: '/projects/$projectId/issues/${issue.iid}/notes/42',
          method: HttpMethod.delete,
          responseStatusCode: 204);

      await issueNotes.delete(42);

      call.verifyCalled(1);
    });
  });
}
