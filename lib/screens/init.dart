import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:genesis/models/User.dart';
import 'package:genesis/screens/acceuil.dart';
import 'package:genesis/screens/auth.dart';
import 'package:genesis/services/database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Initial extends StatefulWidget {
  const Initial({Key? key}) : super(key: key);

  @override
  _InitialState createState() => _InitialState();
}

void statut(user) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    if (user != null) {
      DatabaseService(user.uid).statutUser('active');
    } else {
      DatabaseService(user.uid).statutUser(
        DateFormat('dd MMM kk:mm').format(DateTime.now()),
      );
    }
  } else {
    DatabaseService(user.uid).statutUser(
      DateFormat('dd MMM kk:mm').format(DateTime.now()),
    );
  }
}

class _InitialState extends State<Initial> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    () => statut(user);
    if (user == null) {
      return const Auth();
    } else {
      return const Acceuil();
    }
  }
}
