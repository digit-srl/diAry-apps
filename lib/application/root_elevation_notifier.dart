import 'package:state_notifier/state_notifier.dart';

class ElevationState {
  ElevationState(this.elevations);
  final List<double> elevations; // raccoglie l'elevation corrente di ogni pagina
}

class RootElevationNotifier extends StateNotifier<ElevationState> {
  RootElevationNotifier() : super(ElevationState([0,4,0]));


  changeElevationIfDifferent(page, newElevation) {
    final currentElevations = state.elevations;

    if (currentElevations[page] != newElevation) {
      currentElevations[page] = newElevation;
      state = ElevationState(currentElevations);
    }
  }
}