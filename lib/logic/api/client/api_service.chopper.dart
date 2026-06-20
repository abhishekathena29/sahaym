// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ApiService extends ApiService {
  _$ApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ApiService;

  @override
  Future<Response<dynamic>> login(String fcm) {
    final Uri $url = Uri.parse('auth/patient/login');
    final Map<String, dynamic> $params = <String, dynamic>{'fcm': fcm};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> logOut() {
    final Uri $url = Uri.parse('auth/patient/logout');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getToken(String phoneNumber) {
    final Uri $url = Uri.parse('auth/patient/get_token');
    final Map<String, dynamic> $params = <String, dynamic>{
      'phone_number': phoneNumber
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Patient>> getMyPatient() {
    final Uri $url = Uri.parse('patients/me');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Patient, Patient>($request);
  }

  @override
  Future<Response<dynamic>> addPatient(Map<String, dynamic> patientData) {
    final Uri $url = Uri.parse('patients');
    final $body = patientData;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updatePatient(Map<String, dynamic> patientData) {
    final Uri $url = Uri.parse('patients');
    final $body = patientData;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<dynamic>>> getPhotos() {
    final Uri $url = Uri.parse('photos');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<dynamic>, List<dynamic>>($request);
  }

  @override
  Future<Response<List<dynamic>>> getVideos() {
    final Uri $url = Uri.parse('videos');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<dynamic>, List<dynamic>>($request);
  }

  @override
  Future<Response<List<dynamic>>> getEvents() {
    final Uri $url = Uri.parse('events');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<dynamic>, List<dynamic>>($request);
  }
}
