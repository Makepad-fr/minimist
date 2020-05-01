class MinimistOptions {
  final List<String> string;
  final List<String> boolean;
  final Map<String, String> alias;
  final Map<String, String> byDefault;

  const MinimistOptions(
      {this.string, this.boolean, this.alias, this.byDefault});
}
