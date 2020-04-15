import 'package:diary/domain/entities/annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'info_annotation_state.freezed.dart';

@freezed
abstract class InfoAnnotationState with _$InfoAnnotationState {
  const factory InfoAnnotationState.initial(Annotation annotation) = Initial;
  const factory InfoAnnotationState.error(String error) = Error;
  const factory InfoAnnotationState.loading() = Loading;
  const factory InfoAnnotationState.deleting() = Deleting;
  const factory InfoAnnotationState.deleteComplete() = DeleteComplete;
  const factory InfoAnnotationState.editing(String text) = Editing;
}
