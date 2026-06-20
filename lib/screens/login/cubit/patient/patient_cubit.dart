import 'package:bloc/bloc.dart';
import 'package:bridging_saathi/logic/api/repo/repo.dart';
import 'package:bridging_saathi/logic/config/prefs.dart';
import 'package:bridging_saathi/logic/model/patient/patient.dart';
import 'package:bridging_saathi/router/router.dart';
import 'package:meta/meta.dart';

part 'patient_state.dart';

class PatientCubit extends Cubit<PatientState> {
  PatientCubit(this.repo, this.prefs) : super(PatientInitial());

  final Repo repo;
  final Prefs prefs;

  Future<void> addPatient({
    required String fullName,
    required String phoneNumber,
    required int age,
    required int spouseAge,
    required String gender,
    required String educationLevel,
    required bool hasBp,
    required bool hasDiabetes,
    required bool hasKneeProblems,
    required bool hasSleepIssues,
    required bool hasMemoryIssues,
    required bool hasWeakness,
    required bool hadSurgery,
  }) async {
    emit(PatientAddLoading());
    try {
      final body = {
        'full_name': fullName,
        'phone_number': phoneNumber,
        'age': age,
        'spouse_age': spouseAge,
        'gender': gender.toLowerCase(),
        'education_level': educationLevel,
        'has_bp': hasBp,
        'has_diabetes': hasDiabetes,
        'has_knee_problems': hasKneeProblems,
        'has_sleep_issues': hasSleepIssues,
        'has_memory_issues': hasMemoryIssues,
        'has_weakness': hasWeakness,
        'had_surgery': hadSurgery,
        'fcm': '',
      };
      final response = await repo.addPatient(body);
      if (response.isSuccessful) {
        await prefs.setString(Prefs.apiToken, response.body['access_token']);
        await prefs.setBool(Prefs.authStatus, true);
        await prefs.setString(Prefs.userMobileNo, phoneNumber);
        // Update the AuthState to trigger router redirect
        await authState.checkAuthStatus();
        emit(PatientAddSuccess());
      } else {
        final error = response.error as Map<String, dynamic>;
        emit(PatientAddError(error['detail'] ?? 'Failed to add patient'));
      }
    } catch (e) {
      emit(PatientAddError('An error occurred: $e'));
    }
  }

  Future<void> updatePatient({
    required int id,
    required String fullName,
    required String phoneNumber,
    required int age,
    required int spouseAge,
    required String gender,
    required String educationLevel,
    required bool hasBp,
    required bool hasDiabetes,
    required bool hasKneeProblems,
    required bool hasSleepIssues,
    required bool hasMemoryIssues,
    required bool hasWeakness,
    required bool hadSurgery,
  }) async {
    emit(PatientUpdateLoading());
    try {
      final body = {
        'id': id,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'age': age,
        'spouse_age': spouseAge,
        'gender': gender.toLowerCase(),
        'education_level': educationLevel,
        'has_bp': hasBp,
        'has_diabetes': hasDiabetes,
        'has_knee_problems': hasKneeProblems,
        'has_sleep_issues': hasSleepIssues,
        'has_memory_issues': hasMemoryIssues,
        'has_weakness': hasWeakness,
        'had_surgery': hadSurgery,
      };
      final response = await repo.updatePatient(body);
      if (response.isSuccessful) {
        emit(PatientUpdateSuccess());
      } else {
        emit(PatientUpdateError('Failed to update patient'));
      }
    } catch (e) {
      emit(PatientUpdateError('An error occurred: $e'));
    }
  }
}
