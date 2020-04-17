import 'package:diary/application/info_pin/info_pin_state.dart';
import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/domain/entities/location.dart';
import 'package:hive/hive.dart';
import 'package:state_notifier/state_notifier.dart';

import '../annotation_notifier.dart';

class InfoAnnotationNotifier extends StateNotifier<InfoPinState>
    with LocatorMixin {
  final Annotation annotation;
  InfoAnnotationNotifier(this.annotation) : super(Initial());

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
    state = Initial();
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
    state = Initial();
  }
}

class IndexState {
  final int index;
  final Location location;
  final String note;
  IndexState(this.index, this.location, this.note);

  IndexState copyWith({int index, Location location, String note}) {
    return IndexState(
        index ?? this.index, location ?? this.location, note ?? this.note);
  }
}

class CurrentIndexNotifier extends StateNotifier<IndexState> {
  final List<Location> locations;
  final Box box;
  CurrentIndexNotifier(int initialValue, this.locations, this.box)
      : super(IndexState(initialValue, locations[initialValue],
            box.get(locations[initialValue].uuid)));

  int get max => locations.length;
  Location get selectedLocation => locations[state.index];
  String get counterStr => '${state.index + 1}/$max';
  String tmpText;

  Future<String> saveNote() async {
    if (tmpText != null && tmpText.isNotEmpty) {
      await box.put(state.location.uuid, tmpText);
      state = state.copyWith(note: tmpText);
      tmpText = '';
    }
    return state.note;
  }

  Future<String> removeNote() async {
    await box.delete(state.location.uuid);
    state = IndexState(state.index, state.location, null);
    return state.location.uuid;
  }

  goToNextPage() {
    if (state.index < max - 1) {
      state = IndexState(state.index + 1, locations[state.index + 1],
          box.get(locations[state.index + 1].uuid));
    }
  }

  goToPreviousPage() {
    if (state.index > 0) {
      state = IndexState(state.index - 1, locations[state.index - 1],
          box.get(locations[state.index - 1].uuid));
    }
  }

  setPage(int index) {
    state = IndexState(index, locations[index], box.get(locations[index].uuid));
  }

  @override
  set state(IndexState value) {
    if (value.index == state.index) {
      return;
    }
    super.state = value;
  }
}

class InfoPinNotifier extends StateNotifier<InfoPinState> with LocatorMixin {
//  final Location location;
  String tmpText;
  InfoPinNotifier() : super(Initial());

  void deleteAnnotation() {
    try {
      //TODO remove note
      state = DeleteComplete();
    } catch (ex) {
      state = Error(ex);
    }
  }

  void showDeletingQuestion() {
    state = Deleting();
  }

  void showInfo() {
    state = Initial();
  }

  showEditing(String note) {
    state = Editing(note ?? '');
  }

  void saveNewAnnotationText() {
//    if (tmpText != null && tmpText != annotation.title && tmpText.isNotEmpty) {
//      annotation.title = tmpText;
//      annotation.save();
//    }
//    state = Initial(annotation);
  }
}
