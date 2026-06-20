import 'package:bloc/bloc.dart';
import 'package:bridging_saathi/logic/api/repo/repo.dart';
import 'package:bridging_saathi/logic/config/prefs.dart';
import 'package:meta/meta.dart';

part 'get_token_state.dart';

class GetTokenCubit extends Cubit<GetTokenState> {
  GetTokenCubit(this.repo, this.prefs) : super(GetTokenInitial());

  final Repo repo;
  final Prefs prefs;

  getToken(String phoneNumber) async {
    emit(GetTokenLoading());
    try {
      final response = await repo.getToken(phoneNumber);
      if (response.isSuccessful) {
        final token = response.body['access_token'];
        await prefs.setString(Prefs.apiToken, token);
        emit(GetTokenSuccess(token));
      } else {
        emit(GetTokenError('Failed to get token'));
      }
    } catch (e) {
      emit(GetTokenError('Failed to get token: $e'));
    }
  }
}
