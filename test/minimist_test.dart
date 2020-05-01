import 'package:minimist/minimist.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests without the parse options', () {
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

  group('A group of tests with parse options', () {
    var options1 = MinimistOptions(
      string: ['username', 'password'],
      boolean: ['version', 'help'],
      alias: <String, String>{
        'help': 'h',
        'v': 'version',
        'username': 'u',
        'password': 'p',
        'pager': 'g'
      }
    ),
    options2 = MinimistOptions(
      boolean: ['help', 'version'],
      alias: <String, String> {
        'h': 'help',
        'v': 'version'
      }
    ),
    options3 = MinimistOptions(
      string: ['lang'],
      byDefault: <String, String> {
        'lang': 'en'
      }
    );

    var arguments1 = ['--username=root','--password', 'toor'];
    var arguments2 = ['--username=root','-p', 'toor'];
    var arguments3 = ['-u=root','--password', 'toor'];
    var arguments4 = ['-u=root','-p', 'toor'];
    var arguments5 = ['--help', '-v'];
    var arguments6 = ['--version'];

    test('First parsing options with simple arguments', () {
      var minimist = Minimist(arguments1, options: options1);
      expect(minimist.args,<String, dynamic>{
        'username': 'root',
        'u': 'root',
        'password': 'toor',
        'p': 'toor',
        'help': false,
        'version': false,
        'h': false,
        'v': false,
        'pager': false,
        'g': false,
        '_': []
      });
    });

    test('First parsing options with second arguments', () {
      var minimist = Minimist(arguments2, options: options1);
      expect(
        minimist.args,
        <String, dynamic>{
          'username': 'root',
          'u': 'root',
          'password': 'toor',
          'p': 'toor',
          'help': false,
          'h': false,
          'version': false,
          'v': false,
          'pager': false,
          'g': false,
          '_': []
        }
      );
    });

    test('First parsing options with third arguments', () {
      var minimist = Minimist(arguments3, options: options1);
      expect(
        minimist.args,
        <String, dynamic>{
          'username': 'root',
          'u': 'root',
          'password': 'toor',
          'p': 'toor',
          'help': false,
          'h': false,
          'version': false,
          'v': false,
          'pager': false,
          'g': false,
          '_': []
        }
      );
    });

    test('First parsing options with fourth arguments', () {
      var minimist = Minimist(arguments4, options: options1);
      expect(
        minimist.args,
        <String, dynamic>{
          'username': 'root',
          'u': 'root',
          'password': 'toor',
          'p': 'toor',
          '_': [],
          'help': false,
          'h': false,
          'version': false,
          'v': false,
          'pager': false,
          'g': false
        }
      );
    });

    test('First parsing options with fifth arguments', () {
      var minimist = Minimist(arguments5, options: options1);
      expect(
        minimist.args,
        <String, dynamic>{
          'help': true,
          'h': true,
          'version': true,
          'v': true,
          'pager': false,
          'g': false,
          '_': []
        }
      );
    });

    test('First parsing options with sixth arguments', () {
      var minimist = Minimist(arguments6, options: options1);
      expect(
        minimist.args,
        <String, dynamic>{
          'help': false,
          'h': false,
          'version': true,
          'v': true,
          'pager': false,
          'g': false,
          '_': []      
        }
      );
    });

    test('Second parsing options with first arguments', () {
      var minimist = Minimist(arguments1, options: options2);
      expect(
        minimist.args,
        <String, dynamic>{
          '_': ['toor'],
          'help': false,
          'h': false,
          'version': false,
          'v': false
        }
      );
    });

    test('Second parsing options with second arguments', () {
      var minimist = Minimist(arguments2, options: options2);
      expect(
        minimist.args,
        <String, dynamic>{
          '_': ['toor'],
          'help': false,
          'h': false,
          'version': false,
          'v': false
        }
      );
    });
    
    test('Second parsing options with third arguments', () {
      var minimist = Minimist(arguments3, options: options2);
      expect(
        minimist.args,
        <String, dynamic>{
          '_': ['toor'],
          'help': false,
          'h': false,
          'version': false,
          'v': false
        }
      );
    });
  
    test('Second parsing options with fourth arguments', () {
      var minimist = Minimist(arguments4, options: options2);
      expect(
        minimist.args,
        <String, dynamic>{
          '_': ['toor'],
          'help': false,
          'h': false,
          'version': false,
          'v': false
        }
      );
    });

    test('Second parsing options with fifth arguments', () {
      var minimist = Minimist(arguments5, options: options2);
      expect(
        minimist.args,
        <String, dynamic>{
          '_': [],
          'help': true,
          'h': true,
          'version': true,
          'v': true
        }
      );
    });

    test('Second parsing options with sixth arguments', () {
      var minimist = Minimist(arguments6, options: options2);
      expect(
        minimist.args,
        <String, dynamic>{
          '_': [],
          'help': false,
          'h': false,
          'version': true,
          'v': true
        }
      );
    });
  
    test('Third parsing options with a simple arguments list', () {
      var minimist = Minimist(
        ['--lang=fr'],
        options: options3
      );
      expect(minimist.args, <String, dynamic>{
        'lang': 'fr',
        '_': [],
      });
    });

    test('Third parsing options to test default value', () {
      var minimist = Minimist(
        [],
        options: options3
      );
      expect(minimist.args, <String, dynamic>{
        'lang': 'en',
        '_': [],
      });
    });
    
    test('Third parsing options with unknown values list', () {
      var minimist = Minimist(
        ['--lang', 'xml', '--', 'pubspec.yml', 'config.yml', 'package.json'],
        options: options3
      );
      expect(minimist.args, <String, dynamic>{
        'lang': 'xml',
        '_': ['pubspec.yml', 'config.yml', 'package.json'],
      });
    });


  });
}
