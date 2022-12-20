# [package:uri_parser](https://github.com/alexmercerind/uri_parser)

🔗 A minimal & safe utility to parse URIs.

## Install

Add in your `pubspec.yaml`.

```yaml
dependencies:
  uri_parser: ^1.0.0
```

## Example

### Parse or Identify

```dart
final parser = URIParser('C:/Windows/System32');
print(parser.type);            // URIType.directory
print(parser.file);            // null
print(parser.directory);       // Directory: 'C:/Windows/System32'
print(parser.uri);             // null
```

```dart
final parser = URIParser('C:\Windows\explorer.exe');
print(parser.type);            // URIType.file
print(parser.file);            // File: 'C:/Windows/explorer.exe'
print(parser.directory);       // null
print(parser.uri);             // null
```

```dart
final parser = URIParser('file://C:/Windows/explorer.exe');
print(parser.type);            // URIType.file
print(parser.file);            // File: 'C:/Windows/explorer.exe'
print(parser.directory);       // null
print(parser.uri);             // null
```

```dart
final parser = URIParser('https://www.example.com/test');
print(parser.type);            // URIType.network
print(parser.file);            // null
print(parser.directory);       // null
print(parser.uri);             // https://www.example.com/test
```

### Validate or Get [Uri](https://api.dart.dev/stable/2.18.6/dart-core/Uri-class.html)

```dart
final parser = URIParser('C:\Windows\explorer.exe');
final bool valid = parser.validate();
final Uri result = parser.result;
```

## Why

First of all, this is built with requirements of [Harmonoid](https://github.com/harmonoid/harmonoid) in mind.

Being a music player, there's a great involvement of URIs everywhere. Since, users can give their inputs in wide range of formats, this is built to handle that while providing some finer control. Few being:

- Handles both `file://` URIs & [`File`](https://api.dart.dev/stable/2.18.6/dart-io/File-class.html)/[`Directory`](https://api.dart.dev/stable/2.18.6/dart-io/Directory-class.html) path as input.
- Provides a way to distinguish between [`File`](https://api.dart.dev/stable/2.18.6/dart-io/File-class.html), [`Directory`](https://api.dart.dev/stable/2.18.6/dart-io/Directory-class.html) & network URLs.
- Correctly handles [`File`](https://api.dart.dev/stable/2.18.6/dart-io/File-class.html) paths with backward slashes on Windows.
- [`Uri.parse`](https://api.flutter.dev/flutter/dart-core/Uri/parse.html) & [`Uri.toFilePath`](https://api.flutter.dev/flutter/dart-core/Uri/toFilePath.html) do not handle `file://` scheme (with two slashes) correctly on Windows.

## License

Copyright © 2022, Hitesh Kumar Saini <<saini123hitesh@gmail.com>>

This project & the work under this repository is governed by MIT license that can be found in the [LICENSE](https://github.com/harmonoid/safe_local_storage/blob/master/LICENSE) file.
