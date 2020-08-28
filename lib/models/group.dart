import 'package:flutter_app/models/chatMessage.dart';

class Group {
  String id;
  String adminID;
  DateTime createdAt;
  String groupIcon;
  List<String> members;
  String name;
  Chat recentMessage;
}
