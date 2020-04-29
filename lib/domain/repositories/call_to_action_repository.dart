/*
import 'package:dartz/dartz.dart';
import 'package:diary/core/errors/failures.dart';
import 'package:diary/domain/entities/call_to_action.dart';
import 'package:diary/domain/entities/call_to_action_response.dart';
import 'package:diary/infrastructure/data/call_to_action_remote_data_sources.dart';
import 'package:diary/utils/logger.dart';

abstract class CallToActionRepository {
  Future<Either<Failure, CallToActionResponse>> performCallToAction(
      CallToAction callToAction);
}

class CallToActionRepositoryImpl extends CallToActionRepository {
  final CallToActionRemoteDataSources callToActionRemoteDataSources;

  CallToActionRepositoryImpl(this.callToActionRemoteDataSources);

  @override
  Future<Either<Failure, CallToActionResponse>> performCallToAction(
      CallToAction callToAction) async {
    try {
      final response =
          await callToActionRemoteDataSources.sendData(callToAction);

      return right(response);
    } catch (e) {
      logger.e(e);
      return left(UnknownFailure(e.toString()));
    }
  }
}
*/
