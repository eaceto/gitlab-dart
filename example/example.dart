import 'package:gitlab/gitlab.dart';

const gitLabToken = 'my-secret-token';
const projectId = 123;

void main() async {
  final project = GitLab(gitLabToken).project(projectId);

  // List all commits that have been done in the last 24h
  final commits = await project.commits
      .list(since: new DateTime.now().subtract(new Duration(days: 1)));

  print(commits.first.message);

  /// The internal id of the merge request.
  final iid = 2;
  final mergeRequest = await project.mergeRequests.get(iid);

  print(mergeRequest.title);
}
