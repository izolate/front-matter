import 'package:test/test.dart';
import 'package:front_matter/front_matter.dart' as fm;
import 'package:front_matter/src/front_matter_document.dart';
import 'package:front_matter/src/front_matter_exception.dart';

const String _defaultDelimiter = '---';
const String _defaultContent = 'Hello, world!';
const Map<String, String> _defaultData = {'foo': 'bar', 'baz': 'qux'};

/// Represents a test with default parameters.
class Test {
  Test(
      {this.delimiter = _defaultDelimiter,
      this.content = _defaultContent,
      this.data = _defaultData});

  String delimiter, content;
  Map<String, String> data;

  /// Converts data to a front matter block
  String get frontMatter {
    final data = this
        .data
        .entries
        .toList()
        .map((entry) => '${entry.key}: ${entry.value}');
    return "$delimiter\n${data.join('\n')}\n$delimiter";
  }

  /// Joins front matter to content.
  @override
  String toString() => '$frontMatter$content';
}

void main() {
  test('return type is `FrontMatterDocument`', () {
    const text = 'foo';
    final expected = FrontMatterDocument(value: text);
    final result = fm.parse(text);

    expect(result.runtimeType, equals(expected.runtimeType));
  });

  test('parses front matter with default options', () {
    final test = Test();
    final result = fm.parse(test.toString());

    expect(result.toString(), equals(test.toString()));
    expect(result.content, equals(test.content));
    expect(result.data!['foo'], equals(test.data['foo']));
    expect(result.data!['baz'], equals(test.data['baz']));
  });

  test('removes any leading spaces and linebreaks', () {
    final test = Test();
    final result = fm.parse('    \n\n\n${test.toString()}');

    expect(result.content, equals(test.content));
    expect(result.data!['foo'], equals(test.data['foo']));
  });

  test('uses custom delimiters', () {
    final delimiters = ['* * *', '+++', '#####', '= yaml =', '¯\\_(ツ)_/¯'];
    final tests = delimiters.map((delimiter) => Test(delimiter: delimiter));

    for (final test in tests) {
      final result = fm.parse(test.toString(), delimiter: test.delimiter);
      expect(result.content, equals(test.content));
      expect(result.data!['foo'], equals(test.data['foo']));
    }
  });

  test('throws FrontMatterException when YAML is invalid', () {
    const input = '---\nINVALID\n---\nfoo';
    expect(() => fm.parse(input),
        throwsA(const TypeMatcher<FrontMatterException>()));
  });

  test('reads a file from disk and parses front matter', () async {
    final result = await fm.parseFile('example/hello-world.md');
    expect(result.data!['author'], equals('izolate'));
  });

  test('throws an error if file not found', () {
    expect(
        () async => fm.parseFile('/path/to/nowhere'),
        throwsA(predicate((e) =>
            e is FrontMatterException && e.message == fileNotFoundError)));
  });

  test('throws an error if file type is not supported', () {
    expect(
        () async => fm.parseFile('test/dart.jpeg'),
        throwsA(predicate(
            (e) => e is FrontMatterException && e.message == fileTypeError)));
  });
}
