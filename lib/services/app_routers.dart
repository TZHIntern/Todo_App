import 'package:flutter/material.dart';
import 'package:flutter_bloc_application/screens/EditProfile/ui/edit_profile_screen.dart';

import 'package:flutter_bloc_application/screens/Home/ui/tabs_screen.dart';
import 'package:flutter_bloc_application/screens/SignIn/ui/sign_in.dart';
import 'package:flutter_bloc_application/widgets/recycle_bin.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case TabsScreen.name:
        return MaterialPageRoute(
          builder: (context) => const TabsScreen(),
        );
      case RecycleBin.name:
        return MaterialPageRoute(
          builder: (context) => const RecycleBin(),
        );
      case SignIn.name:
        return MaterialPageRoute(
          builder: (context) => const SignIn(),
        );
      case EditProfile.name:
        return MaterialPageRoute(
          builder: (context) => const EditProfile(),
        );
      default:
        return null;
    }
  }
}
