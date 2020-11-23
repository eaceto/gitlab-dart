import 'package:gitlab/gitlab.dart';
import 'package:test/test.dart';
import 'src/mocks.dart';

void main() {
  group('ProjectsApi', () {
    MockGitLabHttpClient mockHttpClient;
    GitLab gitLab;
    ProjectsApi project;

    final projectId = 123;

    setUp(() {
      gitLab = getTestable(mockHttpClient);
      project = gitLab.project(projectId);
    });

    group('.buildUri()', () {
      test('adds project information', () {
        final uri = project.buildUri(['foo']);
        expect(uri.toString(),
            'https://gitlab.com/api/v4/projects/$projectId/foo');
      });
      test('forwards page and perPage', () {
        final uri = project.buildUri(['foo'], page: 5, perPage: 50);
        expect(uri.toString(),
            'https://gitlab.com/api/v4/projects/$projectId/foo?page=5&per_page=50');
      });
      test('forwards queryParameters', () {
        final uri = project.buildUri(['foo'],
            queryParameters: {'foo': 'bar'}, page: 5, perPage: 50);
        expect(uri.toString(),
            'https://gitlab.com/api/v4/projects/$projectId/foo?foo=bar&page=5&per_page=50');
      });
    });
  });
}
