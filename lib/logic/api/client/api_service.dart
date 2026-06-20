import 'dart:io';

import 'package:bridging_saathi/logic/api/interceptors/auth_interceptor.dart';
import 'package:bridging_saathi/logic/api/jsonConverter/custom_json_converter.dart';
import 'package:bridging_saathi/logic/config/prefs.dart';
import 'package:bridging_saathi/logic/model/patient/patient.dart';
import 'package:chopper/chopper.dart';
import 'package:http/io_client.dart' as http;
import '../../config/config.dart';

part 'api_service.chopper.dart';

@ChopperApi()
abstract class ApiService extends ChopperService {
  static ApiService create(Prefs prefs) {
    final httpClient = HttpClient();
    httpClient.badCertificateCallback = (cert, host, port) => true;
    httpClient.idleTimeout = const Duration(seconds: 45);
    httpClient.connectionTimeout = const Duration(seconds: 45);
    final client = ChopperClient(
        client: http.IOClient(httpClient),
        baseUrl: Uri.parse(baseUrl),
        interceptors: [
          HttpLoggingInterceptor(),
          AuthInterceptor(prefs),
        ],
        converter: const CustomJsonConverter(),
        errorConverter: const CustomJsonConverter(),
        services: [
          _$ApiService(),
        ]);
    return _$ApiService(client);
  }

  @POST(path: "auth/patient/login")
  Future<Response<dynamic>> login(@Query() String fcm);

  @GET(path: "auth/patient/logout")
  Future<Response<dynamic>> logOut();

  @GET(path: "auth/patient/get_token")
  Future<Response<dynamic>> getToken(@Query("phone_number") String phoneNumber);

  @GET(path: "patients/me")
  Future<Response<Patient>> getMyPatient();

  @POST(path: "patients")
  Future<Response<dynamic>> addPatient(
      @Body() Map<String, dynamic> patientData);

  @PUT(path: "patients")
  Future<Response<dynamic>> updatePatient(
      @Body() Map<String, dynamic> patientData);

  @GET(path: "photos")
  Future<Response<List<dynamic>>> getPhotos();

  @GET(path: "videos")
  Future<Response<List<dynamic>>> getVideos();

  @GET(path: "events")
  Future<Response<List<dynamic>>> getEvents();
}
