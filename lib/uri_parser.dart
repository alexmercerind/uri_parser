/// This file is a part of media_engine (https://github.com/alexmercerind/media_engine).
/// Copyright © 2022 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
///
/// This program is free software: you can redistribute it and/or modify
/// it under the terms of the GNU Affero General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// This program is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU Affero General Public License for more details.
///
/// You should have received a copy of the GNU Affero General Public License
/// along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

  /// Whether to log errors to the console or not.
  final bool verbose;

  /// Type of the URI.
  URIType type = URIType.other;

  /// [File] interpreted from the URI.
  File? file;

  /// [Directory] interpreted from the URI.
  Directory? directory;

  /// [Uri] interpreted from the URI.
  Uri? uri;

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
    this.verbose = true,
  }) {
    var value = data?.trim();
    if (value != null) {
      // Get rid of quotes, if any.
      if (value.startsWith('"') && value.endsWith('"')) {
        value = value.substring(1, value.length - 1);
      }
      // Make sure to convert file:// URI with two slashes to three slashes.
      // Since [Uri.parse] doesn't support file:// URI with two slashes.
      if (value.toLowerCase().startsWith('file://') &&
          !value.toLowerCase().startsWith('file:///')) {
        value = 'file:///${value.substring(7)}';
      }

      debugPrint(value.toString());
      // Resolve the file:// scheme.
      try {
        final resource = Uri.parse(value);
        if (resource.isScheme('FILE')) {
          var path = resource.toFilePath();
          // Replace forward slashes with backslashes on Windows, to make [FS] work correctly.
          if (Platform.isWindows) {
            path = path.replaceAll('/', '\\');
          }
          if (FS.typeSync_(path) == FileSystemEntityType.file) {
            if (Platform.isWindows) {
              path = path.replaceAll('\\', '/');
            }
            type = URIType.file;
            file = File(path);
            debugPrint(file.toString());
          }
          if (FS.typeSync_(path) == FileSystemEntityType.directory) {
            if (Platform.isWindows) {
              path = path.replaceAll('\\', '/');
            }
            type = URIType.directory;
            directory = Directory(path);
            debugPrint(directory.toString());
          }
        }
        // Resolve the network scheme.
        else if (resource.isScheme('HTTP') ||
            resource.isScheme('HTTPS') ||
            resource.isScheme('FTP') ||
            resource.isScheme('RTSP') ||
            resource.isScheme('RTMP')) {
          type = URIType.network;
          uri = resource;
          debugPrint(uri.toString());
        }
      } catch (exception, stacktrace) {
        // Likely [FormatException] from [Uri.parse].
        debugPrint(exception.toString());
        debugPrint(stacktrace.toString());
      }
      // Resolve direct [File] or [Directory] paths.
      if (type == URIType.other) {
        try {
          // Replace forward slashes with backslashes on Windows, to make [FS] work correctly.
          if (Platform.isWindows) {
            value = value.replaceAll('/', '\\');
          }
          if (FS.typeSync_(value) == FileSystemEntityType.file) {
            if (Platform.isWindows) {
              value = value.replaceAll('\\', '/');
            }
            type = URIType.file;
            file = File(value);
            debugPrint(file.toString());
          }
          if (FS.typeSync_(value) == FileSystemEntityType.directory) {
            if (Platform.isWindows) {
              value = value.replaceAll('\\', '/');
            }
            type = URIType.directory;
            directory = Directory(value);
            debugPrint(directory.toString());
          }
        } catch (exception, stacktrace) {
          // Likely [FormatException] from [Uri.parse].
          debugPrint(exception.toString());
          debugPrint(stacktrace.toString());
        }
      }
    }
  }

  /// Prints the passed [object] to the console.
  void debugPrint(String message) {
    if (verbose) {
      print(message);
    }
  }
}
