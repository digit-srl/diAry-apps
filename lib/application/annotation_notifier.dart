import 'package:diary/domain/entities/annotation.dart';
import 'package:hive/hive.dart';
import 'package:state_notifier/state_notifier.dart';

enum AnnotationAction { Added, Removed, Edited }

class AnnotationState {
  final Annotation annotation;
  final AnnotationAction action;

  AnnotationState(this.annotation, this.action);
}

class AnnotationNotifier extends StateNotifier<AnnotationState>
    with LocatorMixin {
  final List<Annotation> annotations;

  AnnotationNotifier(this.annotations) : super(null);

  void addAnnotation(Annotation annotation) {
    state = AnnotationState(annotation, AnnotationAction.Added);
    Hive.box<Annotation>('annotations').add(annotation);
  }

  void removeAnnotation(Annotation annotation) {
    annotation.delete();
    annotations.removeWhere((a) => a.id == annotation.id);
    state = AnnotationState(annotation, AnnotationAction.Removed);
  }
}
