import 'dart:io';
import 'package:uri_parser/uri_parser.dart';

void main() {
  final parser = URIParser(Platform.executable);
  print(parser.type);
  print(parser.file);
  print(parser.directory);
  print(parser.uri);
  print(parser.result);
}
