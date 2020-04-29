import 'package:diary/core/errors/failures.dart';
import 'package:diary/domain/entities/call_to_action_response.dart';
import 'package:diary/domain/entities/call_to_action_result.dart';
import 'package:diary/infrastructure/repositories/location_repository_impl.dart';
import 'package:diary/utils/logger.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:state_notifier/state_notifier.dart';

part 'call_to_action_notifier.freezed.dart';

class CallToActionNotifier extends StateNotifier<CallToActionState>
    with LocatorMixin {
  final LocationRepository locationRepository;
  CallToActionNotifier(this.locationRepository) : super(Initial());

  performCall() async {
    state = Loading();
    final either = await locationRepository.performCallToAction();

    either.fold((f) {
      String error = 'ERRORE SCONOSCIUTO';
      if (f is NoLocationsFoundFailure) {
        error = 'Non ci sono campioni da analizzare';
      } else if (f is UnknownFailure) {
        error = f.message;
      }
      state = Error(error);
    }, (calls) {
      state = CallResult(calls);
    });
  }
}

@freezed
abstract class CallToActionState with _$CallToActionState {
  const factory CallToActionState.initial() = Initial;
  const factory CallToActionState.loading() = Loading;
  const factory CallToActionState.error([String message]) = Error;
  const factory CallToActionState.callResult(List<Call> calls) = CallResult;
}
