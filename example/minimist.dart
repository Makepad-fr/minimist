import 'package:minimist/minimist.dart';

void main(List<String> arguments) {
  var minimist = Minimist(arguments);
  print(minimist.args);
}
