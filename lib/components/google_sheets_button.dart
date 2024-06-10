import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleSheetsButton extends StatelessWidget {
  final String url = "https://docs.google.com/spreadsheets/d/1WgppSJbepP9hUlm_PDjmNkgVqXNrXadzsxut44JVkQU/edit#gid=0";

  void _launchURL() async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset('lib/images/googlesheets.png'),
      onPressed: _launchURL,
    );
  }
}
