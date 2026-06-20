import 'dart:developer';
import 'package:bridging_saathi/bridging_saathi_app.dart';
import 'package:bridging_saathi/logic/api/client/api_service.dart';
import 'package:bridging_saathi/logic/api/repo/repo.dart';
import 'package:bridging_saathi/logic/config/prefs.dart';
import 'package:bridging_saathi/screens/cubit/getToken/get_token_cubit.dart';
import 'package:bridging_saathi/screens/login/cubit/patient/patient_cubit.dart';
import 'package:bridging_saathi/screens/login/cubit/profile/profile_cubit.dart';
import 'package:bridging_saathi/screens/cubit/photo/photo_cubit.dart';
import 'package:bridging_saathi/screens/cubit/event/event_cubit.dart';
import 'package:bridging_saathi/screens/cubit/video/video_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLogging();

  final prefs = Prefs();

  final apiService = ApiService.create(prefs);
  final Repo repo = Repo(apiService, prefs);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => PatientCubit(repo, prefs)),
      BlocProvider(create: (context) => ProfileCubit(repo)),
      BlocProvider(create: (context) => PhotoCubit(repo)),
      BlocProvider(create: (context) => VideoCubit(repo)),
      BlocProvider(create: (context) => EventCubit(repo)),
      BlocProvider(create: (context) => GetTokenCubit(repo, prefs)),
    ],
    child: const BridgingSaathiApp(),
  ));
}

void setUpLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    log('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}
