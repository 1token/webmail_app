List<ListWords>  listWords = [
  ListWords('Building a BitTorrent Client From The Ground Up in Go', 'You’ll likely learn more about BitTorrent than Go in this post, but it’s pretty interesting and another example of how concise Go can be for sophisticated use cases.'),
  ListWords('Building a Global Services Network using Go, QUIC, and Micro', 'The folks at Micro had the goal of allowing microservices to be deployed anywhere and still be able to communicate securely and easily.'),
  ListWords('Chime: A Future Go Editor for macOS', 'It’s in closed beta right now, but you may want to subscribe to their updates so you know when Chime is ready.'),
  ListWords('TinyGo 0.11.0: The Go Compiler for Small Places', 'We’ve linked to TinyGo a lot in the past year (but it’s deserved). The latest release bundles Clang in the release tarball and adds support for the Adafruit Pybadge.'),
  ListWords('Šéf súdu preveruje, či Mamojka hovorí\npri Kočnerovi pravdu', 'Tóth na súde tvrdil, že u ústavného sudcu vybavoval prepustenie Kočnera.'),
];

class ListWords {
  String titlelist;
  String definitionlist;

  ListWords(String titlelist, String definitionlist) {
    this.titlelist = titlelist;
    this.definitionlist = definitionlist;
  }
}