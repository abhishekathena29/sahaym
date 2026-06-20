import 'package:bridging_saathi/logic/model/video/video.dart';
import 'package:equatable/equatable.dart';

abstract class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object> get props => [];
}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final List<Video> videos;

  const VideoLoaded(this.videos);

  @override
  List<Object> get props => [videos];
}

class VideoError extends VideoState {
  final String message;

  const VideoError(this.message);

  @override
  List<Object> get props => [message];
}
