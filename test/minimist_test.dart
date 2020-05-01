import 'package:minimist/minimist.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests without the parse schema', () {
    Minimist minimist;

    var arguments1 = ['-a', 'beep', '-b' ,'boop'],
        arguments2 = ['-tf', 'foo', '-b', 'bar'],
        arguments3 = ['-x', '0','-y', '1', '-n2', '-abc', '--hello=world', 'foo', 'bar', 'baz', '-def42'],
        arguments4 = ['-x', '0', '-y', '1', '-n2', '-abc', '--hello=hello world', 'foo', 'bar', 'baz', '-def42'];

    test('First arguments list', () {
      var minimist = Minimist(arguments1);
      expect(
        minimist.args, 
        <String, dynamic>{
          '_': [],
          'a': 'beep',
          'b': 'boop',
        });
    });

    test('Second argument list', () {
      var minimist = Minimist(arguments2);
      expect(
        minimist.args,
        {
          '_': [],
          't': true,
          'f': 'foo',
          'b': 'bar'
        }
      );
    });

    test('Third argument list', () {
      var minimist = Minimist(arguments3);
      expect(
        minimist.args,
        <String, dynamic>{
          'x': '0',
          'y': '1',
          'n': '2',
          'a': true,
          'b': true,
          'c': true,
          'hello': 'world',
          '_': ['foo', 'bar', 'baz'],
          'd': true,
          'e': true,
          'f': '42',
        }
      );
    });

    test('Fourth argument list', () {
      var minimist = Minimist(arguments4);
      expect(
        minimist.args,
        <String, dynamic>{
          'x': '0',
          'y': '1',
          'n': '2',
          'a': true,
          'b': true,
          'c': true,
          'hello': 'hello world',
          '_': ['foo', 'bar', 'baz'],
          'd': true,
          'e': true,
          'f': '42',
        }
      );
    });
  });
}
