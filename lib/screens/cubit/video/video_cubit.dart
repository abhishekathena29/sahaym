import 'package:bloc/bloc.dart';
import 'package:bridging_saathi/logic/api/repo/repo.dart';

import 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  final Repo repo;

  VideoCubit(this.repo) : super(VideoInitial());

  Future<void> loadVideos() async {
    emit(VideoLoading());
    try {
      final videos = await repo.getVideos();
      emit(VideoLoaded(videos));
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }
}
