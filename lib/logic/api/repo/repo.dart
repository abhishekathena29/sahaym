import 'package:bridging_saathi/logic/api/client/api_service.dart';
import 'package:bridging_saathi/logic/config/prefs.dart';
import 'package:bridging_saathi/logic/model/patient/patient.dart';
import 'package:bridging_saathi/logic/model/photo/photo.dart';
import 'package:bridging_saathi/logic/model/event/event.dart';
import 'package:bridging_saathi/logic/model/video/video.dart';

import 'package:chopper/chopper.dart';

class Repo {
  final ApiService apiService;
  final Prefs prefs;
  Repo(this.apiService, this.prefs);

  Future<Response<dynamic>> logOut() async {
    return await apiService.logOut();
  }

  Future<Response<Patient>> getMyPatient() async {
    return await apiService.getMyPatient();
  }

  Future<Response<dynamic>> addPatient(Map<String, dynamic> body) async {
    return await apiService.addPatient(body);
  }

  Future<Response<dynamic>> updatePatient(Map<String, dynamic> body) async {
    return await apiService.updatePatient(body);
  }

  Future<List<Photo>> getPhotos() async {
    final response = await apiService.getPhotos();
    if (response.isSuccessful && response.body != null) {
      return (response.body as List)
          .map((item) => Photo.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }

  Future<List<Event>> getEvents() async {
    final response = await apiService.getEvents();
    if (response.isSuccessful && response.body != null) {
      return (response.body as List)
          .map((item) => Event.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<Video>> getVideos() async {
    final response = await apiService.getVideos();
    if (response.isSuccessful && response.body != null) {
      final videos = (response.body as List)
          .map((item) => Video.fromJson(item as Map<String, dynamic>))
          .toList();
      videos.sort((a, b) => a.seqNumber.compareTo(b.seqNumber));
      return videos;
    } else {
      throw Exception('Failed to load videos');
    }
  }

  Future<Response<dynamic>> getToken(String phoneNumber) async {
    return await apiService.getToken(phoneNumber);
  }
}
