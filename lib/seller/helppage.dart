import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milkdistributionflutter/MyServices.dart';
import 'package:http/http.dart' as http;
import 'package:milkdistributionflutter/model/VideoModel.dart';
import 'package:milkdistributionflutter/seller/MainPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class HelpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HelpPageState();
  }
}

class HelpPageState extends State<HelpPage> {
  String videoId = "", img_url = "", videoname = "";
  MyServices _myServices = MyServices();
  List<VideoModel> videoList;
  List<VideoModel> getvideolist;
  Future<List<VideoModel>> videofuture;

  @override
  void initState() {
    super.initState();
    videofuture = getVideoData();
  }

  String youtubeId(String url) {
    RegExp regExp = new RegExp(
      r'.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*',
      caseSensitive: false,
      multiLine: false,
    );
    Match match = regExp.firstMatch(url);

    if (match.groupCount >= 1) {
      videoId = regExp.firstMatch(url).group(1);
    }
    return videoId;
  }

  Future<void> _launchYoutubeVideo(String _youtubeUrl) async {
if (_youtubeUrl.isNotEmpty) {
  if (await canLaunch(_youtubeUrl)) {
    final bool _nativeAppLaunchSucceeded = await launch(
      _youtubeUrl,
      forceSafariVC: false,
      universalLinksOnly: true,
    );
    if (!_nativeAppLaunchSucceeded) {
      await launch(_youtubeUrl, forceSafariVC: true);
    }
  }
 }
}

  Future<List<VideoModel>> getVideoData() async {
    Map<String, String> JsonBody = {
      'CompanyId': _myServices.myCompanyId,
    };
    var response = await http.get(
        Uri.parse(_myServices.myUrl + "Video/GetVideoData"),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      videoList = List<VideoModel>.from((json.decode(response.body)['Response'])
          .map((i) => VideoModel.fromJson(i))).toList();
      VideoModel model;
      for (int i = 0; i < videoList.length; i++) {
        String videolink = videoList[i].Videolink;
        videoId = youtubeId(videolink);
        videoname = videoList[i].VideoName;
        img_url = "http://img.youtube.com/vi/" + videoId + "/0.jpg";
        VideoModel model = VideoModel(
            Id: videoId,
            VideoName: videoname,
            Videolink: videolink,
            ImageUrl: img_url);
        getvideolist.add(model);
      }
      return getvideolist;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.grey[100],
      ),
      body: WillPopScope(
        onWillPop: () {
          return Navigator.push(context, MaterialPageRoute(builder: ((context) => MainPage())));
        },
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Designed and Developed by',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sky Vision It Solutions',
                  style: GoogleFonts.aclonica(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B2B81)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.0,
                    color: Color(0xFF2B2B81),
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.whatshot_rounded),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: Text(
                              '7020334904',
                              style: GoogleFonts.alike(fontSize: 16.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(FontAwesomeIcons.envelope),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: Text(
                              'info@skyvisionitsolutions.com',
                              style: GoogleFonts.alike(fontSize: 16.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/1.8,
                margin: EdgeInsets.only(top: 20.0, bottom: 5.0),
                child: FutureBuilder<List<VideoModel>>(
                  future: videofuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done)
                      return Center(child: CircularProgressIndicator());
                    if (snapshot.hasData) {
                      List<VideoModel> getvideolist = snapshot.data;
                    }
                    return Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: getvideolist.length,
                        itemBuilder: (BuildContext context, int contextIndex) {
                          return Container(
                              width: MediaQuery.of(context).size.width,                            
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2.0,
                                  color: Color(0xFF2B2B81),
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(                                    
                                      width: MediaQuery.of(context).size.width,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                        Image.network(
                                          snapshot.data[contextIndex].ImageUrl),
                                        InkWell(
                                          onTap: () {
                                            _launchYoutubeVideo(snapshot.data[contextIndex].Videolink);
                                            // NetVideoPlayerScreen(
                                            //     videoUrl:
                                            //         snapshot.data[contextIndex].Videolink
                                            //   );
                                          },
                                          child: Icon(FontAwesomeIcons.circlePlay, size: 60.0,color: Color(0xFF2B2B81),)),
                                      ],)
                                          ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width,
                                        child: Text(
                                            snapshot.data[contextIndex].VideoName)),
                                  ),
                                ],
                              ),
                            );
                          
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
