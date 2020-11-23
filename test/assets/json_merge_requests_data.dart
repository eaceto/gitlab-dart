// example data from https://docs.gitlab.com/ee/api/merge_requests.html
const mergeRequest = '''
{
  "id": 1,
  "iid": 1,
  "target_branch": "master",
  "source_branch": "test1",
  "project_id": 3,
  "title": "test1",
  "state": "merged",
  "upvotes": 0,
  "downvotes": 0,
  "author": {
    "id": 1,
    "username": "admin",
    "email": "admin@example.com",
    "name": "Administrator",
    "state": "active",
    "created_at": "2012-04-29T08:46:00Z"
  },
  "assignee": {
    "id": 1,
    "username": "admin",
    "email": "admin@example.com",
    "name": "Administrator",
    "state": "active",
    "created_at": "2012-04-29T08:46:00Z"
  },
  "assignees": [{
    "name": "Miss Monserrate Beier",
    "username": "axel.block",
    "id": 12,
    "state": "active",
    "avatar_url": "http://www.gravatar.com/avatar/46f6f7dc858ada7be1853f7fb96e81da?s=80&d=identicon",
    "web_url": "https://gitlab.example.com/axel.block"
  }],
  "source_project_id": 2,
  "target_project_id": 3,
  "labels": ["No Promotion"],
  "description": "fixed login page css paddings",
  "work_in_progress": false,
  "milestone": {
    "id": 5,
    "iid": 1,
    "project_id": 3,
    "title": "v2.0",
    "description": "Assumenda aut placeat expedita exercitationem labore sunt enim earum.",
    "state": "closed",
    "created_at": "2015-02-02T19:49:26.013Z",
    "updated_at": "2015-02-02T19:49:26.013Z",
    "due_date": null
  },
  "merge_when_pipeline_succeeds": true,
  "merge_status": "can_be_merged",
  "subscribed" : true,
  "sha": "8888888888888888888888888888888888888888",
  "merge_commit_sha": "9999999999999999999999999999999999999999",
  "user_notes_count": 1,
  "approvals_before_merge": null,
  "should_remove_source_branch": true,
  "force_remove_source_branch": false,
  "squash": false,
  "web_url": "http://example.com/example/example/merge_requests/1"
}
''';

const mergeRequests = '''
[
  {
    "id": 1,
    "iid": 1,
    "target_branch": "master",
    "source_branch": "test1",
    "project_id": 3,
    "title": "test1",
    "state": "opened",
    "created_at": "2017-04-29T08:46:00Z",
    "updated_at": "2017-04-29T08:46:00Z",
    "upvotes": 0,
    "downvotes": 0,
    "author": {
      "id": 1,
      "username": "admin",
      "name": "Administrator",
      "state": "active",
      "avatar_url": null,
      "web_url" : "https://gitlab.example.com/admin"
    },
    "assignee": {
      "id": 1,
      "username": "admin",
      "name": "Administrator",
      "state": "active",
      "avatar_url": null,
      "web_url" : "https://gitlab.example.com/admin"
    },
    "source_project_id": 2,
    "target_project_id": 3,
    "labels": [ ],
    "description": "fixed login page css paddings",
    "work_in_progress": false,
    "milestone": {
      "id": 5,
      "iid": 1,
      "project_id": 3,
      "title": "v2.0",
      "description": "Assumenda aut placeat expedita exercitationem labore sunt enim earum.",
      "state": "closed",
      "created_at": "2015-02-02T19:49:26.013Z",
      "updated_at": "2015-02-02T19:49:26.013Z",
      "due_date": null
    },
    "merge_when_pipeline_succeeds": true,
    "merge_status": "can_be_merged",
    "sha": "8888888888888888888888888888888888888888",
    "merge_commit_sha": null,
    "user_notes_count": 1,
    "should_remove_source_branch": true,
    "force_remove_source_branch": false,
    "squash": false,
    "web_url": "http://example.com/example/example/merge_requests/1",
    "time_stats": {
      "time_estimate": 0,
      "total_time_spent": 0,
      "human_time_estimate": null,
      "human_total_time_spent": null
    }
  }
]
''';

