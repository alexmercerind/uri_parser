/// This file is a part of uri_parser (https://github.com/alexmercerind/uri_parser).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.
import 'dart:io';
import 'package:uri_parser/uri_parser.dart';

void main() {
  final parser = URIParser(Platform.executable);
  print(parser.type); // URIType.file
  print(parser.file); // File: 'C:/Flutter/bin/cache/dart-sdk/bin/dart.exe'
  print(parser.directory); // null
  print(parser.uri); // null
  print(parser.result); // file:///C:/Flutter/bin/cache/dart-sdk/bin/dart.exe
}
