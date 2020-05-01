# minimist

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

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Clique-Paris/minimist/issues
