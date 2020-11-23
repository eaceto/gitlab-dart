part of exitlive.gitlab;

enum MilestoneState { active, closed }

class Milestone {
  Milestone.fromJson(Map<String, dynamic> milestone)
      : id = milestone.getIntOrNull("id"),
        iid = milestone.getIntOrNull("iid"),
        projectId = milestone.getIntOrNull("project_id"),
        title = milestone.getStringOrNull("title"),
        description = milestone.getStringOrNull("description"),
        state = enumFromString(
            MilestoneState.values, milestone.getStringOrNull("state")),
        createdAt = milestone.getISODateTimeOrNull("created_at"),
        updatedAt = milestone.getISODateTimeOrNull("updated_at"),
        dueDate = milestone.getISODateTimeOrNull("due_date"),
        startDate = milestone.getISODateTimeOrNull("start_date"),
        webUrl = milestone.getStringOrNull("web_url");

  static List<Milestone> fromJsonList(List milestones) => milestones
      ?.map((m) => m is Map<String, dynamic> ? Milestone.fromJson(m) : null)
      ?.where((milestone) => milestone != null)
      ?.toList();

  int id;
  int iid;
  int projectId;
  String title;
  String description;
  MilestoneState state;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime dueDate;
  DateTime startDate;
  String webUrl;
}
