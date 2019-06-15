import 'dart:io';

import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

import '../front_matter.dart';

// Default delimiter for YAML.
const defaultDelimiter = '---';

/// Document containing the original `value`, front matter `data` and `content`.
class FrontMatterDocument {
  FrontMatterDocument ( { @required this.data, @required this.content } );

  FrontMatterDocument.fromText ( String text, {String delimiter = defaultDelimiter} ) {
    // Remove any leading whitespace.
    final value = text.trimLeft ( );

    // If there's no starting delimiter, there's no front matter.
    if ( ! value.startsWith ( delimiter ) ) {
      content = value;
      data = YamlMap ( );
      return;
    }

    // Get the index of the closing delimiter.
    final closeIndex = value.indexOf ( '\n' + delimiter );

    // Get the raw front matter block between the opening and closing delimiters.
    final frontMatter = value.substring ( delimiter.length, closeIndex );

    if ( frontMatter.isNotEmpty ) {
      try {
        // Parse the front matter as YAML.
        data = loadYaml ( frontMatter );
      } catch ( e ) {
        throw FrontMatterException ( invalidYamlError );
      }
    }

    // The content begins after the closing delimiter index.
    content = value.substring ( closeIndex + (delimiter.length + 1) ).trim ( );

    print ( 'content: $content' );
  }

  static fromFile ( String path, {String delimiter = defaultDelimiter} ) async {
    var file = File ( path );

    // Throw an error if file not found.
    if ( ! await file.exists ( ) ) {
      throw FrontMatterException ( fileNotFoundError );
    }

    try {
      var text = await file.readAsString ( );
      return FrontMatterDocument.fromText ( text, delimiter: delimiter );
    } catch ( e ) {
      // Handle downstream errors, or throw one if file is not readable as text.
      switch ( e.message ) {
        case invalidYamlError:
          rethrow;
        default:
          throw FrontMatterException ( fileTypeError );
      }
    }
  }

  String content;

  /// The parsed YAML front matter as a [YamlMap].
  YamlMap data;

  String get value {
    var newValue = '---\n';

    for ( final d in data.entries.toList ( )
      ..sort ( ( a, b ) => a.key.compareTo ( b.key ) ) ) {
      newValue += '${d.key}: ${d.value}\n';
    }

    return '$newValue---\n\n$content';
  }
}