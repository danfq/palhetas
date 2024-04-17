class Comment {
  ///ID
  final String id;

  ///User Name
  final String userID;

  ///Content
  final String content;

  ///Post ID
  final String postID;

  ///Comment
  Comment({
    required this.id,
    required this.userID,
    required this.content,
    required this.postID,
  });

  ///`Comment` to JSON Object
  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "user": userID,
      "content": content,
      "post_id": postID,
    };
  }

  ///JSON Object to `Comment`
  factory Comment.fromJSON(Map<String, dynamic> json) {
    return Comment(
      id: json["id"],
      userID: json["user"],
      content: json["content"],
      postID: json["post_id"],
    );
  }
}
