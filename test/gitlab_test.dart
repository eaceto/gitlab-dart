import 'package:gitlab/gitlab.dart';
import 'package:test/test.dart';
import 'src/mocks.dart';

void main() {
  group('GitLab', () {
    MockGitLabHttpClient mockHttpClient;
    GitLab gitLab;

    setUp(() {
      gitLab = getTestable(mockHttpClient);
    });

    test('enumToString', () {
      final value = MergeRequestOrderBy.updatedAt;

      expect("updated_at", enumToString(value));
    });

    test('.project() returns a new configured project', () {
      final project = gitLab.project(123);
      expect(project, TypeMatcher<ProjectsApi>());
      expect(project.id, 123);
    });
    group('.buildUri()', () {
      test('adds pagination info when necessary', () {
        Uri uri;

        uri = gitLab.buildUri(['foo']);
        expect(uri.toString(), 'https://gitlab.com/api/v4/foo');

        uri = gitLab.buildUri(['foo'], page: 3);
        expect(uri.toString(), 'https://gitlab.com/api/v4/foo?page=3');

        uri = gitLab.buildUri(['foo'], perPage: 10);
        expect(uri.toString(), 'https://gitlab.com/api/v4/foo?per_page=10');

        uri = gitLab.buildUri(['foo'], page: 3, perPage: 10);
        expect(
            uri.toString(), 'https://gitlab.com/api/v4/foo?page=3&per_page=10');
      });
      test('adds queryParameters', () {
        Uri uri;

        uri = gitLab
            .buildUri(['foo'], queryParameters: {'foobar': 'test'}, page: 6);
        expect(
            uri.toString(), 'https://gitlab.com/api/v4/foo?foobar=test&page=6');

        uri = gitLab.buildUri([
          'foo'
        ], queryParameters: {
          'foo': 'test',
          'bar[]': ['a', 'b', 'c']
        });
        expect(
            uri.toString(),
            'https://gitlab.com/api/v4/foo'
            '?foo=test&bar%5B%5D=a&bar%5B%5D=b&bar%5B%5D=c');
      });
      test('handles the path properly', () {
        Uri uri;

        uri = gitLab.buildUri(['foo', '123', 'bar', '321']);
        expect(uri.toString(), 'https://gitlab.com/api/v4/foo/123/bar/321');
      });
      test('uses the right scheme and host', () {
        Uri uri;
        final gitLab =
            new GitLab('token', host: 'gitlab.my-host.com', scheme: 'http');

        uri = gitLab.buildUri(['foo']);
        expect(uri.toString(), 'http://gitlab.my-host.com/api/v4/foo');
      });
    });
    test('.project() returns a configured instance of the ProjectsApi', () {
      final project = gitLab.project(123);
      expect(project.id, 123);
    });
  });
}
