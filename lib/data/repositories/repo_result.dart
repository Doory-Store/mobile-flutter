import 'dart:async';

import '../../core/l10n/doory_strings.dart';
import '../../core/network/api_exception.dart';

sealed class RepoResult<T> {
  const RepoResult();
}

class RepoOk<T> extends RepoResult<T> {
  const RepoOk(this.data);

  final T data;
}

class RepoUnavailable<T> extends RepoResult<T> {
  const RepoUnavailable({this.sample, this.message});

  final T? sample;
  final String? message;
}

class RepoRejected<T> extends RepoResult<T> {
  const RepoRejected(this.message);

  final String message;
}

class RepoNotFound<T> extends RepoResult<T> {
  const RepoNotFound();
}

/// Maps transport failures onto the four repository results.
///
/// A cancelled request never completes, so a disposed route does not surface
/// as an error. Labelled samples are attached only for unreachable hosts.
Future<RepoResult<T>> runRequest<T>({
  required bool hasBaseUrl,
  required Future<T> Function() request,
  T? Function()? demo,
}) async {
  if (!hasBaseUrl) {
    return RepoUnavailable<T>(sample: demo?.call());
  }
  try {
    final value = await request();
    return RepoOk<T>(value);
  } on ApiCancelled {
    return Completer<RepoResult<T>>().future;
  } on ApiException catch (error) {
    switch (error.kind) {
      case ApiFailureKind.notFound:
        return RepoNotFound<T>();
      case ApiFailureKind.validation:
      case ApiFailureKind.unauthorized:
      case ApiFailureKind.forbidden:
      case ApiFailureKind.rateLimited:
        return RepoRejected<T>(
          error.message.isEmpty ? DooryStrings.rejectedGeneric : error.message,
        );
      case ApiFailureKind.network:
      case ApiFailureKind.server:
      case ApiFailureKind.unknown:
        return RepoUnavailable<T>(
          sample: demo?.call(),
          message: error.message.isEmpty
              ? DooryStrings.unavailable
              : error.message,
        );
    }
  } on FormatException {
    return const RepoRejected(DooryStrings.unreadable);
  } on TypeError {
    return const RepoRejected(DooryStrings.unreadable);
  }
}
