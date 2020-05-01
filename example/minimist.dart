
import '../lib/minimist.dart';

void main(List<String> arguments) {
  var minimist = Minimist(arguments);
  print(minimist.args);
}
