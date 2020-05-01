# minimist

[![Clique-Paris](https://circleci.com/gh/Clique-Paris/minimist.svg?style=svg)](https://app.circleci.com/pipelines/github/Clique-Paris/minimist)

A Dart module for parsing command line parameters and options, inspired from the [minimist](https://www.npmjs.com/package/minimist) npm module.

## Usage

A simple usage example:

```dart
import 'package:minimist/minimist.dart';

main(List<String> arguments) {
  var args = Minimist(arguments).args;
  print(args);
}
```

```shell
$ dart example/minimist.dart -f foo -b bar
{_: [], f: foo, b: bar}

$ dart example/minimist.dart -x 0 -y 1 -n2 -abc --hello=world foo bar baz -def42
{_: [foo, bar, baz], x: 0, y: 1, n: 2, a: true, b: true, c: true, hello: world, d: true, e: true, f: 42}
```

A more complex usage by using parsing options (aka `MinimistOptions`):

```dart
import 'package:minimist/minimist.dart';

main (List<String> arguments) {
  var args = Minimist(arguments,
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
          byDefault: {'lang': 'en'},
        )).args;
  print(args);
}
```

```shell
$ dart example/minimist_with_options.dart --lang xml --pager -u=root -h hello -- index.js package.json

{_: [index.js, package.json, hello], lang: xml, username: root, u: root, pager: true, g: true, h: true, help: true, v: false, version: false}
```

```shell
$ dart example/minimist_with_options.dart  -- index.js package.json

{_: [index.js, package.json], pager: false, g: false, h: false, help: false, v: false, version: false, lang: en}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Clique-Paris/minimist/issues
