import 'package:flutter/material.dart';
import 'package:bab_club_finder/pages/home.dart';
import 'package:bab_club_finder/pages/about.dart';
import 'package:bab_club_finder/pages/map.dart';
import 'package:bab_club_finder/pages/club.dart';

void main() => runApp(MaterialApp(routes: {
      '/': (context) => ListPage(
            title: 'Dojos',
          ),
      '/about': (context) => const AboutPage(),
      '/map': (context) => const MapPage(),
      '/club': (context) => const ClubPage(),
    }));
