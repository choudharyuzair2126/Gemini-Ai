import 'dart:typed_data';

class AIModel {
  bool? isUser;
  String? text;
  List<Uint8List>? images;

  AIModel({this.isUser, this.text, this.images});

  AIModel.fromJson(Map<String, dynamic> json) {
    isUser = json['is_user'];
    text = json['text'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_user'] = isUser;
    data['text'] = text;
    data['images'] = images;
    return data;
  }
}
