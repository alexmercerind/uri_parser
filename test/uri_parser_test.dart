import 'dart:io';
import 'package:test/test.dart';
import 'package:uri_parser/uri_parser.dart';

void main() {
  // Platform independent data for testing.
  final file = File(Platform.script.path.replaceAll('\\', '/'));
  final directory = File(Directory.systemTemp.path.replaceAll('\\', '/'));
  final networkDirectory = Directory('/192.168.1.1/share');
  final filePath = file.path;
  final filePathWithBackSlashes = file.path.replaceAll('/', '\\');
  final fileURIWithTwoSlashes = 'file://${file.path}';
  final fileURIWithThreeSlashes =
      Platform.isWindows ? 'file:///${file.path}' : 'file://${file.path}';
  final fileURIWithBackSlashes = 'file://${file.path.replaceAll('/', '\\')}';
  final directoryPath = directory.path;
  final directoryPathWithBackSlashes = directory.path.replaceAll('/', '\\');
  final directoryURIWithTwoSlashes = 'file://${directory.path}';
  final directoryURIWithThreeSlashes = Platform.isWindows
      ? 'file:///${directory.path}'
      : 'file://${directory.path}';
  final directoryURIWithTrailingSlash = Platform.isWindows
      ? 'file:///${directory.path}/'
      : 'file://${directory.path}/';
  final directoryURIWithBackSlashes =
      'file://${directory.path.replaceAll('/', '\\')}';
  final networkDirectoryPath = networkDirectory.path;
  final networkDirectoryPathWithBackSlashes =
      networkDirectory.path.replaceAll('/', '\\');
  final networkDirectoryURIWithTwoSlashes = 'file://${networkDirectory.path}';
  final networkDirectoryURIWithThreeSlashes = Platform.isWindows
      ? 'file:///${networkDirectory.path}'
      : 'file://${networkDirectory.path}';
  final networkDirectoryURIWithTrailingSlash = Platform.isWindows
      ? 'file:///${networkDirectory.path}/'
      : 'file://${networkDirectory.path}/';
  final networkDirectoryURIWithBackSlashes =
      'file://${networkDirectory.path.replaceAll('/', '\\')}';
  // Checks to ensure the testing data is correct.
  assert(!filePath.contains('\\'));
  assert(!filePathWithBackSlashes.contains('/'));
  assert(!fileURIWithBackSlashes.substring(7).contains('/'));
  assert(!directoryPath.endsWith('/'));
  assert(!directoryPath.contains('\\'));
  assert(!directoryPathWithBackSlashes.contains('/'));
  assert(!directoryURIWithBackSlashes.substring(7).contains('/'));

  // Print all values for debugging
  print('file: $file');
  print('directory: $directory');
  print('filePath: $filePath');
  print('filePathWithBackSlashes: $filePathWithBackSlashes');
  print('fileURIWithTwoSlashes: $fileURIWithTwoSlashes');
  print('fileURIWithThreeSlashes: $fileURIWithThreeSlashes');
  print('fileURIWithBackSlashes: $fileURIWithBackSlashes');
  print('directoryPath: $directoryPath');
  print('directoryPathWithBackSlashes: $directoryPathWithBackSlashes');
  print('directoryURIWithTwoSlashes: $directoryURIWithTwoSlashes');
  print('directoryURIWithThreeSlashes: $directoryURIWithThreeSlashes');
  print('directoryURIWithTrailingSlash: $directoryURIWithTrailingSlash');
  print('directoryURIWithBackSlashes: $directoryURIWithBackSlashes');

  // Actual tests.
  test('file:// File', () {
    final parser = URIParser(fileURIWithTwoSlashes);
    expect(parser.type, URIType.file);
    expect(parser.file, isNotNull);
    expect(parser.directory, isNull);
    expect(parser.uri, isNull);
    expect(parser.result.toString(), equals(fileURIWithThreeSlashes));
  });
  test('file:// Directory', () {
    final parser = URIParser(directoryURIWithTwoSlashes);
    expect(parser.type, URIType.directory);
    expect(parser.file, isNull);
    expect(parser.directory, isNotNull);
    expect(parser.uri, isNull);
    expect(parser.result.toString(), equals(directoryURIWithTrailingSlash));
  });
  test('file:// Network Directory', () {
    final parser = URIParser(networkDirectoryURIWithTwoSlashes);
    expect(parser.type, URIType.directory);
    expect(parser.file, isNull);
    expect(parser.directory, isNotNull);
    expect(parser.uri, isNull);
    expect(
        parser.result.toString(), equals(networkDirectoryURIWithTrailingSlash));
  });
  test('file:// File with three forward slashes', () {
    final parser = URIParser(fileURIWithThreeSlashes);
    expect(parser.type, URIType.file);
    expect(parser.file, isNotNull);
    expect(parser.directory, isNull);
    expect(parser.uri, isNull);
    expect(parser.result.toString(), equals(fileURIWithThreeSlashes));
  });
  test('file:// Directory with three forward slashes', () {
    final parser = URIParser(directoryURIWithThreeSlashes);
    expect(parser.type, URIType.directory);
    expect(parser.file, isNull);
    expect(parser.directory, isNotNull);
    expect(parser.uri, isNull);
    expect(parser.result.toString(), equals(directoryURIWithTrailingSlash));
  });
  test('file:// Network Directory with three forward slashes', () {
    final parser = URIParser(networkDirectoryURIWithThreeSlashes);
    expect(parser.type, URIType.directory);
    expect(parser.file, isNull);
    expect(parser.directory, isNotNull);
    expect(parser.uri, isNull);
    expect(
        parser.result.toString(), equals(networkDirectoryURIWithTrailingSlash));
  });
  test('file:// File with backward slashes', () {
    final parser = URIParser(fileURIWithBackSlashes);
    expect(parser.type, URIType.file);
    expect(parser.file, isNotNull);
    expect(parser.directory, isNull);
    expect(parser.uri, isNull);
    expect(parser.result.toString(), equals(fileURIWithThreeSlashes));
  });
  test('file:// Directory with backward slashes', () {
    final parser = URIParser(directoryURIWithBackSlashes);
    expect(parser.type, URIType.directory);
    expect(parser.file, isNull);
    expect(parser.directory, isNotNull);
    expect(parser.uri, isNull);
    expect(parser.result.toString(), equals(directoryURIWithTrailingSlash));
  });
  test('file:// Network Directory with backward slashes', () {
    final parser = URIParser(networkDirectoryURIWithBackSlashes);
    expect(parser.type, URIType.directory);
    expect(parser.file, isNull);
    expect(parser.directory, isNotNull);
    expect(parser.uri, isNull);
    expect(
        parser.result.toString(), equals(networkDirectoryURIWithTrailingSlash));
  });
  test('raw path File', () {
    final parser = URIParser(filePath);
    expect(parser.type, URIType.file);
    expect(parser.file, isNotNull);
    expect(parser.directory, isNull);
    expect(parser.uri, isNull);
    expect(parser.result.toString(), equals(fileURIWithThreeSlashes));
  });
  test('raw path Directory', () {
    final parser = URIParser(directoryPath);
    expect(parser.type, URIType.directory);
    expect(parser.file, isNull);
    expect(parser.directory, isNotNull);
    expect(parser.uri, isNull);
    expect(parser.result.toString(), equals(directoryURIWithTrailingSlash));
  });
  test('raw path Network Directory', () {
    final parser = URIParser(networkDirectoryPath);
    expect(parser.type, URIType.directory);
    expect(parser.file, isNull);
    expect(parser.directory, isNotNull);
    expect(parser.uri, isNull);
    expect(
        parser.result.toString(), equals(networkDirectoryURIWithTrailingSlash));
  });
  test('raw path File with backward slashes', () {
    final parser = URIParser(fileURIWithBackSlashes);
    expect(parser.type, URIType.file);
    expect(parser.file, isNotNull);
    expect(parser.directory, isNull);
    expect(parser.uri, isNull);
    expect(parser.result.toString(), equals(fileURIWithThreeSlashes));
  });
  test('raw path Directory with backward slashes', () {
    final parser = URIParser(directoryURIWithBackSlashes);
    expect(parser.type, URIType.directory);
    expect(parser.file, isNull);
    expect(parser.directory, isNotNull);
    expect(parser.uri, isNull);
    expect(parser.result.toString(), equals(directoryURIWithTrailingSlash));
  });
  test('raw path Network Directory with backward slashes', () {
    final parser = URIParser(networkDirectoryPathWithBackSlashes);
    expect(parser.type, URIType.directory);
    expect(parser.file, isNull);
    expect(parser.directory, isNotNull);
    expect(parser.uri, isNull);
    expect(
        parser.result.toString(), equals(networkDirectoryURIWithTrailingSlash));
  });
  test('network URIs', () {
    final http = URIParser('http://www.test.com');
    expect(http.type, URIType.network);
    expect(http.file, isNull);
    expect(http.directory, isNull);
    expect(http.uri, isNotNull);
    expect(http.result.toString(), equals('http://www.test.com'));
    final https = URIParser('https://www.test.com');
    expect(https.type, URIType.network);
    expect(https.file, isNull);
    expect(https.directory, isNull);
    expect(https.uri, isNotNull);
    expect(https.result.toString(), equals('https://www.test.com'));
    final ftp = URIParser('ftp://www.test.com');
    expect(ftp.type, URIType.network);
    expect(ftp.file, isNull);
    expect(ftp.directory, isNull);
    expect(ftp.uri, isNotNull);
    expect(ftp.result.toString(), equals('ftp://www.test.com'));
    final rtsp = URIParser('rtsp://www.test.com');
    expect(rtsp.type, URIType.network);
    expect(rtsp.file, isNull);
    expect(rtsp.directory, isNull);
    expect(rtsp.uri, isNotNull);
    expect(rtsp.result.toString(), equals('rtsp://www.test.com'));
    final rtmp = URIParser('rtmp://www.test.com');
    expect(rtmp.type, URIType.network);
    expect(rtmp.file, isNull);
    expect(rtmp.directory, isNull);
    expect(rtmp.uri, isNotNull);
    expect(rtmp.result.toString(), equals('rtmp://www.test.com'));
  });
  test('unknown URIs', () {
    final parser = URIParser('unknown://www.test.com');
    expect(parser.type, URIType.other);
    expect(parser.file, isNull);
    expect(parser.directory, isNull);
    expect(parser.uri, isNull);
    expect(parser.result.toString(), equals('unknown://www.test.com'));
  });
  test('exceptions', () {
    final abc = URIParser('abc');
    expect(abc.type, URIType.other);
    expect(abc.file, isNull);
    expect(abc.directory, isNull);
    expect(abc.uri, isNull);
    expect(abc.result.toString(), 'abc');
    final empty = URIParser('');
    expect(empty.type, URIType.other);
    expect(empty.file, isNull);
    expect(empty.directory, isNull);
    expect(empty.uri, isNull);
    expect(empty.result.toString(), '');
    final null_ = URIParser(null);
    expect(null_.type, URIType.other);
    expect(null_.file, isNull);
    expect(null_.directory, isNull);
    expect(null_.uri, isNull);
    expect(() => null_.result, throwsFormatException);
  });
}
