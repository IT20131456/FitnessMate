//test workout

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_mate/models/user_model.dart';

class Workout {
  String id;
  String name;
  String description;
  String type;
  String difficulty;
  String duration;
  String equipment;
  String image;
  String video;
  String creatorId;
  String creatorName;
  String creatorImage;
  int likes;
  int comments;
  int shares;
  bool isLiked;
  bool isSaved;
  Timestamp timestamp;

  

  Workout.fromMap(Map snapshot, String id)
      : id = id ?? '',
        name = snapshot['name'] ?? '',
        description = snapshot['description'] ?? '',
        type = snapshot['type'] ?? '',
        difficulty = snapshot['difficulty'] ?? '',
        duration = snapshot['duration'] ?? '',
        equipment = snapshot['equipment'] ?? '',
        image = snapshot['image'] ?? '',
        video = snapshot['video'] ?? '',
        creatorId = snapshot['creatorId'] ?? '',
        creatorName = snapshot['creatorName'] ?? '',
        creatorImage = snapshot['creatorImage'] ?? '',
        likes = snapshot['likes'] ?? 0,
        comments = snapshot['comments'] ?? 0,
        shares = snapshot['shares'] ?? 0,
        isLiked = snapshot['isLiked'] ?? false,
        isSaved = snapshot['isSaved'] ?? false,
        timestamp = snapshot['timestamp'] ?? Timestamp.now();

  toJson() {
    return {
      "name": name,
      "description": description,
      "type": type,
      "difficulty": difficulty,
      "duration": duration,
      "equipment": equipment,
      "image": image,
      "video": video,
      "creatorId": creatorId,
      "creatorName": creatorName,
      "creatorImage": creatorImage,
      "likes": likes,
      "comments": comments,
      "shares": shares,
      "isLiked": isLiked,
      "isSaved": isSaved,
      "timestamp": timestamp,
    };
  }
}

