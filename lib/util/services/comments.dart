import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/route_manager.dart';
import 'package:palhetas/pages/account/login.dart';
import 'package:palhetas/pages/news/comment.dart';
import 'package:palhetas/util/data/local.dart';
import 'package:palhetas/util/models/comment.dart';
import 'package:palhetas/util/services/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///Comments Handler
class CommentsHandler {
  ///Supabase Instance
  static final _supabase = Supabase.instance.client;

  ///Show Comments Sheet
  static Future<void> showComments({required String postID}) async {
    //Comments
    final comments = await _getAll(postID: postID);

    //Comments With Users
    final commentsWithUsers = await _commentUsers(comments: comments);

    //Show Sheet
    await Get.bottomSheet(
      SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Title
                  const Text(
                    "Comentários",
                    style: TextStyle(fontSize: 24.0),
                  ),

                  //Add Comment
                  ElevatedButton.icon(
                    onPressed: () async {
                      //Close Sheet
                      Get.back();

                      //Current User
                      final currentUser = LocalData.boxData(box: "user");

                      //Check if Signed In
                      if (currentUser.isNotEmpty) {
                        //Open Comment Page
                        Navigator.push(
                          Get.context!,
                          CupertinoPageRoute(
                            builder: (context) => CommentPage(postID: postID),
                          ),
                        );
                      } else {
                        await Get.defaultDialog(
                          title: "Conta",
                          content: const Text(
                            "Para comentar, precisa de iniciar sessão.",
                          ),
                          contentPadding: const EdgeInsets.all(14.0),
                          cancel: TextButton(
                            onPressed: () => Get.back(),
                            child: const Text("Cancelar"),
                          ),
                          confirm: ElevatedButton(
                            onPressed: () {
                              //Close Dialog
                              Get.back();

                              //Open Sign In
                              Navigator.push(
                                Get.context!,
                                CupertinoPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            },
                            child: const Text("Iniciar Sessão"),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Ionicons.ios_add),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(Get.context!).cardColor,
                    ),
                    label: const Text("Escrever..."),
                  ),
                ],
              ),
            ),

            //Comments List
            commentsWithUsers.isNotEmpty
                ? SizedBox(
                    height: 400.0,
                    child: ListView.builder(
                      itemCount: commentsWithUsers.length,
                      itemBuilder: (context, index) {
                        //Comment Entry
                        final MapEntry<Comment, String> entry =
                            commentsWithUsers.entries.elementAt(index);

                        //Comment & Username
                        final Comment comment = entry.key;
                        final String username = entry.value;

                        //UI
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => CommentPage(
                                  postID: postID,
                                  comment: comment,
                                ),
                              ),
                            );
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                comment.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Center(child: Text("Sem Comentários")),
                  ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
    );
  }

  ///Publish Comment
  static Future<void> publishComment({required Comment comment}) async {
    //Add Comment
    await _supabase.from("comments").insert(comment.toJSON());
  }

  ///Get Comment & Respective Users
  static Future<Map<Comment, String>> _commentUsers({
    required List<Comment> comments,
  }) async {
    //Comment & User Map
    Map<Comment, String> users = {};

    //Get Username by Comment
    for (final comment in comments) {
      //Username
      final username = await Users.usernameByID(userID: comment.userID);

      //Add Username & Comment
      users[comment] = username;
    }

    //Return Users & Comments
    return users;
  }

  ///Get All
  static Future<List<Comment>> _getAll({required String postID}) async {
    //Comments
    List<Comment> comments = [];

    //Comments List
    final commentsList =
        await _supabase.from("comments").select().eq("post_id", postID);

    //Parse Comments
    for (final commentData in commentsList) {
      //Comment
      final comment = Comment.fromJSON(commentData);

      //Add Comment to List
      comments.add(comment);
    }

    //Return Comments
    return comments;
  }
}
