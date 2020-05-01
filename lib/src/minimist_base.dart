import 'models/minimist_options.dart';

/// Checks if you are awesome. Spoiler: you are.
class Minimist {
  final List<String> arguments;
  final MinimistOptions options;

  Minimist(this.arguments, {this.options}) {
    ArgumentError.checkNotNull(arguments, 'arguments');
  }

  /// Function parse arguments without any schema only using generic regular expressions
  ///
  /// @returns A Map<String, dynamic> contains parsed arguments.
  Map<String, dynamic> anonymousParse() {
    var parsedArguments = <String, dynamic>{};
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
              RegExp(r'([a-zA-Z])').allMatches(matched.group(2)).map((match) {
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

  /// Function parse arguments following the schema
  /// @returns A Map<String, dynamic> object with the parsed arguments
  Map<String, dynamic> get args {
    if (options == null) {
      // If there's no schema found
      return anonymousParse();
    } else {
      // If the parse schema is defined
      return null;
    }
  }
}
