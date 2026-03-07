/// Route path constants mirroring AndroidTV navigation destinations.
class Destinations {
  const Destinations._();

  static const startup = '/';
  static const serverSelect = '/server-select';
  static const login = '/login';

  static const home = '/home';
  static const libraryBrowse = '/library/:libraryId';
  static const itemDetail = '/item/:itemId';
  static const search = '/search';
  static const videoPlayer = '/player/video';
  static const settings = '/settings';
  static const liveTv = '/live-tv';

  static String library(String libraryId) => '/library/$libraryId';
  static String item(String itemId) => '/item/$itemId';
}
