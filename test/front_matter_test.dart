import 'package:test/test.dart';
import 'package:front_matter/front_matter.dart' as fm;
import 'package:front_matter/src/front_matter.dart';
import 'package:front_matter/src/front_matter_document.dart';
import 'package:front_matter/src/front_matter_exception.dart';

const String _defaultDelimiter = '---';
const String _defaultContent = 'Hello, world!';
const Map<String, String> _defaultData = {'foo': 'bar', 'baz': 'qux'};

/// Represents a test with default parameters.
class Test {
  String delimiter, content;
  Map<String, String> data;

  Test(
      {this.delimiter = _defaultDelimiter,
      this.content = _defaultContent,
      this.data = _defaultData});

  /// Converts data to a front matter block
  String get frontMatter {
    var data = this
        .data
        .entries
        .toList()
        .map((entry) => '${entry.key}: ${entry.value}');
    return "${this.delimiter}\n${data.join('\n')}\n${this.delimiter}";
  }

  /// Joins front matter to content.
  String toString() => '${this.frontMatter}${this.content}';
}

void main() {
  test('return type is `FrontMatterDocument`', () {
    var text = 'foo';
    var expected = FrontMatterDocument(text);
    var result = fm.parse(text);

    expect(result.runtimeType, equals(expected.runtimeType));
  });

  test('parses front matter with default options', () {
    var test = Test();
    var result = fm.parse(test.toString());

    expect(result.toString(), equals(test.toString()));
    expect(result.content, equals(test.content));
    expect(result.data['foo'], equals(test.data['foo']));
    expect(result.data['baz'], equals(test.data['baz']));
  });

  test('removes any leading spaces and linebreaks', () {
    var test = Test();
    var result = fm.parse('    \n\n\n${test.toString()}');

    expect(result.content, equals(test.content));
    expect(result.data['foo'], equals(test.data['foo']));
  });

  test('uses custom delimiters', () {
    var delimiters = ['* * *', '+++', '#####', '= yaml =', '¯\\_(ツ)_/¯'];
    var tests = delimiters.map((delimiter) => Test(delimiter: delimiter));

    tests.forEach((test) {
      var result = fm.parse(test.toString(), delimiter: test.delimiter);
      expect(result.content, equals(test.content));
      expect(result.data['foo'], equals(test.data['foo']));
    });
  });

  test('throws FrontMatterException when YAML is invalid', () {
    var input = '---\nINVALID\n---\nfoo';
    expect(() => fm.parse(input),
        throwsA(const TypeMatcher<FrontMatterException>()));
  });

  test('reads a file from disk and parses front matter', () async {
    var result = await fm.parseFile('example/hello-world.md');
    expect(result.data['author'], equals('izolate'));
  });

  test('throws an error if file not found', () {
    expect(
        () async => await fm.parseFile('/path/to/nowhere'),
        throwsA(predicate((e) =>
            e is FrontMatterException && e.message == fileNotFoundError)));
  });

  test('throws an error if file type is not supported', () {
    expect(
        () async => await fm.parseFile('test/dart.jpeg'),
        throwsA(predicate(
            (e) => e is FrontMatterException && e.message == fileTypeError)));
  });
}
