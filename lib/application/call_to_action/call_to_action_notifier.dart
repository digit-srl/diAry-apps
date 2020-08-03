import 'package:diary/core/errors/failures.dart';
import 'package:diary/domain/entities/call_to_action_response.dart';
import 'package:diary/domain/repositories/user_repository.dart';
import 'package:diary/infrastructure/repositories/location_repository_impl.dart';
import 'package:diary/utils/logger.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:state_notifier/state_notifier.dart';

part 'call_to_action_notifier.freezed.dart';

class CallToActionNotifier extends StateNotifier<CallToActionState>
    with LocatorMixin {
  final LocationRepository locationRepository;
  final UserRepository userRepository;
  CallToActionNotifier(this.locationRepository, this.userRepository)
      : super(Initial());

  loadCalls() async {
    final e = locationRepository.getAllCalls();
    e.fold((f) {
      String error = 'ERRORE SCONOSCIUTO';
      if (f is UnknownFailure) {
        error = f.message;
      }
      state = Error(error);
    }, (calls) {
      state = CallResult(calls);
    });
  }

  performCall() async {
    state = Loading();
    final lastCallToAction = userRepository.getLastCallToActionDate();
    final either =
        await locationRepository.performCallToAction(lastCallToAction);

    either.fold((f) {
      String error = 'ERRORE SCONOSCIUTO';
      if (f is NoLocationsFoundFailure) {
        error = 'Non ci sono campioni da analizzare';
      } else if (f is UnknownFailure) {
        error = f.message;
      }
      state = Error(error);
    }, (calls) async {
      await userRepository.saveCallToActionDate(DateTime.now());
      state = CallResult(calls);
    });
  }

  Future<void> updateCall(Call call) async {
    await locationRepository.updateCall(call);
  }

  Future<void> deleteCall(Call call) async {
    await locationRepository.deleteCall(call);
  }
}

@freezed
abstract class CallToActionState with _$CallToActionState {
  const factory CallToActionState.initial() = Initial;
  const factory CallToActionState.loading() = Loading;
  const factory CallToActionState.error([String message]) = Error;
  const factory CallToActionState.callResult(List<Call> calls) = CallResult;
}