const newMergeRequest = """
{
  "id": 1,
  "iid": 1,
  "project_id": 3,
  "title": "Hello",
  "description": "fixed login page css paddings",
  "state": "merged",
  "created_at": "2017-04-29T08:46:00Z",
  "updated_at": "2017-04-29T08:46:00Z",
  "target_branch": "master",
  "source_branch": "test1",
  "upvotes": 0,
  "downvotes": 0,
  "author": {
    "id": 1,
    "name": "Administrator",
    "username": "admin",
    "state": "active",
    "avatar_url": null,
    "web_url" : "https://gitlab.example.com/admin"
  },
  "assignee": {
    "id": 1,
    "name": "Administrator",
    "username": "admin",
    "state": "active",
    "avatar_url": null,
    "web_url" : "https://gitlab.example.com/admin"
  },
  "source_project_id": 2,
  "target_project_id": 3,
  "labels": [
    "Community contribution",
    "Manage"
  ],
  "work_in_progress": false,
  "milestone": {
    "id": 5,
    "iid": 1,
    "project_id": 3,
    "title": "v2.0",
    "description": "Assumenda aut placeat expedita exercitationem labore sunt enim earum.",
    "state": "closed",
    "created_at": "2015-02-02T19:49:26.013Z",
    "updated_at": "2015-02-02T19:49:26.013Z",
    "due_date": "2018-09-22",
    "start_date": "2018-08-08",
    "web_url": "https://gitlab.example.com/my-group/my-project/milestones/1"
  },
  "merge_when_pipeline_succeeds": true,
  "merge_status": "can_be_merged",
  "merge_error": null,
  "sha": "8888888888888888888888888888888888888888",
  "merge_commit_sha": null,
  "squash_commit_sha": null,
  "user_notes_count": 1,
  "discussion_locked": null,
  "should_remove_source_branch": true,
  "force_remove_source_branch": false,
  "allow_collaboration": false,
  "allow_maintainer_to_push": false,
  "web_url": "http://gitlab.example.com/my-group/my-project/merge_requests/1",
  "references": {
    "short": "!1",
    "relative": "!1",
    "full": "my-group/my-project!1"
  },
  "time_stats": {
    "time_estimate": 0,
    "total_time_spent": 0,
    "human_time_estimate": null,
    "human_total_time_spent": null
  },
  "squash": false,
  "subscribed": false,
  "changes_count": "1",
  "merged_by": {
    "id": 87854,
    "name": "Douwe Maan",
    "username": "DouweM",
    "state": "active",
    "avatar_url": "https://gitlab.example.com/uploads/-/system/user/avatar/87854/avatar.png",
    "web_url": "https://gitlab.com/DouweM"
  },
  "merged_at": "2018-09-07T11:16:17.520Z",
  "closed_by": null,
  "closed_at": null,
  "latest_build_started_at": "2018-09-07T07:27:38.472Z",
  "latest_build_finished_at": "2018-09-07T08:07:06.012Z",
  "first_deployed_to_production_at": null,
  "pipeline": {
    "id": 29626725,
    "sha": "2be7ddb704c7b6b83732fdd5b9f09d5a397b5f8f",
    "ref": "patch-28",
    "status": "success",
    "web_url": "https://gitlab.example.com/my-group/my-project/pipelines/29626725"
  },
  "diff_refs": {
    "base_sha": "c380d3acebd181f13629a25d2e2acca46ffe1e00",
    "head_sha": "2be7ddb704c7b6b83732fdd5b9f09d5a397b5f8f",
    "start_sha": "c380d3acebd181f13629a25d2e2acca46ffe1e00"
  },
  "diverged_commits_count": 2,
  "task_completion_status":{
    "count":0,
    "completed_count":0
  }
}
""";

