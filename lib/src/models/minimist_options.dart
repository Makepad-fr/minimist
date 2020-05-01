class MinimistOptions {
  List<String> string;
  List<String> boolean;
  Map<String, String> alias;
  Map<String, String> byDefault;

  MinimistOptions({this.string, this.boolean, this.alias, this.byDefault}) {
    string ??= [];
    boolean ??= [];
    alias ??= <String, String>{};
    byDefault ??= <String, String>{};
  }
}
