import 'package:diary/application/info_pin/info_annotation_state.dart';
import 'package:diary/domain/entities/annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../annotation_notifier.dart';

class InfoAnnotationNotifier extends StateNotifier<InfoAnnotationState>
    with LocatorMixin {
  final Annotation annotation;
  InfoAnnotationNotifier(this.annotation) : super(Initial(annotation));

  void deleteAnnotation() {
    try {
      read<AnnotationNotifier>().removeAnnotation(annotation);
      state = DeleteComplete();
    } catch (ex) {
      state = Error(ex);
    }
  }

  void showDeletingQuestion() {
    state = Deleting();
  }

  void showInfo() {
    state = Initial(annotation);
  }

  showEditing() {
    state = Editing(annotation.title);
  }

  String tmpText;

  void saveNewAnnotationText() {
    if (tmpText != null && tmpText != annotation.title && tmpText.isNotEmpty) {
      annotation.title = tmpText;
      annotation.save();
    }
    state = Initial(annotation);
  }
}
