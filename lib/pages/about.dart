import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(brightness: Brightness.light),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.system,
        home: Scaffold(
            appBar: AppBar(
              title: const Text('About'),
              centerTitle: true,
              elevation: 0,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Image(
                  image: AssetImage('images/gi.png'),
                  fit: BoxFit.contain,
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Thank you for using the app.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    'If you can\'t find your Dojo in the app please make sure '
                    'your details are up-to-date on the BAB website. The Dojo '
                    'needs to have a location associated with it.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    softWrap: true,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(40.0),
                  child: Text(
                    'I made this for the love of Aikido and the hope that we '
                    'can all get back into the Dojo soon. It was developed '
                    'during the 2020 lockdown.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    softWrap: true,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(40.0),
                  child: Text(
                    'If you have any feedback or can help maintain the app, '
                    'email me.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(40.0),
                  child: Text(
                    'Email',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            )));
  }
}
