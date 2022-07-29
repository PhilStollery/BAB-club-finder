import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/dojos.dart' as babDojos;
import 'package:pull_to_reveal/pull_to_reveal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bab_club_finder/pages/about.dart';
import 'package:bab_club_finder/pages/map.dart';

class ListPage extends StatefulWidget {
  final String? title;
  final bool revealWhenEmpty;

  ListPage({Key? key, this.revealWhenEmpty = true, this.title})
      : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late String _filter = "";
  late int _noDojos = 0;

  // Open the map showing the whole of the UK
  babDojos.Dojos dojoLocations = babDojos.Dojos([]);
  late TextEditingController searchController;

  void getDojos() async {
    dojoLocations = await babDojos.getBABDojos();
    setState(() {
      _noDojos = dojoLocations.dojos.length;
    });
  }

  Future<void> _launchURLBrowser(String address) async {
    Uri url = Uri.parse(address);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  initState() {
    searchController = TextEditingController();
    searchController.addListener(_onSearch);
    super.initState();
    getDojos(); // Load up
  }

  void _onSearch() {
    List<babDojos.Dojo> filter = [];

    filter.addAll(dojoLocations.dojos);
    setState(() {
      _filter = searchController.text;
      if (_filter != "") {
        filter.retainWhere((element) {
          return ('${element.clubname} ${element.association} ${element.clubtown}')
              .toLowerCase()
              .contains(_filter.toLowerCase());
        });
        _noDojos = filter.length;
      } else {
        _noDojos = dojoLocations.dojos.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(brightness: Brightness.light),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.system,
        home: Scaffold(
          appBar: AppBar(
              title: Text(widget.title!),
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(
                    icon: Icon(Icons.help_outline_sharp),
                    onPressed: () {
                      //Navigator.pushNamed(context, '/about');
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const AboutPage()),
                      );
                    }),
                IconButton(
                    icon: Icon(Icons.explore_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const MapPage(),
                          settings: RouteSettings(arguments: dojoLocations),
                        ),
                      );
                    }),
              ]),
          body: Center(
            child: PullToRevealTopItemList.builder(
              revealWhenEmpty: widget.revealWhenEmpty,
              revealableHeight: 50,
              builder: (context, scrollController) => ListView.builder(
                controller: scrollController,
                itemCount: dojoLocations.dojos.length,
                itemBuilder: (BuildContext context, int index) {
                  if (_filter != null &&
                      !('${dojoLocations.dojos[index].clubname} ${dojoLocations.dojos[index].association} ${dojoLocations.dojos[index].clubtown}')
                          .toLowerCase()
                          .contains(_filter.toLowerCase())) {
                    return Container();
                  }
                  return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                          onTap: () {
                            //Open the BAB dojo details
                            //"https://www.bab.org.uk/clubs/club-search/?ViewClubMapID=\(clubID)#example"
                            _launchURLBrowser(
                                'https://www.bab.org.uk/clubs/club-search/?ViewClubMapID=${dojoLocations.dojos[index].id}#example');
                          },
                          title: Text(
                              dojoLocations.dojos[index].clubname.trim(),
                              key: Key('$index'),
                              style: Theme.of(context).textTheme.bodyText1),
                          subtitle: Container(
                            child: (Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(dojoLocations.dojos[index].association
                                    .trim()),
                                Text(
                                  dojoLocations.dojos[index].clubtown.trim(),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            )),
                          ),
                          isThreeLine: true,
                          trailing: const Icon(
                              Icons.keyboard_arrow_right_outlined,
                              size: 50)));
                },
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const AlwaysScrollableScrollPhysics(),
              ),
              dividerBuilder: (BuildContext context) {
                return Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Clubs: $_noDojos',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
              revealableBuilder: (BuildContext context,
                  RevealableToggler opener,
                  RevealableToggler closer,
                  BoxConstraints constraints) {
                return Row(
                  key: const Key('scrollable-row'),
                  children: <Widget>[
                    const SizedBox(width: 10),
                    Flexible(
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          suffixIcon: Icon(Icons.search,
                              color: Theme.of(context).backgroundColor),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        // Handles closing the `Revealable`
                        closer(completer: RevealableCompleter.snap);
                        // Removes any filtering effects
                        searchController.text = '';
                        setState(() {
                          _filter = "";
                        });
                      },
                    )
                  ],
                );
              },
            ),
          ),
        ));
  }
}
