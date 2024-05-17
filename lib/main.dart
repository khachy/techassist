import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:techassist_app/components/colors.dart';
import 'package:techassist_app/models/ticket_list.dart';
import 'package:techassist_app/pages/welcome_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true,  ignoreSsl: true);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TicketLists(),
      child: ScreenUtilInit(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(
            useMaterial3: true,
          ).copyWith(
            scaffoldBackgroundColor: AppColors.whiteColor,
          ),
          home: const WelcomePage(),
        ),
      ),
    );
  }
}
