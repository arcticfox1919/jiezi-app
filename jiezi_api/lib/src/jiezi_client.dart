// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:gio/gio.dart';

import 'clients/admin_client.dart';
import 'clients/auth_client.dart';
import 'clients/files_client.dart';
import 'clients/setup_client.dart';

/// Jiezi Cloud API `v0.1.0`.
///
/// Jiezi Cloud document management system REST API.
class JieziClient {
  JieziClient(
    Gio gio, {
    String? baseUrl,
  })  : _gio = gio,
        _baseUrl = baseUrl;

  final Gio _gio;
  final String? _baseUrl;

  static String get version => '0.1.0';

  AdminClient? _admin;
  AuthClient? _auth;
  FilesClient? _files;
  SetupClient? _setup;

  AdminClient get admin => _admin ??= AdminClient(_gio, baseUrl: _baseUrl);

  AuthClient get auth => _auth ??= AuthClient(_gio, baseUrl: _baseUrl);

  FilesClient get files => _files ??= FilesClient(_gio, baseUrl: _baseUrl);

  SetupClient get setup => _setup ??= SetupClient(_gio, baseUrl: _baseUrl);
}
