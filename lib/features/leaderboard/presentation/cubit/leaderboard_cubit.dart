import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_report_system/features/leaderboard/domain/usecases/get_leaderboard_usecase.dart';
import 'package:s_report_system/features/leaderboard/presentation/cubit/leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final GetLeaderboardUseCase getLeaderboardUseCase;

  LeaderboardCubit({required this.getLeaderboardUseCase})
    : super(LeaderboardInitial()) {
    getLeaderboard(); 
  }

  Future<void> getLeaderboard() async {
    emit(LeaderboardLoading());

    final result = await getLeaderboardUseCase();

    result.fold(
      (failure) {
        print("CUBIT_DEBUG: Error -> ${failure.errorMessage}");
        emit(LeaderboardError(message: failure.errorMessage));
      },
      (data) {
        print("CUBIT_DEBUG: Success -> Received ${data.length} volunteers");
        emit(LeaderboardLoaded(volunteers: data)); 
      },
    );
  }

  void refresh() => getLeaderboard();
}