part of 'get_token_cubit.dart';

@immutable
sealed class GetTokenState {}

final class GetTokenInitial extends GetTokenState {}

final class GetTokenLoading extends GetTokenState {}

final class GetTokenSuccess extends GetTokenState {
  final String token;

  GetTokenSuccess(this.token);
}

final class GetTokenError extends GetTokenState {
  final String message;

  GetTokenError(this.message);
}
