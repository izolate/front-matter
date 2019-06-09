# Front Matter

Extracts YAML front matter from a file or string.

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

Use `parse` to parse a string, or `parseFile` to read a file and parse its contents.

```dart
import 'dart:io';
import 'package:front_matter/front_matter.dart' as front_matter;

// Example 1 - parse file contents.
void example1() async {
  var file = new File('/path/to/file.md');
  var fileContents = await file.readAsString();
  var doc = front_matter.parse(fileContents);
  
  print(doc.data['title']); // "Hello, world!"
  print(doc.content);       // "This is an example."
}

// Example 2 - read file and parse contents.
void example2() async {
  var doc = await front_matter.parseFile('path/to/file.md');

  print(doc.data['title']); // "Hello, world!"
  print(doc.content);       // "This is an example."
}
```

I recommend using the import prefix `front_matter` due to the ambiguity of the method names.

### API

#### `FrontMatterDocument parse(String text, {String delimiter = "---"})`
Parse a string, return a `FrontMatterDocument` with results.

#### `Future<FrontMatterDocument> parseFile(String path, {String delimiter = "---"})`
Read a file and parse its contents, return a `Future<FrontMatterDocument>` with results.
