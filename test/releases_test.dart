import 'package:gitlab/gitlab.dart';
import 'package:test/test.dart';

import 'assets/json_data.dart' as data;
import 'src/mocks.dart';

void main() {
  group('ReleasesApi', () {
    MockGitLabHttpClient mockHttpClient;
    GitLab gitLab;
    ProjectsApi project;

    final projectId = 1337;
    final releasesJson = data.decodeList(data.releasesList);
    final releaseTag = releasesJson[1]["tag_name"] as String;

    setUp(() {
      mockHttpClient = MockGitLabHttpClient();
      gitLab = getTestable(mockHttpClient);
      project = gitLab.project(projectId);
    });

    List<Map<String, dynamic>> fromJsonList(jsonList) => jsonList is List
        ? jsonList
            .map((jl) => jl is Map<String, dynamic> ? jl : null)
            .where((jl) => jl != null)
            .toList()
        : null;

    test('Release class properly maps the JSON', () async {
      for (var item in releasesJson) {
        final releaseJson = item as Map<String, dynamic>;
        final authorJson = releaseJson["author"] as Map<String, dynamic>;
        final commitJson = releaseJson["commit"] as Map<String, dynamic>;
        final milestonesJson = fromJsonList(releaseJson["milestones"]);
        final assetsJson = releaseJson["assets"] as Map<String, dynamic>;

        final Release release = Release.fromJson(releaseJson);

        expect(release.tagName, releaseJson['tag_name']);
        expect(release.description, releaseJson['description']);
        expect(release.descriptionHtml, releaseJson['description_html']);
        expect(release.name, releaseJson['name']);

        final User author = release.author;
        expect(author.id, authorJson['id']);
        expect(author.name, authorJson['name']);
        expect(author.state, authorJson['state']);
        expect(author.avatarUrl, authorJson['avatar_url']);
        expect(author.webUrl, authorJson['web_url']);

        expect(release.createdAt,
            DateTime.parse(releaseJson['created_at'].toString()));
        expect(release.releasedAt,
            DateTime.parse(releaseJson['released_at'].toString()));
        expect(release.commitPath, releaseJson['commit_path']);
        expect(release.tagPath, releaseJson['tag_path']);
        expect(release.evidenceSha, releaseJson['evidence_sha']);

        final Commit commit = release.commit;
        expect(commit.id, commitJson['id']);
        expect(commit.shortId, commitJson['short_id']);
        expect(commit.title, commitJson['title']);
        expect(commit.message, commitJson['message']);
        expect(commit.status, commitJson['status']);
        expect(commit.createdAt,
            DateTime.parse(commitJson['created_at'].toString()));
        expect(commit.committedDate,
            DateTime.parse(commitJson['committed_date'].toString()));

        expect(release.milestones?.length, milestonesJson?.length);
        if (release.milestones != null) {
          for (var i = 0; i < release.milestones.length; i++) {
            final Milestone milestone = release.milestones[i];
            final milestoneJson = milestonesJson[i];

            expect(milestone.id, milestoneJson['id']);
            expect(milestone.iid, milestoneJson['iid']);
            expect(milestone.projectId, milestoneJson['project_id']);
            expect(milestone.title, milestoneJson['title']);
            expect(milestone.description, milestoneJson['description']);
            expect(
                milestone.state,
                enumFromString(
                    MilestoneState.values, milestoneJson['state'] as String));
            expect(milestone.createdAt,
                DateTime.parse(milestoneJson['created_at'].toString()));
            expect(milestone.updatedAt,
                DateTime.parse(milestoneJson['updated_at'].toString()));
            expect(milestone.dueDate,
                DateTime.parse(milestoneJson['due_date'].toString()));
            expect(milestone.startDate,
                DateTime.parse(milestoneJson['start_date'].toString()));
            expect(milestone.webUrl, milestoneJson['web_url']);
          }
        }

        final Asset asset = release.assets;
        final sourcesJson = fromJsonList(assetsJson["sources"]);
        final linksJson = fromJsonList(assetsJson["links"]);

        expect(asset.count, assetsJson['count']);

        expect(asset.sources.length, sourcesJson.length ?? 0);
        for (var i = 0; i < asset.sources.length; i++) {
          final Source source = asset.sources[i];
          final sourceJson = sourcesJson[i];

          expect(source.format, sourceJson['format']);
          expect(source.url, sourceJson['url']);
        }

        expect(asset.links.length, linksJson.length);
        for (var i = 0; i < asset.links.length; i++) {
          final Link link = asset.links[i];
          final linkJson = linksJson[i];

          expect(link.id, linkJson['id']);
          expect(link.name, linkJson['name']);
          expect(link.url, linkJson['url']);
          expect(link.external, linkJson['external']);
        }

        expect(asset.evidenceFilePath, assetsJson['evidence_file_path']);
      }
    });

    test('.get()', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/releases/$releaseTag',
        responseBody: data.singleRelease,
      );

      final release = await project.releases.get(releaseTag);

      call.verifyCalled(1);
      expect(release.tagName, releaseTag);
    });

    test('.list()', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/releases?',
        responseBody: data.releasesList,
      );

      final releases = await project.releases.list();

      call.verifyCalled(1);
      expect(releases, hasLength(2));
      expect(releases[0].tagName, "v0.2");
      expect(releases[1].tagName, "v0.1");
    });

    test('.createFromTag(v0.3)', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/releases?description=Foo&tag_name=v0.3',
        method: HttpMethod.post,
        responseBody: data.newRelease,
      );

      final release = await project.releases.createFromTag("v0.3", "Foo");

      call.verifyCalled(1);
      expect(release.tagName, "v0.3");
      expect(release.description, "Foo");
    });

    test('.createFromRef(9beb86fd4bd)', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/releases?description=Foo&ref=9beb86fd4bd',
        method: HttpMethod.post,
        responseBody: data.newRelease,
      );

      final release =
          await project.releases.createFromRef("9beb86fd4bd", "Foo");

      call.verifyCalled(1);
      expect(release.tagName, "v0.3");
      expect(release.description, "Foo");
    });

    test('.update(v0.3)', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/releases?tag_name=v0.3&description=Foobar',
        method: HttpMethod.put,
        responseBody: data.editedRelease,
      );

      final release =
          await project.releases.update("v0.3", description: "Foobar");

      call.verifyCalled(1);
      expect(release.tagName, "v0.3");
      expect(release.description, "Foobar");
    });

    test('.delete(v0.3)', () async {
      final call = mockHttpClient.configureCall(
          path: '/projects/$projectId/releases/v0.3',
          method: HttpMethod.delete,
          responseStatusCode: 204);

      await project.releases.delete("v0.3");

      call.verifyCalled(1);
    });
  });
}
