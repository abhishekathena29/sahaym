import 'package:bloc/bloc.dart';
import 'package:bridging_saathi/logic/api/repo/repo.dart';
import 'package:bridging_saathi/logic/model/photo/photo.dart';

import 'photo_state.dart';

class PhotoCubit extends Cubit<PhotoState> {
  final Repo repo;

  PhotoCubit(this.repo) : super(PhotoInitial());

  Future<void> loadPhotos() async {
    emit(PhotoLoading());
    try {
      final photos = await repo.getPhotos();
      emit(PhotoLoaded(photos));
    } catch (e) {
      emit(PhotoError(e.toString()));
    }
  }
}
