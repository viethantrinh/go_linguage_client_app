import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class MainEvent {}

class UpdateMainState extends MainEvent {
  final int currentIndex;
  UpdateMainState(this.currentIndex);
}

class UpdateProTabVisibility extends MainEvent {
  final bool showProTab;
  UpdateProTabVisibility(this.showProTab);
}

// States
abstract class MainState {}

class MainInitial extends MainState {
  final int currentIndex;
  final bool showProTab;
  MainInitial({
    this.currentIndex = 0,
    this.showProTab = true,
  });
}

// Bloc
class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitial()) {
    on<UpdateMainState>((event, emit) {
      final currentState = state as MainInitial;
      emit(MainInitial(
        currentIndex: event.currentIndex,
        showProTab: currentState.showProTab,
      ));
    });

    on<UpdateProTabVisibility>((event, emit) {
      final currentState = state as MainInitial;
      emit(MainInitial(
        currentIndex: currentState.currentIndex,
        showProTab: event.showProTab,
      ));
    });
  }
}