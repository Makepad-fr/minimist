import 'package:minimist/src/utils/parser_helpers.dart';

import 'models/minimist_options.dart';

/// Checks if you are awesome. Spoiler: you are.
class Minimist {
  final List<String> arguments;
  final MinimistOptions? options;

  Minimist(this.arguments, {this.options}) {
    ArgumentError.checkNotNull(arguments, 'arguments');
  }

  /// Function parse arguments without any schema only using generic regular expressions
  ///
  /// @returns A Map<String, dynamic> contains parsed arguments.
  Map<String?, dynamic> _anonymousParse() {
    var parsedArguments = <String?, dynamic>{};
    parsedArguments['_'] = [];
    final argumentPattern = RegExp(r'^(\-{1,2})([a-zA-Z]+)((=(.+))|(\d+))?$');
    // final RegExp longArgumentPattern = RegExp(r"^\-\-([a-zA-Z]+)((=(.+))|(\d+))?$");

    var parsedArgumentsList = arguments.map<dynamic>((argument) {
      var _parsedArgumentsList = argumentPattern.allMatches(argument).toList();
      if (_parsedArgumentsList.isNotEmpty) {
        return _parsedArgumentsList[0];
      }
      return argument;
    }).toList();

    for (var i = 0; i < parsedArgumentsList.length; i++) {
      if (parsedArgumentsList[i].runtimeType.toString() == '_RegExpMatch') {
        var matched = parsedArgumentsList[i] as RegExpMatch;
        if (matched.group(1) == '--') {
          // Long version of arguments begins with --
          var argName = matched.group(2);
          if (matched.group(5) != null) {
            parsedArguments[argName] = matched.group(5);
          } else {
            if (matched.group(3) != null) {
              parsedArguments[argName] = matched.group(3);
            } else {
              if (i < parsedArgumentsList.length - 1) {
                if (parsedArgumentsList[i + 1].runtimeType.toString() !=
                    '_RegExpMatch') {
                  // If next element is the value
                  parsedArguments[argName] = parsedArgumentsList[i + 1];
                  i++;
                } else {
                  // If next element is an other parameter
                  parsedArguments[argName] = true;
                }
              } else {
                parsedArguments[argName] = true;
              }
            }
          }
        } else {
          // Short version of arguments begins with -
          var parsedParameters =
              RegExp(r'([a-zA-Z])').allMatches(matched.group(2)!).map((match) {
            return match.group(1);
          }).toList();
          var allExceptLastParams =
              parsedParameters.sublist(0, parsedParameters.length - 1);
          for (var p in allExceptLastParams) {
            parsedArguments[p] = true;
          }

          var argName = parsedParameters.last;
          if (matched.group(5) != null) {
            parsedArguments[argName] = matched.group(5);
          } else {
            if (matched.group(3) != null) {
              parsedArguments[argName] = matched.group(3);
            } else {
              if (i < parsedArgumentsList.length - 1) {
                if (parsedArgumentsList[i + 1].runtimeType.toString() !=
                    '_RegExpMatch') {
                  // If next element is the value
                  parsedArguments[argName] = parsedArgumentsList[i + 1];
                  i++;
                } else {
                  // If next element is an other parameter
                  parsedArguments[argName] = true;
                }
              } else {
                parsedArguments[argName] = true;
              }
            }
          }
        }
      } else {
        parsedArguments['_'].add(parsedArgumentsList[i]);
      }
    }
    return parsedArguments;
  }

