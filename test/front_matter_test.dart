import 'package:test/test.dart';
import 'package:front_matter/front_matter.dart';

/// Represents a test with default parameters.
class Test {
  String foo, baz, bar, yawn, delimiter, content;

  Test (
    {this.foo = 'bar',
      this.baz = 'qux',
      this.bar = 'bing',
      this.yawn = 'snore',
      this.delimiter = defaultDelimiter,
      this.content = 'Hello, world!'} );

  String get frontMatter =>
    '${this.delimiter}\nbar: ${this.bar}\nbaz: ${this.baz}\nfoo: ${this.foo}\nyawn: ${this.yawn}\n${this.delimiter}';

  /// Joins front matter to content.
  String get value => '${this.frontMatter}\n\n${this.content}';
}

void main ( ) {
  test ( 'return type is `FrontMatterDocument`', ( ) {
    var text = 'foo';
    var expected = FrontMatterDocument.fromText ( text );
    var result = FrontMatterDocument.fromText ( text );

    expect ( result.runtimeType, equals ( expected.runtimeType ) );
  } );

  test ( 'parses front matter with default options', ( ) {
    var test = Test ( );

    var result = FrontMatterDocument.fromText ( test.value );

    expect ( result.value, equals ( test.value ) );
    expect ( result.content, equals ( test.content ) );
    expect ( result.data['foo'], equals ( test.foo ) );
    expect ( result.data['baz'], equals ( test.baz ) );
    expect ( result.data['bar'], equals ( test.bar ) );
    expect ( result.data['yawn'], equals ( test.yawn ) );
  } );

  test ( 'removes any leading spaces and linebreaks', ( ) {
    var test = Test ( );
    var result = FrontMatterDocument.fromText ( '    \n\n\n${test.value}' );

    expect ( result.content, equals ( test.content ) );
    expect ( result.data['foo'], equals ( test.foo ) );
  } );

  test ( 'uses custom delimiters', ( ) {
    var delimiters = ['* * *', '+++', '#####', '= yaml =', '¯\\_(ツ)_/¯'];
    var tests = delimiters.map ( ( delimiter ) => Test ( delimiter: delimiter ) );

    tests.forEach ( ( test ) {
      var result = FrontMatterDocument.fromText ( test.value, delimiter: test.delimiter );
      expect ( result.content, equals ( test.content ) );
      expect ( result.data['foo'], equals ( test.foo ) );
    } );
  } );

  test ( 'throws FrontMatterException when YAML is invalid', ( ) {
    var input = '---\nINVALID\n---\nfoo';
    expect ( ( ) => FrontMatterDocument.fromText ( input ),
      throwsA ( const TypeMatcher<FrontMatterException>( ) ) );
  } );

  test ( 'reads a file from disk and parses front matter', ( ) async {
    var result = await FrontMatterDocument.fromFile ( 'example/hello-world.md' );
    expect ( result.data['author'], equals ( 'izolate' ) );
  } );

  test ( 'throws an error if file not found', ( ) {
    expect (
        ( ) async => await FrontMatterDocument.fromFile ( '/path/to/nowhere' ),
      throwsA ( predicate ( ( e ) =>
      e is FrontMatterException && e.message == fileNotFoundError ) ) );
  } );

  test ( 'throws an error if file type is not supported', ( ) {
    expect (
        ( ) async => await FrontMatterDocument.fromFile ( 'test/dart.jpeg' ),
      throwsA ( predicate (
          ( e ) => e is FrontMatterException && e.message == fileTypeError ) ) );
  } );
}
