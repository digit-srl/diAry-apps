abstract class Failure {}

class ConflictDayFailure extends Failure {}

class UnprocessableDayFailure extends Failure {}

class NoLocationsFoundFailure extends Failure {}

class NoCallsFoundFailure extends Failure {}

class UnknownFailure extends Failure {
  final String message;

  UnknownFailure(this.message);
}
