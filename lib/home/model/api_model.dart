// https://ixifly.in/flutter/task2

class StoryResponseModel {
  bool? status;
  String? message;
  List<Data>? data;

  StoryResponseModel({this.status, this.message, this.data});

  StoryResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? userId;
  String? userName;
  String? profilePicture;
  List<Stories>? stories;

  Data({this.userId, this.userName, this.profilePicture, this.stories});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    profilePicture = json['profile_picture'];
    if (json['stories'] != null) {
      stories = <Stories>[];
      json['stories'].forEach((v) {
        stories!.add(Stories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['profile_picture'] = profilePicture;
    if (stories != null) {
      data['stories'] = stories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stories {
  int? storyId;
  String? mediaUrl;
  String? mediaType;
  String? timestamp;
  String? text;
  String? textDescription;

  Stories(
      {this.storyId,
      this.mediaUrl,
      this.mediaType,
      this.timestamp,
      this.text,
      this.textDescription});

  Stories.fromJson(Map<String, dynamic> json) {
    storyId = json['story_id'];
    mediaUrl = json['media_url'];
    mediaType = json['media_type'];
    timestamp = json['timestamp'];
    text = json['text'];
    textDescription = json['text_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['story_id'] = storyId;
    data['media_url'] = mediaUrl;
    data['media_type'] = mediaType;
    data['timestamp'] = timestamp;
    data['text'] = text;
    data['text_description'] = textDescription;
    return data;
  }
}
