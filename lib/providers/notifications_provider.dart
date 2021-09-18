
import 'package:flutter/material.dart';

class NotificationsProvider {

  static late GlobalKey<ScaffoldMessengerState> messagerKey = new GlobalKey<ScaffoldMessengerState>();

  static showSnackbar( String message ) {
    final snackBar = new SnackBar(
      content: Text( message ),
    );

    messagerKey.currentState!.showSnackBar(snackBar);

  } 


}