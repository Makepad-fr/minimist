/// Function returns the value related to the given input in given map's keys or values
///
/// @param map The value map that we want to search
/// @param input The input value that we are searching in the map
/// @returns The found value in key/value pairs of the input.
String? findInputInMap(Map<String, String> map, String input) {
  if (map[input] != null) {
    return map[input];
  }
  var idx = map.values.toList().indexOf(input);

  if (idx == -1) {
    return null;
  }
  return map.keys.toList()[idx];
}

/// Function search with a regexp in a list
///
/// @param regexp The RexExp to search
/// @param list The List that we are searching int
/// @returns returns The index of the element which mathced with the given regular expression.
int searchWithRegexp(RegExp regexp, List<String> list) {
  for (var i = 0; i < list.length; i++) {
    if (regexp.hasMatch(list[i])) {
      return i;
    }
  }
  return -1;
}
