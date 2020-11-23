// example data from https://docs.gitlab.com/ee/api/notes.html

const note302 = '''
{
  "id": 302,
  "body": "closed",
  "attachment": null,
  "author": {
    "id": 1,
    "username": "pipin",
    "email": "admin@example.com",
    "name": "Pip",
    "state": "active",
    "created_at": "2013-09-30T13:46:01Z"
  },
  "created_at": "2013-10-02T09:22:45Z",
  "updated_at": "2013-10-02T10:22:45Z",
  "system": true,
  "noteable_id": 377,
  "noteable_type": "Issue",
  "noteable_iid": 377,
  "resolvable": false
}
''';

const note305 = '''
{
  "id": 305,
  "body": "Text of the comment\\r\\n",
  "attachment": null,
  "author": {
    "id": 1,
    "username": "pipin",
    "email": "admin@example.com",
    "name": "Pip",
    "state": "active",
    "created_at": "2013-09-30T13:46:01Z"
  },
  "created_at": "2013-10-02T09:56:03Z",
  "updated_at": "2013-10-02T09:56:03Z",
  "system": true,
  "noteable_id": 121,
  "noteable_type": "Issue",
  "noteable_iid": 121,
  "resolvable": false
}
''';

const issueNotes = '''
[
  $note302,
  $note305
]
''';

const newNote = '''
{
  "id": 42,
  "body": "Hello",
  "attachment": null,
  "author": {
    "id": 1,
    "username": "pipin",
    "email": "admin@example.com",
    "name": "Pip",
    "state": "active",
    "created_at": "2013-09-30T13:46:01Z"
  },
  "created_at": "2013-10-02T09:56:03Z",
  "updated_at": "2013-10-02T09:56:03Z",
  "system": true,
  "noteable_id": 121,
  "noteable_type": "Issue",
  "noteable_iid": 121,
  "resolvable": false
}
''';

const modifiedNote = '''
{
  "id": 42,
  "body": "World",
  "attachment": null,
  "author": {
    "id": 1,
    "username": "pipin",
    "email": "admin@example.com",
    "name": "Pip",
    "state": "active",
    "created_at": "2013-09-30T13:46:01Z"
  },
  "created_at": "2013-10-02T09:56:03Z",
  "updated_at": "2013-10-02T09:56:03Z",
  "system": true,
  "noteable_id": 121,
  "noteable_type": "Issue",
  "noteable_iid": 121,
  "resolvable": false
}
''';
