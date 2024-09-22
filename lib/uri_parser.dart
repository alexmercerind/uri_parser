import 'dart:io';
import 'package:safe_local_storage/safe_local_storage.dart';

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
    var value = data?.trim();
    if (value == null || value.isEmpty) return;
    // Get rid of quotes, if any.
    if (value.startsWith('"') && value.endsWith('"')) {
      value = value.substring(1, value.length - 1);
    }
    // Dart's [Uri] & [File] classes on Windows use (based on testing & user-feedback so far):
    // * Three slashes i.e. file:/// for storage file paths.
    // * Two slashes i.e. file:// for network paths.
    // Make sure to convert:
    // * Storage file URI with two slashes to three slashes for correct parsing.
    // * Network file URI with three slashes to two slashes for correct parsing.
    if (Platform.isWindows && value.toLowerCase().startsWith(kFileScheme2)) {
      bool storage = true;
      try {
        // Check if the first character after file:// is a number.
        final character = value
            .split(kFileScheme2)
            .last
            .split('/')
            .firstWhere((e) => e.isNotEmpty)[0];
        storage = int.tryParse(character) == null;
      } catch (_) {}
      if (storage) {
        // Replace two slashes with three slashes.
        if (value.toLowerCase().startsWith(kFileScheme2) &&
            !value.toLowerCase().startsWith(kFileScheme3)) {
          value = '$kFileScheme3${value.substring(kFileScheme2.length)}';
        }
      } else {
        // Replace three slashes with two slashes.
        if (value.toLowerCase().startsWith(kFileScheme3)) {
          value = '$kFileScheme2${value.substring(kFileScheme3.length)}';
        }
      }
    }
    try {
      final resource = Uri.parse(value);
      // Resolve the network scheme.
      bool network = false;
      for (final scheme in networkSchemes) {
        if (resource.isScheme(scheme)) {
          network = true;
          break;
        }
      }
      // Resolve the FILE scheme.
      if (resource.isScheme('FILE')) {
        var path = resource.toFilePath();
        if (FS.typeSync_(path) == FileSystemEntityType.file) {
          if (Platform.isWindows) {
            path = path.replaceAll('\\', '/');
          }
          type = URIType.file;
          file = File(path);
        }
        if (FS.typeSync_(path) == FileSystemEntityType.directory) {
          if (Platform.isWindows) {
            path = path.replaceAll('\\', '/');
          }
          type = URIType.directory;
          directory = Directory(path);
        }
      } else if (network) {
        type = URIType.network;
        uri = resource;
      }
    } catch (_) {}
    // Resolve direct file or directory paths.
    if (type == URIType.other) {
      try {
        if (FS.typeSync_(value) == FileSystemEntityType.file) {
          if (Platform.isWindows) {
            value = value.replaceAll('\\', '/');
          }
          type = URIType.file;
          file = File(value);
        }
        if (FS.typeSync_(value) == FileSystemEntityType.directory) {
          if (Platform.isWindows) {
            value = value.replaceAll('\\', '/');
          }
          type = URIType.directory;
          directory = Directory(value);
        }
      } catch (_) {}
    }
  }

  /// Default URI schemes to identified as [URIType.network].
  static const List<String> kDefaultNetworkSchemes = [
    'HTTP',
    'HTTPS',
    'FTP',
    'RTSP',
    'RTMP',
  ];

  static const String kFileScheme2 = 'file://';
  static const String kFileScheme3 = 'file:///';
}
