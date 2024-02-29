/// {@template failure}
/// Base class for all failures.
/// {@endtemplate}
abstract class Failure {
  /// The message describing the failure.
  final String message;

  Failure(this.message);
}

/// {@template server_failure}
/// Thrown when a server error occurs.
/// {@endtemplate}
class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

/// {@template cache_failure}
/// Thrown when a cache error occurs.
/// {@endtemplate}
class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}