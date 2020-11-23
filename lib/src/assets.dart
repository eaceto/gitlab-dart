part of exitlive.gitlab;

class Asset {
  Asset.fromJson(Map<String, dynamic> asset)
      : count = asset.getIntOrNull("count"),
        sources = Source.fromJsonList(asset["sources"] as List),
        links = Link.fromJsonList(asset["links"] as List),
        evidenceFilePath = asset.getStringOrNull("evidence_file_path");

  static List<Asset> fromJsonList(List assets) => assets
      ?.map((a) => a is Map<String, dynamic> ? Asset.fromJson(a) : null)
      ?.where((asset) => asset != null)
      ?.toList();

  int count;
  List<Source> sources;
  List<Link> links;
  String evidenceFilePath;
}

class Source {
  Source.fromJson(Map<String, dynamic> source)
      : format = source.getStringOrNull("format"),
        url = source.getStringOrNull("url");

  static List<Source> fromJsonList(List sources) => sources
      ?.map((s) => s is Map<String, dynamic> ? Source.fromJson(s) : null)
      ?.where((source) => source != null)
      ?.toList();

  String format;
  String url;
}

class Link {
  Link.fromJson(Map<String, dynamic> link)
      : id = link.getIntOrNull("id"),
        name = link.getStringOrNull("name"),
        url = link.getStringOrNull("url"),
        external = link.getBoolOrNull("external");

  static List<Link> fromJsonList(List links) => links
      ?.map((l) => l is Map<String, dynamic> ? Link.fromJson(l) : null)
      ?.where((link) => link != null)
      ?.toList();

  int id;
  String name;
  String url;
  bool external;
}
