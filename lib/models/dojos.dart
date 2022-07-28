import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

//<marker Id="822" association="Go Shin Kai" clubname=" Aikido Kami" clubtown="Bourton on the Water" lat="51.885414" lng="-1.759105"
//c1="3" c2="0" c3="0" ct="0" yp="0" adults="2" family="0" children="1" weapons="0" clubmark="0" distance="0"/>

class Dojo {
  final int id;
  final String association;
  final String clubname;
  final String clubtown;
  final double lat;
  final double lng;

  Dojo(this.id, this.association, this.clubname, this.clubtown, this.lat,
      this.lng);
}

class Dojos {
  final List<Dojo> dojos;

  Dojos(this.dojos);
}

Future<Dojos> getBABDojos() async {
  const dojosLocationsURL =
      'https://www.bab.org.uk/wp-content/plugins/bab-clubs/googlemap/wordpress_clubs_xml.asp?lat=0&lng=0&radius=10&assoc=all&coach=all';

  // Retrieve the locations of BAB dojos
  try {
    final response = await http.get(Uri.parse(dojosLocationsURL));
    if (response.statusCode == 200) {
      return parseXML(response.body);
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  // Fallback for when the above HTTP request fails
  //- read dojos from a cached version
  return parseXML(await rootBundle.loadString('assets/dojos.xml'));
}

Dojos parseXML(String httpResponse) {
  final document = XmlDocument.parse(httpResponse);
  final clubs = document.findAllElements('marker');
  List<Dojo> parsedDojos = [];

//The returned XML has a <marker> node that uses attributes to store the data.
//<marker Id="822" association="Go Shin Kai" clubname=" Aikido Kami"
//clubtown="Bourton on the Water" lat="51.885414" lng="-1.759105"
//c1="3" c2="0" c3="0" ct="0" yp="0" adults="2" family="0" children="1"
//weapons="0" clubmark="0" distance="0"/>

  // For each marker create a dojo, some people forget to set their location on
  // the website so don't show these on the map. The latlng is set to 0.
  clubs.forEach((node) {
    if (node.getAttribute('lat')! != "0") {
      parsedDojos.add(Dojo(
          int.parse(node.getAttribute('Id')!),
          node.getAttribute('association')!,
          node.getAttribute('clubname')!,
          node.getAttribute('clubtown')!,
          double.parse(node.getAttribute('lat')!),
          double.parse(node.getAttribute('lng')!)));
    }
  });

  return Dojos(parsedDojos);
}
