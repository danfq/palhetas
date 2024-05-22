import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:palhetas/util/data/local.dart';
import 'package:palhetas/util/models/comment.dart';
import 'package:palhetas/util/notifications/toast.dart';
import 'package:palhetas/util/services/comments.dart';
import 'package:palhetas/util/widgets/main.dart';
import 'package:uuid/uuid.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({
    super.key,
    required this.postID,
    this.comment,
  });

  ///Post ID
  final String postID;

  ///New Comment
  final Comment? comment;

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  ///Comment Controller
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(title: const Text("Comentário")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextField(
                    controller: _commentController,
                    enabled: widget.comment == null,
                    decoration: InputDecoration(
                      hintText: widget.comment != null
                          ? widget.comment!.content
                          : "Escreva o seu comentário...",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(12.0),
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.comment == null
          ? Padding(
              padding: const EdgeInsets.all(40.0),
              child: ElevatedButton(
                onPressed: () async {
                  //Comment Content
                  final content = _commentController.text.trim();

                  //Current User
                  final currentUser = LocalData.boxData(box: "user");

                  if (content.isNotEmpty) {
                    //Confirm
                    await Get.defaultDialog(
                      title: "Publicar?",
                      content: Container(),
                      confirm: ElevatedButton(
                        onPressed: () async {
                          //Comment
                          final comment = Comment(
                            id: const Uuid().v4(),
                            userID: currentUser["id"],
                            content: content,
                            postID: widget.postID,
                          );

                          //Post Comment
                          await CommentsHandler.publishComment(
                              comment: comment);

                          //Close Page
                          Get.back();
                        },
                        child: const Text("Confirmar"),
                      ),
                      cancel: TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Cancelar"),
                      ),
                    );
                  } else {
                    LocalNotifications.toast(
                      message: "Escreva um comentário primeiro.",
                    );
                  }
                },
                child: const Text("Publicar Comentário"),
              ),
            )
          : null,
    );
  }
}
