///App Constants
class Constants {
  ///Atom RSS Feed URL
  static const feedURL =
      "https://opalhetasnafoz.blogspot.com/feeds/posts/default";

  ///Share Text
  static String shareText({
    required String title,
    required String author,
    required String published,
  }) {
    return "$title\n\n-\n$author\n(https://opalhetasnafoz.blogspot.com/)\n$published";
  }
}
