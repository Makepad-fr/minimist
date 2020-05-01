import 'package:minimist/minimist.dart';

void main (List<String> arguments) {
    var minimist = Minimist(
      arguments,
      options: MinimistOptions(
        string: ['lang', 'username', 'password'],
        boolean: ['pager'],
        alias: <String, String>{
          'h': 'help',
          'v': 'version',
          'u': 'username',
          'password': 'p',
          'g': 'pager'
        },
        byDefault: {
          'lang': 'en'
        },
      )
    );
    print('Parsed arguments are');
    print(minimist.args);
}