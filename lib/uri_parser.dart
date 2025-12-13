import 'dart:io';
import 'package:path/path.dart';

/// {@template uri_type}
///
/// URIType
/// -------
/// The type of URI.
///
/// {@endtemplate}
enum URIType {
  /// File.
  file,

  /// Directory.
  directory,

  /// Network.
  network,

  /// Other.
  other,
}

/// {@template uri_parser}
///
/// URIParser
/// ---------
/// Parses a [String] URI to usable [File], [Directory] or [Uri] result.
///
/// {@endtemplate}
class URIParser {
  static const String kFileScheme2 = 'file://';
  static const String kFileScheme3 = 'file:///';
  static const List<String> kDefaultNetworkSchemes = [
    'FTP',
    'HTTP',
    'HTTPS',
    'NFS',
    'RTMP',
    'RTSP',
    'SFTP',
    'SMB',
  ];

  /// Data.
  final String? data;

  /// Type.
  URIType type = URIType.other;

  /// File.
  File? file;

  /// Directory.
  Directory? directory;

  /// URI.
  Uri? uri;

  /// Result.
  Uri get result {
    if (data == null) throw FormatException();
    if (file != null) return file!.uri;
    if (directory != null) return directory!.uri;
    if (uri != null) return uri!;
    return Uri.parse(data!);
  }

  /// Validates the supplied data.
  bool validate() {
    final typed = (type == URIType.file && file != null) ||
        (type == URIType.directory && directory != null) ||
        (type == URIType.network && uri != null);
    return typed && (type != URIType.other);
  }

  /// {@macro uri_parser}
  URIParser(this.data, {List<String> networkSchemes = kDefaultNetworkSchemes}) {
    final value = _sanitizeData(data);
    if (value == null) return;

    try {
      // Resolve network schemes.
      final resource = Uri.parse(value);
      for (final scheme in networkSchemes) {
        if (resource.isScheme(scheme)) {
          type = URIType.network;
          uri = resource;
          return;
        }
      }
      // Resolve file:// scheme.
      if (resource.isScheme('FILE')) {
        _setFileOrDirectory(resource.toFilePath());
      }
    } catch (_) {}
    // Resolve file or directory paths.
    if (type == URIType.other && _isFileOrDirectory(value)) {
      _setFileOrDirectory(value);
    }
  }

  String? _sanitizeData(String? data) {
    String? value = data?.trim();

    if (value == null || value.isEmpty) return null;

    if ((value.startsWith('"') && value.endsWith('"')) ||
        (value.startsWith("'") && value.endsWith("'"))) {
      value = value.substring(1, value.length - 1);
    }

    value = value.replaceAll('\\', '/');

    // Dart's [Uri] & [File] classes use (based on testing & user-feedback so far):
    // * Three slashes i.e. file:/// for storage file paths.
    // * Two slashes i.e. file:// for network paths.
    // Make sure to convert:
    // * Storage file URI with two slashes to three slashes for correct parsing.
    // * Network file URI with three slashes to two slashes for correct parsing.
    if (value.toLowerCase().startsWith(kFileScheme2)) {
      bool storage = true;
      try {
        // Check if the first character after file:// is a number.
        final character = value
            .split(kFileScheme2)
            .lastOrNull
            ?.split('/')
            .firstWhere((e) => e.isNotEmpty, orElse: () => '');
        storage = int.tryParse(character ?? '') == null;
      } catch (_) {}
      if (storage) {
        // Ensure exactly three slashes.
        value = value.replaceFirst(
          RegExp(r'^file:(?:/{1,})'),
          kFileScheme3,
        );
      } else {
        // Ensure exactly two slashes.
        value = value.replaceFirst(
          RegExp(r'^file:(?:/{1,})'),
          kFileScheme2,
        );
      }
    }

    return value;
  }

  bool _isFileOrDirectory(String path) {
    return RegExp(r'^[A-Za-z]:/').hasMatch(path) || path.startsWith('/');
  }

  void _setFileOrDirectory(String path) {
    if (basename(path).contains('.')) {
      type = URIType.file;
      file = File(path);
    } else {
      type = URIType.directory;
      directory = Directory(path);
    }
  }
}
