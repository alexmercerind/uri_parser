import 'dart:io';

import 'package:test/test.dart';
import 'package:uri_parser/uri_parser.dart';

void main() {
  test('file:// File', () {
    final parser = URIParser('file://C:/Windows/explorer.exe');
    expect(parser.type, URIType.file);
    expect(parser.file, isNotNull);
    expect(parser.directory, isNull);
    expect(parser.uri, isNull);
  });
  test('file:// Directory', () {
    final parser = URIParser('file://C:/Windows/System32');
    expect(parser.type, URIType.directory);
    expect(parser.file, isNull);
    expect(parser.directory, isNotNull);
    expect(parser.uri, isNull);
  });
  test('file:// File with three forward slashes', () {
    final parser = URIParser('file:///C:/Windows/explorer.exe');
    expect(parser.type, URIType.file);
    expect(parser.file, isNotNull);
    expect(parser.directory, isNull);
    expect(parser.uri, isNull);
  });
  test('file:// Directory with three forward slashes', () {
    final parser = URIParser('file:///C:/Windows/System32');
    expect(parser.type, URIType.directory);
    expect(parser.file, isNull);
    expect(parser.directory, isNotNull);
    expect(parser.uri, isNull);
  });
  test(
    'file:// File with backward slashes',
    () {
      final parser = URIParser('file://C:\\Windows\\explorer.exe');
      expect(parser.type, URIType.file);
      expect(parser.file, isNotNull);
      expect(parser.directory, isNull);
      expect(parser.uri, isNull);
    },
    skip: !Platform.isWindows,
  );
  test(
    'file:// Directory with backward slashes',
    () {
      final parser = URIParser('file://C:\\Windows\\System32');
      expect(parser.type, URIType.directory);
      expect(parser.file, isNull);
      expect(parser.directory, isNotNull);
      expect(parser.uri, isNull);
    },
    skip: !Platform.isWindows,
  );
  test('raw path File', () {
    final parser = URIParser('C:/Windows/explorer.exe');
    expect(parser.type, URIType.file);
    expect(parser.file, isNotNull);
    expect(parser.directory, isNull);
    expect(parser.uri, isNull);
  });
  test('raw path Directory', () {
    final parser = URIParser('C:/Windows/System32');
    expect(parser.type, URIType.directory);
    expect(parser.file, isNull);
    expect(parser.directory, isNotNull);
    expect(parser.uri, isNull);
  });
  test(
    'raw path File with backward slashes',
    () {
      final parser = URIParser('C:\\Windows\\explorer.exe');
      expect(parser.type, URIType.file);
      expect(parser.file, isNotNull);
      expect(parser.directory, isNull);
      expect(parser.uri, isNull);
    },
    skip: !Platform.isWindows,
  );
  test(
    'raw path Directory with backward slashes',
    () {
      final parser = URIParser('C:\\Windows\\System32');
      expect(parser.type, URIType.directory);
      expect(parser.file, isNull);
      expect(parser.directory, isNotNull);
      expect(parser.uri, isNull);
    },
    skip: !Platform.isWindows,
  );
  test('network URIs', () {
    final http = URIParser('http://www.test.com');
    expect(http.type, URIType.network);
    expect(http.file, isNull);
    expect(http.directory, isNull);
    expect(http.uri, isNotNull);
    final https = URIParser('https://www.test.com');
    expect(https.type, URIType.network);
    expect(https.file, isNull);
    expect(https.directory, isNull);
    expect(https.uri, isNotNull);
    final ftp = URIParser('ftp://www.test.com');
    expect(ftp.type, URIType.network);
    expect(ftp.file, isNull);
    expect(ftp.directory, isNull);
    expect(ftp.uri, isNotNull);
    final rtsp = URIParser('rtsp://www.test.com');
    expect(rtsp.type, URIType.network);
    expect(rtsp.file, isNull);
    expect(rtsp.directory, isNull);
    expect(rtsp.uri, isNotNull);
    final rtmp = URIParser('rtmp://www.test.com');
    expect(rtmp.type, URIType.network);
    expect(rtmp.file, isNull);
    expect(rtmp.directory, isNull);
    expect(rtmp.uri, isNotNull);
  });
  test('unknown URIs', () {
    final parser = URIParser('unknown://www.test.com');
    expect(parser.type, URIType.other);
    expect(parser.file, isNull);
    expect(parser.directory, isNull);
    expect(parser.uri, isNull);
  });
  test('exceptions', () {
    final abc = URIParser('abc');
    expect(abc.type, URIType.other);
    expect(abc.file, isNull);
    expect(abc.directory, isNull);
    expect(abc.uri, isNull);
    final empty = URIParser('');
    expect(empty.type, URIType.other);
    expect(empty.file, isNull);
    expect(empty.directory, isNull);
    expect(empty.uri, isNull);
    final null_ = URIParser(null);
    expect(null_.type, URIType.other);
    expect(null_.file, isNull);
    expect(null_.directory, isNull);
    expect(null_.uri, isNull);
  });
}
