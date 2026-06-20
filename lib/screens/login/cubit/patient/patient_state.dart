part of 'patient_cubit.dart';

@immutable
sealed class PatientState {}

final class PatientInitial extends PatientState {}

final class PatientLoading extends PatientState {}

final class PatientLoaded extends PatientState {
  final List<Patient> patients;

  PatientLoaded(this.patients);
}

final class PatientError extends PatientState {
  final String message;

  PatientError(this.message);
}

final class PatientAddLoading extends PatientState {}

final class PatientAddSuccess extends PatientState {}

final class PatientAddError extends PatientState {
  final String message;
  PatientAddError(this.message);
}

final class PatientSingleLoaded extends PatientState {
  final Patient patient;
  PatientSingleLoaded(this.patient);
}

final class PatientUpdateLoading extends PatientState {}

final class PatientUpdateSuccess extends PatientState {}

final class PatientUpdateError extends PatientState {
  final String message;
  PatientUpdateError(this.message);
}