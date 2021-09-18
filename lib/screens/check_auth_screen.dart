
import 'package:crud/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud/providers/providers.dart';

class CkeckAuthScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context, listen: false );

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authProvider.isAuthenticated(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {

            if ( !snapshot.hasData ) {
              return Text('Espere...');
            }

            if ( snapshot.data == '' ) {
              Future.microtask((){

                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (_,__,___) => LoginScreen(),
                  transitionDuration: Duration( seconds: 0 )
                ));

              });
            } else {
              Future.microtask((){

                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (_,__,___) => HomeScreen(),
                  transitionDuration: Duration( seconds: 0 )
                ));

              });
            }

            


            return Text('Espere...');
          },
        ),
      )
    );
  }

}