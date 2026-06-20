import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bridging_saathi/logic/api/repo/repo.dart';
import 'package:bridging_saathi/logic/model/patient/patient.dart';
import 'package:bridging_saathi/logic/model/profile/profile.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.repo) : super(ProfileInitial());
  final Repo repo;

  Future<void> getUser() async {
    emit(ProfileLoading());
    try {
      final response = await repo.getMyPatient();
      if (response.isSuccessful) {
        emit(ProfilePatientLoaded(response.body));
      } else {
        emit(ProfileError('Failed to load user'));
      }
    } catch (e) {
      log(e.toString());
      emit(ProfileError('An error occurred: $e'));
    }
  }
}
