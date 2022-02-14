import 'package:devpush/core/app_colors.dart';
import 'package:devpush/providers/database_provider.dart';
import 'package:devpush/screens/login_screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:devpush/providers/auth_provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.black,
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: FutureBuilder(
          // Initialize FlutterFire:
          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return MaterialApp(
                home: Scaffold(
                  body: Center(
                    child: Column(
                      children: [
                        Text('Error!'),
                        Text(snapshot.error.toString())
                      ],
                    ),
                  ),
                ),
              );
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              Provider.of<AuthProvider>(context, listen: false).initAction();
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColor: Colors.white,
                  colorScheme: ColorScheme.fromSwatch()
                      .copyWith(secondary: Colors.white),
                ),
                title: 'DevPush',
                home: LoginScreen(),
              );
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
                  ),
                ),
              ),
            );
          }),
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
      ],
    );
  }
}
