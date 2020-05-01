class MinimistOptions {
  final List<String> string;
  final List<String> boolean;
  final List<String> number;
  final Map<String, String> alias;
  final Map<String, String> byDefault;
  final bool stopEarly;

  const MinimistOptions({
    this.string,
    this.boolean,
    this.number,
    this.alias,
    this.byDefault,
    this.stopEarly
  });
}