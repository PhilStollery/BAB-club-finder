import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  Future<void> _launchURLBrowser(String address) async {
    Uri url = Uri.parse(address);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(brightness: Brightness.light),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.system,
        home: Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.keyboard_arrow_left_outlined, // add custom icons also
                ),
              ),
              title: const Text('About'),
              centerTitle: true,
              elevation: 0,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Image(
                  image: AssetImage('images/gi.png'),
                  fit: BoxFit.contain,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                  child: const Text(
                    'Thank you for using the app',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                  child: const Text(
                    'If you can\'t find your Dojo in the app please make sure '
                    'your details are up-to-date on the BAB website. The Dojo '
                    'needs to have a location associated with it.',
                    //style: Theme.of(context).textTheme.bodyText2,
                    softWrap: true,
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _launchURLBrowser('https://bab.org.uk/');
                    },
                    child: const Text('www.BAB.org.uk'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                  child: const Text(
                    'I made this for the love of Aikido and the hope that we '
                    'can all get back into the Dojo soon. It was developed '
                    'in my spare time.',
                    //style: Theme.of(context).textTheme.bodyText2,
                    softWrap: true,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                  child: const Text(
                    'If you have any feedback or can help maintain the app, '
                    'email me. All the code is on GitHub and open to PR requests.',
                    //style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _launchURLBrowser(
                          'mailto:sensei@bristol-ki-aikido.uk?subject=Dojo%20App%20Query');
                    },
                    child: const Text('sensei@bristol-ki-aikido.uk'),
                  ),
                ),
              ],
            )));
  }
}
