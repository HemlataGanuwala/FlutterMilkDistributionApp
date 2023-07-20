import 'dart:ffi';

class VideoModel{
  String? Id;  
  String? Videolink = "";
  String? VideoName = "";
  String? ImageUrl = "";
   

  VideoModel({this.Id,this.Videolink,this.VideoName,this.ImageUrl});

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    Id: json['Id'].toString(),
    Videolink: json['VideoLink'],
    VideoName: json['VideoName'],         
  );

  Map<String, dynamic> toJson() => {
    'Id': Id,
    'VideoLink':Videolink,    
    'VideoName':VideoName,
      
  };


}