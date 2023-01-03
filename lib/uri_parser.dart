/// This file is a part of uri_parser (https://github.com/alexmercerind/uri_parser).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.
import 'dart:io';
import 'package:safe_local_storage/safe_local_storage.dart';

/// Type of URI interpreted by [URIParser].
enum URIType {
  /// A local [File] on the device.
  file,

  /// A local [Directory] on the device.
  directory,

  /// A remote [Uri] on the internet.
  network,

  /// A [Uri] that is not supported by [URIParser].
  other,
}

/// URIParser
/// ---------
///
/// Converts a [String] URI to usable [File], [Directory] or [Uri] result.
///
class URIParser {
  /// The [String] URI to be parsed.
  final String? data;

  /// Type of the URI.
  URIType type = URIType.other;

  /// [File] interpreted from the URI.
  /// This is only available if [type] is [URIType.file].
  File? file;

  /// [Directory] interpreted from the URI.
  /// This is only available if [type] is [URIType.directory].
  Directory? directory;

  /// [Uri] interpreted from the URI.
  /// This is only available if [type] is [URIType.network].
  Uri? uri;

  /// The final [Uri] result after parsing.
  /// Prefer accessing [file], [directory] or [uri] directly if possible.
  ///
  /// Throws [FormatException] if [type] is [URIType.other] & could not be parsed.
  ///
  Uri get result {
    if (data == null) {
      throw FormatException('', null);
    }
    if (file != null) {
      assert(type == URIType.file);
      return file!.uri;
    }
    if (directory != null) {
      assert(type == URIType.directory);
      return directory!.uri;
    }
    if (uri != null) {
      assert(type == URIType.network);
      return uri!;
    }
    assert(type == URIType.other);
    return Uri.parse(data!);
  }

  /// Validates the URI.
  bool validate() {
    final typed = (type == URIType.file && file != null) ||
        (type == URIType.directory && directory != null) ||
        (type == URIType.network && uri != null);
    return typed && (type != URIType.other);
  }

  /// URIParser
  /// ---------
  ///
  /// Converts a [String] URI to usable [File], [Directory] or [Uri] result.
  ///
  URIParser(
    this.data, {
    List<String> networkSchemes = kDefaultNetworkSchemes,
  }) {
    var value = data?.trim();
    if (value != null) {
      // Get rid of quotes, if any.
      if (value.startsWith('"') && value.endsWith('"')) {
        value = value.substring(1, value.length - 1);
      }
      // Dart's [Uri] & [File] classes on Windows use (based on testing & user-feedback so far):
      // * Three slashes file:/// for local file paths. e.g. file:///C:/Users/Hitesh/Music/Sample.FLAC
      // * Two slashes file:// for network paths i.e. NAS. e.g. file://192.168.69.420/alexmercerind/mnt/media/music/sample.flac
      // Make sure to:
      // * Convert local file URI with two slashes `file://` to three slashes `file:///` for correct parsing.
      // * Convert network file URI with three slashes `file:///` to two slashes `file://` for correct parsing.
      // Since [Uri.parse] doesn't support local file:// URI with two slashes.
      if (Platform.isWindows && value.toLowerCase().startsWith('file://')) {
        bool local = true;
        try {
          // Check if the first character after `file://` is a number.
          final character = value
              .split('file://')
              .last
              .split('/')
              .firstWhere((e) => e.isNotEmpty)[0];
          local = int.tryParse(character) == null;
        } catch (exception) {
          // Do nothing.
        }
        if (local) {
          // Replace two slashes with three slashes.
          if (value.toLowerCase().startsWith('file://') &&
              !value.toLowerCase().startsWith('file:///')) {
            value = 'file:///${value.substring(7)}';
          }
        } else {
          // Replace three slashes with two slashes.
          if (value.toLowerCase().startsWith('file:///')) {
            value = 'file://${value.substring(8)}';
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
      } catch (exception) {
        // Do nothing.
      }
      // Resolve direct [File] or [Directory] paths.
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
        } catch (exception) {
          // Do nothing.
        }
      }
    }
  }

  /// Default URI schemes identified as [URIType.network].
  static const kDefaultNetworkSchemes = [
    'HTTP',
    'HTTPS',
    'FTP',
    'RTSP',
    'RTMP',
  ];
}
