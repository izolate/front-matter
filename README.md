# Front Matter

A front matter parser that extracts YAML metadata from the start of a file or string.

[![Build Status](https://travis-ci.org/izolate/front-matter.svg?branch=master)](https://travis-ci.org/izolate/front-matter)

Front matter is a concept heavily borrowed from [Jekyll](https://github.com/jekyll/jekyll), and other static site generators, referring to a block of YAML in the header of a file representing the file's metadata.

## Usage
Suppose you have the following Markdown file:

```markdown
---
title: "Hello, world!"
author: "izolate"
---

This is an example.
```

Use `parse` to parse a `String`, or `parseFile` to read a file and parse its contents.

```dart
import 'dart:io';
import 'package:front_matter/front_matter.dart' as fm;

// Example 1 - parse a string.
void example1() async {
  var file = File('/path/to/file.md');
  var fileContents = await file.readAsString();
  var doc = fm.parse(fileContents);
  
  print(doc.data['title']); // "Hello, world!"
  print(doc.content);       // "This is an example."
}

// Example 2 - read file and parse contents.
void example2() async {
  var doc = await fm.parseFile('path/to/file.md');

  print(doc.data['title']); // "Hello, world!"
  print(doc.content);       // "This is an example."
}
```

The returned document is an instance of `FrontMatterDocument` with properties:
* `YamlMap data` - The front matter.
* `String content` - The content body.

To convert the document back to the initial string value, call `toString()`.

```dart
var text = fm.parse('---\nfoo: bar\n---\nHello, world!');
var doc = fm.parse(text);

assert(doc.toString(), equals(text)); // true
```

### API

#### `FrontMatterDocument parse(String text, {String delimiter = "---"})`
Parse a string, return a `FrontMatterDocument` with results.

#### `Future<FrontMatterDocument> parseFile(String path, {String delimiter = "---"})`
Read a file and parse its contents, return a `Future<FrontMatterDocument>` with results.