  /// Function handles the parsing operation with given options
  ///
  /// @param param1 Parameter description
  /// @param param2 Parameter description
  /// @returns Returns a Map object that contains parsed arguments and options.
  /// @throws FormatException if there's a missing value for a String typed option
  Map<String?, dynamic> _parseWithOptions() {
    var result = <String?, dynamic>{};
    result['_'] = [];
    var _index = arguments.toList().indexOf('--');
    var localArguments = arguments;
    if (_index != -1) {
      localArguments = arguments.sublist(0, _index);
      result['_'] = arguments.sublist(_index + 1);
    }

    var stringRegExpOptions = options!.string!.map((strOpt) {
      var alias = findInputInMap(options!.alias!, strOpt);
      if (alias != null) {
        strOpt += '|$alias';
      }
      return RegExp(r'^(\-){1,2}(' + strOpt + ')((=(.+))|(\d+))?\$');
    }).toList();

    var booleanRegExpOptions = options!.boolean!.map((boolOpt) {
      var alias = findInputInMap(options!.alias!, boolOpt);
      if (alias != null) {
        boolOpt += '|$alias';
      }
      return RegExp(
          r'^(((\-){1,2}(' + boolOpt + '))|(\-\-(no)\-(' + boolOpt + ')))\$');
    }).toList();

    for (var i = 0; i < stringRegExpOptions.length; i++) {
      var regexp = stringRegExpOptions[i];
      var _alias = findInputInMap(options!.alias!, options!.string![i]);
      var idx = searchWithRegexp(regexp, localArguments);
      if (idx != -1) {
        var matched = regexp.firstMatch(localArguments[idx])!;
        if (matched.group(5) != null) {
          result[options!.string![i]] = matched.group(5);
          if (_alias != null) {
            result[_alias] = matched.group(5);
          }
        } else {
          if (matched.group(3) != null) {
            result[options!.string![i]] = matched.group(3);
            if (_alias != null) {
              result[_alias] = matched.group(3);
            }
          } else {
            if (((localArguments.length - 1) > idx) &&
                (RegExp(r'^[a-zA-Z0-9]+$').hasMatch(localArguments[idx + 1]))) {
              result[options!.string![i]] = localArguments[idx + 1];
              if (_alias != null) {
                result[_alias] = localArguments[idx + 1];
              }
            } else {
              throw FormatException('${options!.string![i]} needs a value');
            }
          }
        }
      }
    }

    for (var i = 0; i < booleanRegExpOptions.length; i++) {
      var regexp = booleanRegExpOptions[i];
      var _alias = findInputInMap(options!.alias!, options!.boolean![i]);
      var idx = searchWithRegexp(regexp, localArguments);
      if (idx != -1) {
        var matched = regexp.firstMatch(localArguments[idx])!;
        if (matched.group(matched.groupCount - 1) != null) {
          result[options!.boolean![i]] = false;
          if (_alias != null) {
            result[_alias] = false;
          }
        } else {
          result[options!.boolean![i]] = true;
          if (_alias != null) {
            result[_alias] = true;
          }
        }
      } else {
        result[options!.boolean![i]] = false;
        if (_alias != null) {
          result[_alias] = false;
        }
      }
    }

    var unknowns = <String, String?>{};
    for (var key in options!.alias!.keys) {
      var value = options!.alias![key];
      var allKnownElements = [...options!.string!, ...options!.boolean!];
      if ((allKnownElements.contains(value) == false) &&
          (allKnownElements.contains(key) == false)) {
        unknowns[key] = value;
      }
    }

    for (var unknownKey in unknowns.keys) {
      var strPattern = unknownKey + '|' + unknowns[unknownKey]!;
      var unknownRegExp = RegExp(r'^(\-{1,2})(' + strPattern + ')\$');
      var idx = searchWithRegexp(unknownRegExp, localArguments);
      result[unknownKey] = false;
      result[unknowns[unknownKey]] = false;
      if (idx != -1) {
        result[unknownKey] = true;
        result[unknowns[unknownKey]] = true;
      }
    }

    for (var key in options!.byDefault!.keys) {
      if (result[key] == null) {
        result[key] = options!.byDefault![key];
        var _alias = findInputInMap(options!.alias!, key);
        if (_alias != null) {
          result[_alias] = options!.byDefault![key];
        }
      }
    }

    var allFound = [...result.keys, ...result.values];
    for (var localArg in localArguments) {
      if (RegExp(r'^\-{1,2}').hasMatch(localArg) == false) {
        if (allFound.contains(localArg) == false) {
          result['_'].add(localArg);
        }
      }
    }
    // options.
    return result;
  }

  /// Function parse arguments following the schema
  /// @returns A Map<String, dynamic> object with the parsed arguments
  Map<String?, dynamic> get args {
    if (options == null) {
      // If there's no schema found
      return _anonymousParse();
    } else {
      // If the parse schema is defined
      return _parseWithOptions();
    }
  }
}