const modifiedMergeRequest = """
{
  "id": 1,
  "iid": 1,
  "project_id": 3,
  "title": "World",
  "description": "fixed login page css paddings",
  "state": "merged",
  "created_at": "2017-04-29T08:46:00Z",
  "updated_at": "2017-04-29T08:46:00Z",
  "target_branch": "master",
  "source_branch": "test1",
  "upvotes": 0,
  "downvotes": 0,
  "author": {
    "id": 1,
    "name": "Administrator",
    "username": "admin",
    "state": "active",
    "avatar_url": null,
    "web_url" : "https://gitlab.example.com/admin"
  },
  "assignee": {
    "id": 1,
    "name": "Administrator",
    "username": "admin",
    "state": "active",
    "avatar_url": null,
    "web_url" : "https://gitlab.example.com/admin"
  },
  "source_project_id": 2,
  "target_project_id": 3,
  "labels": [
    "Community contribution",
    "Manage"
  ],
  "work_in_progress": false,
  "milestone": {
    "id": 5,
    "iid": 1,
    "project_id": 3,
    "title": "v2.0",
    "description": "Assumenda aut placeat expedita exercitationem labore sunt enim earum.",
    "state": "closed",
    "created_at": "2015-02-02T19:49:26.013Z",
    "updated_at": "2015-02-02T19:49:26.013Z",
    "due_date": "2018-09-22",
    "start_date": "2018-08-08",
    "web_url": "https://gitlab.example.com/my-group/my-project/milestones/1"
  },
  "merge_when_pipeline_succeeds": true,
  "merge_status": "can_be_merged",
  "merge_error": null,
  "sha": "8888888888888888888888888888888888888888",
  "merge_commit_sha": null,
  "squash_commit_sha": null,
  "user_notes_count": 1,
  "discussion_locked": null,
  "should_remove_source_branch": true,
  "force_remove_source_branch": false,
  "allow_collaboration": false,
  "allow_maintainer_to_push": false,
  "web_url": "http://gitlab.example.com/my-group/my-project/merge_requests/1",
  "references": {
    "short": "!1",
    "relative": "!1",
    "full": "my-group/my-project!1"
  },
  "time_stats": {
    "time_estimate": 0,
    "total_time_spent": 0,
    "human_time_estimate": null,
    "human_total_time_spent": null
  },
  "squash": false,
  "subscribed": false,
  "changes_count": "1",
  "merged_by": {
    "id": 87854,
    "name": "Douwe Maan",
    "username": "DouweM",
    "state": "active",
    "avatar_url": "https://gitlab.example.com/uploads/-/system/user/avatar/87854/avatar.png",
    "web_url": "https://gitlab.com/DouweM"
  },
  "merged_at": "2018-09-07T11:16:17.520Z",
  "closed_by": null,
  "closed_at": null,
  "latest_build_started_at": "2018-09-07T07:27:38.472Z",
  "latest_build_finished_at": "2018-09-07T08:07:06.012Z",
  "first_deployed_to_production_at": null,
  "pipeline": {
    "id": 29626725,
    "sha": "2be7ddb704c7b6b83732fdd5b9f09d5a397b5f8f",
    "ref": "patch-28",
    "status": "success",
    "web_url": "https://gitlab.example.com/my-group/my-project/pipelines/29626725"
  },
  "diff_refs": {
    "base_sha": "c380d3acebd181f13629a25d2e2acca46ffe1e00",
    "head_sha": "2be7ddb704c7b6b83732fdd5b9f09d5a397b5f8f",
    "start_sha": "c380d3acebd181f13629a25d2e2acca46ffe1e00"
  },
  "diverged_commits_count": 2,
  "task_completion_status":{
    "count":0,
    "completed_count":0
  }
}
""";
