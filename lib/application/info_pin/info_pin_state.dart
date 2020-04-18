import 'package:diary/domain/entities/annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'info_pin_state.freezed.dart';

@freezed
abstract class InfoPinState with _$InfoPinState {
  const factory InfoPinState.initial() = Initial;
  const factory InfoPinState.error(String error) = Error;
  const factory InfoPinState.loading() = Loading;
  const factory InfoPinState.deleting() = Deleting;
  const factory InfoPinState.deleteComplete() = DeleteComplete;
  const factory InfoPinState.editing(String text) = Editing;
}
