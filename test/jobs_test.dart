import 'package:gitlab/gitlab.dart';
import 'package:test/test.dart';

import 'assets/json_data.dart' as data;
import 'src/mocks.dart';

void main() {
  group('JobsApi', () {
    MockGitLabHttpClient mockHttpClient;
    GitLab gitLab;
    ProjectsApi project;

    // Constants
    final projectId = 1337;

    final jobMap = data.decodeMap(data.job);
    final jobId = jobMap['id'] as int;

    setUp(() {
      mockHttpClient = MockGitLabHttpClient();
      gitLab = getTestable(mockHttpClient);
      project = gitLab.project(projectId);
    });

    test('Job class properly maps the JSON', () async {
      final job = new Job.fromJson(jobMap);

      // Since the plan is to migrate to json_serializable the testing
      // for the mapping here is very limited.
      expect(job.id, jobMap['id']);
    });

    test('.get()', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/jobs/$jobId',
        responseBody: data.job,
      );

      final job = await project.jobs.get(jobId);

      call.verifyCalled(1);
      expect(job.id, jobId);
    });
    test('.list()', () async {
      final call = mockHttpClient.configureCall(
        path: '/projects/$projectId/jobs?',
        responseBody: data.jobs,
      );

      final jobs = await project.jobs.list();

      call.verifyCalled(1);
      expect(jobs, hasLength(2));
    });
  });
}
