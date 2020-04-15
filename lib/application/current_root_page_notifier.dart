import 'package:state_notifier/state_notifier.dart';

class CurrentRootPageState {
  CurrentRootPageState(this.currentPage);
  final int currentPage; // raccoglie l'elevation corrente di ogni pagina
}

class CurrentRootPageNotifier extends StateNotifier<CurrentRootPageState> {
  CurrentRootPageNotifier() : super(CurrentRootPageState(0));


  changePage(pageNumber) {
      state = CurrentRootPageState(pageNumber);

  }
}