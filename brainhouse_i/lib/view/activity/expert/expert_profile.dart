import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:brainhouse_i/view/activity/expert/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class ExpertProfile extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ExpertProfile>
    with SingleTickerProviderStateMixin {
  BuildContext context;
  String imageUrl;
  String profileUrl="https://brainhouse.net/apiv2/expert/profile";
  String updateProfileUri="https://brainhouse.net/apiv2/expert/profile/all";
  FirebaseStorage _storage = FirebaseStorage.instance;
  List<Language> _selectedLanguages = [];
  String _selectedValuesJson = 'Nothing to show';
  List<String>skilList=[];
  List<String>cirtificationList=[];
  List<String>experienceList=[];
  List<String>documentList=[];
  bool _status = true;
  bool isLoading=false;
  String token;
  String userId;
  String fileName,fileUrl;
  var temFile;
  String id,fristname,lastName,email,city,address,mobile,country
  ,postalCode,prfOver,skill,certification,experience,documents;

  static  DateTime now = DateTime.now();
  String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);
  static var uuid = Uuid();
  var uidProfilePic=uuid.v4(options: {
    'rng': UuidUtil.cryptoRNG
  });

  TextEditingController fristNameController=new TextEditingController();
  TextEditingController lastNameController=new TextEditingController();
  TextEditingController emailController=new TextEditingController();
  TextEditingController skillController=new TextEditingController();
  TextEditingController certificationDailog=new TextEditingController();
  TextEditingController experienceDailog=new TextEditingController();
  TextEditingController experienceController=new TextEditingController();
  TextEditingController mobileCotroller=new TextEditingController();
  TextEditingController countryController=new TextEditingController();
  TextEditingController postalController=new TextEditingController();
  TextEditingController professionalOverviewController=new TextEditingController();
  TextEditingController addressController=new TextEditingController();
  TextEditingController cityController=new TextEditingController();
  TextEditingController certificationController=new TextEditingController();
  TextEditingController supportingDocController=new TextEditingController();
  final FocusNode myFocusNode = FocusNode();

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  Future<String> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }


  Future getProfileData()async{
    setState(() {
      isLoading=true;
    });
    getToken().then((value){
      token=value;
    });
    getUserId().then((value){
      userId=value;
    });
    var dio = await Dio();
    dio.options.baseUrl = profileUrl;
    dio.options.headers = {
      "Authorization": "Bearer $token"
    };
    Response response = await dio.get("/$userId");
    print(response.data['data'].toString());
    id=response.data['data']['id'];
    fristname=response.data['data']['detail']['firstname'];
    lastName=response.data['data']['detail']['lastname'];
    email=response.data['data']['detail']['email'];
    mobile=response.data['data']['detail']['mobile'];
    country=response.data['data']['detail']['country'];
    address=response.data['data']['detail']['address'];
    prfOver=response.data['data']['detail']['professionalOverview'];
    postalCode=response.data['data']['detail']['postalCode'];
    city=response.data['data']['detail']['city'];
    skill=response.data['data']['skills'].toString();
    certification=response.data['data']['certifications'].toString();
    experience=response.data['data']['experiences'].toString();
    setState(() {

      fristNameController.value=TextEditingValue(text: fristname);
      lastNameController.value=TextEditingValue(text: lastName);
      emailController.value=TextEditingValue(text: email);
      mobileCotroller.value=TextEditingValue(text: mobile);
      if(city!=null){
        cityController.value=TextEditingValue(text: city);
      }
      if(country!=null){
        countryController.value=TextEditingValue(text: country);
      }
      if(postalCode!=null){
        postalController.value=TextEditingValue(text: postalCode);
      }
      if(prfOver!=null){
        professionalOverviewController.value=TextEditingValue(text: prfOver);
      }
      if(address!=null){
        addressController.value=TextEditingValue(text: address);
      }
      if(skill!=null) {
        skillController.value = TextEditingValue(text: skill.toString());
      }
      if(certification!=null){
        certificationController.value=TextEditingValue(text: certification.toString());
      }
      if(experience!=null){
        experienceController.value=TextEditingValue(text: experience.toString());
      }

    });
    setState(() {
      isLoading=false;
    });
  }

  Future updateProfileData(String uEmail,String uMobile,String uLastName,String uFirstName
      ,String uPfover,String uPostal,String uCity,String uCountry,
      String uAddress,List uSkill,List uCertification,List uExperience,List uDocument)async{
    setState(() {
      isLoading=true;
    });
    getToken().then((value){
      token=value;
    });

    getUserId().then((value){
      userId=value;
    });
    Map detail={
      "email": uEmail,
      "mobile": uMobile,
      "lastname": uLastName,
      "firstname": uFirstName,
      "professionalOverview":uPfover,
      "postalCode":uPostal,
      "city": uCity,
      "address":uAddress,
      "country": uCountry
    };
    Map data={
      "id":id,
      "user_id":userId,
      "detail":detail,
      "skills":uSkill,
      "certifications":uCertification,
      "experiences":uExperience,
      "documents":uDocument
    };
    var dio = await Dio();
    dio.options.baseUrl = updateProfileUri;
    dio.options.headers = {
      "Authorization": "Bearer $token"
    };
    if(id!=null){
      Response response = await dio.put("/$id", data:data);
      print(response.data.toString());
    }
    setState(() {
      getProfileData();
      isLoading=false;
    });
  }



  Future uploadPic() async {

    //Get the file from the image picker and store it
    File image = await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 500,maxWidth:500,imageQuality: 85 );
    String fileName = basename(image.path);
    //Create a reference to the location you want to upload to in firebase
    StorageReference reference = _storage.ref().child("profile_image/$fileName");

    //Upload the file to firebase
    StorageUploadTask uploadTask = reference.putFile(image);

    // Waits till the file is uploaded then stores the download url
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    imageRefFirestore(url);
    //returns the download url
    setState(() {
      getimage();
    });

  }
  void imageRefFirestore(String url)async{
    getUserId().then((value){
      userId=value;
    });
    Map<String,dynamic> tasks={
      "avatar":url,

    };
    DocumentReference ds=Firestore.instance.collection('ExpertProfile').document(userId)
        .collection('ProfileImage').add({
      "avatar":url,
    }) as DocumentReference ;

  }

  Future getimage() async {
    getUserId().then((value) {
      userId = value;
    });
    var firestore = Firestore.instance;
    firestore.collection('ExpertProfile').getDocuments().then((querySnapshot){
      firestore.collection('ExpertProfile').document(userId)
          .collection('ProfileImage').getDocuments().then((querySnapshot){
        querySnapshot.documents.forEach((result){
          print(result.data);
          setState(() {
            imageUrl=result.data['avatar'].toString();
          });
        });
      });
    });
  }
  Future getFile() async {
    getUserId().then((value) {
      userId = value;
    });
    var firestore = Firestore.instance;
    firestore.collection('ExpertProfile').getDocuments().then((querySnapshot){
      firestore.collection('ExpertProfile').document(userId)
          .collection('supporting_document').getDocuments().then((querySnapshot){
        querySnapshot.documents.forEach((result){
          print(result.data);
          setState(() {
            fileUrl=result.data['attachment'].toString();
          });
        });
      });
    });
  }
  Future getfileAndUpload()async{
    var rng = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    File file = await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: 'pdf');
    fileName =  basename(file.path);
    print(fileName);
    setState(() {
      documentList.add(fileName);
      supportingDocController.value=TextEditingValue(text: fileName);
    });
    print('${file.readAsBytesSync()}');
    savePdf(file.readAsBytesSync(), fileName);
    setState(() {
      getFile();
    });
  }
  Future savePdf(List<int> asset, String name) async {

    StorageReference reference = FirebaseStorage.instance.ref().child(name);
    StorageUploadTask uploadTask = reference.putData(asset);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url);
    documentFileUpload(url,fileName);
    return  url;
  }
  void documentFileUpload(String str,String fineName) {

    DocumentReference ds=Firestore.instance.collection('ExpertProfile').document(userId).collection('supporting_document').document(uidProfilePic);
    Map<String,dynamic> tasks={
      "fileName":fileName,
      "attachment":str,
    };

    ds.setData(tasks).whenComplete((){
      print("task updated");
    });
  }

  Future<bool> checkPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
  inti(String url,String file) async {
    await checkPermission();
    final directory = await getExternalStorageDirectory();
    FlutterDownloader.initialize();
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: directory.path,
      fileName:file ,
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
    FlutterDownloader.initialize();
    FlutterDownloader.registerCallback((id, status,progress) {
      print(
          'Download task ($id) is in status ($status) and process ($progress)');
    });
    return taskId;
  }

  @override
  void initState() {
    // TODO: implement initState
    getimage();
    getFile();
    getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: AppTheme.nearlyWhite,
        body: new Container(
          color: AppTheme.nearlyWhite,
          child: isLoading?Center(child:CircularProgressIndicator()):new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 250.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.only(top: 60.0),
                          child: new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        image: ExactAssetImage(
                                          'assets/images/as.png'
                                            ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                )

                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 90.0, right: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new GestureDetector(
                                      onTap:(){
                                        try{
                                          uploadPic();
                                        }catch(e){
                                          print(e.toString());
                                        }
                                      },
                                        child: CircleAvatar(
                                          backgroundColor: Color(0xfffd9992),
                                          radius: 25.0,
                                          child: new Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                          ),
                                        )
                                    )
                                  ],
                                )),
                          ]),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Expert Information',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status ? _getEditIcon() : new Container(),
                                    ],
                                  )
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'Frist Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'Last Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: new TextField(
                                        controller: fristNameController,
                                        style: TextStyle(fontSize: 25,color: AppTheme.nearlyBlack),
                                        decoration: const InputDecoration(
                                            hintText: "Enter First Name"),
                                        enabled: !_status,
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: new TextField(
                                      controller: lastNameController,
                                      style: TextStyle(fontSize: 25,color: AppTheme.nearlyBlack),
                                      decoration: const InputDecoration(
                                          hintText: "Enter Last Name"),
                                      enabled: !_status,
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Professional Overview ',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),

                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller: professionalOverviewController,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Professional Overview"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 30.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Contract Info ',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Email',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller:emailController,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Email"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Mobile',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller:mobileCotroller,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Phone number"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Address',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),

                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller: addressController,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Address"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'Postal Code',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'City',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: new TextField(
                                        controller: postalController,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Postal Code"),
                                        enabled: !_status,
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: new TextField(
                                      controller:cityController,
                                      decoration: const InputDecoration(
                                          hintText: "Enter city"),
                                      enabled: !_status,
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Country',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller:countryController,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Country"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),

                          SizedBox(height: 20,),
                          Padding(
                            padding: EdgeInsets.only(bottom: 25.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Skill',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        new Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            GestureDetector(
                                                child: new CircleAvatar(
                                                  backgroundColor: Color(0xfffd9992),
                                                  radius: 14.0,
                                                  child: new Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                    size: 16.0,
                                                  ),
                                                ),
                                                onTap: (){
                                                  if(!_status){
                                                    skilList.clear();
                                                    _showDialogPost(context);
                                                  }
                                                }
                                            )
                                          ],
                                        )
                                      ],
                                    )),

                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 12.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            textAlign: TextAlign.center,
                                            controller: skillController,
                                            enabled: !_status,
                                            decoration: new InputDecoration(
                                              hintText: 'No Skill',
                                              border: new OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(
                                                  const Radius.circular(0.0),
                                                ),
                                                borderSide: new BorderSide(
                                                  color: AppTheme.nearlyBlack,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(bottom: 25.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Certifications',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        new Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            GestureDetector(
                                                child: new CircleAvatar(
                                                  backgroundColor: Color(0xfffd9992),
                                                  radius: 14.0,
                                                  child: new Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 16.0,
                                                  ),
                                                ),
                                                onTap: (){
                                                  if(!_status){
                                                    _showDialogCertification(context);
                                                  }
                                                }
                                            )
                                          ],
                                        )
                                      ],
                                    )),

                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 12.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            controller:certificationController,
                                            textAlign: TextAlign.center,
                                            enabled: !_status,
                                            decoration: new InputDecoration(
                                              hintText: 'No Certifications',
                                              border: new OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(
                                                  const Radius.circular(0.0),
                                                ),
                                                borderSide: new BorderSide(
                                                  color: AppTheme.nearlyWhite,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(bottom: 25.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Experiences',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        new Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            GestureDetector(
                                                child: new CircleAvatar(
                                                  backgroundColor: Color(0xfffd9992),
                                                  radius: 14.0,
                                                  child: new Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 16.0,
                                                  ),
                                                ),
                                                onTap: (){
                                                  if(!_status){
                                                    _showDialogExperience(context);
                                                  }
                                                }
                                            )
                                          ],
                                        )
                                      ],
                                    )),

                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 12.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            controller: experienceController,
                                            textAlign: TextAlign.center,
                                            enabled: !_status,
                                            decoration: new InputDecoration(
                                              hintText: 'No Experience added',
                                              border: new OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(
                                                  const Radius.circular(0.0),
                                                ),
                                                borderSide: new BorderSide(
                                                  color: AppTheme.nearlyWhite,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 25.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Supporting Document',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        new Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            GestureDetector(
                                                child: new CircleAvatar(
                                                  backgroundColor: Color(0xfffd9992),
                                                  radius: 14.0,
                                                  child: new Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 16.0,
                                                  ),
                                                ),
                                                onTap: () {
                                                  if(!_status){
                                                    _showFilePikerDialog(context);


                                                  }
                                                }
                                            )
                                          ],
                                        )
                                      ],
                                    )),

                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 12.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            controller:supportingDocController,
                                            textAlign: TextAlign.center,
                                            enabled: !_status,
                                            decoration: new InputDecoration(
                                              hintText: 'No Documents',
                                              border: new OutlineInputBorder(
                                                borderRadius: const BorderRadius.all(
                                                  const Radius.circular(0.0),
                                                ),
                                                borderSide: new BorderSide(
                                                  color: AppTheme.nearlyWhite,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.only(left: 10),
                                        child: new OutlineButton(
                                            child: new Text("Download"),
                                            onPressed: (){
                                              try{
                                                //downloadFile(post.data['attachment'].toString(), post.data['fileName'].toString());
                                                inti(fileUrl,fileName);
                                                ;
                                              }catch(e){
                                                e.toString();
                                              }
                                            },
                                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))
                                        ))

                                      ],
                                    )),

                              ],
                            ),
                          ),
                          !_status ? _getActionButtons() : new Container(),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ));
  }
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Save"),
                    textColor: Colors.white,
                    color: Color(0xff7092be),
                    onPressed: () {
                      setState(() {
                        updateProfileData(emailController.text, mobileCotroller.text, lastNameController.text, fristNameController.text,
                            professionalOverviewController.text, postalController.text,cityController.text, countryController.text,
                            addressController.text, skilList, cirtificationList, experienceList,documentList);
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Cancel"),
                    textColor: Colors.white,
                    color: Color(0xfffd9992),
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Color(0xfffd9992),
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
  void _showDialogCertification(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Padding(
              padding: EdgeInsets.only(left: 5.0,right: 5.0),
              child:Container(
                child: new TextField(
                  controller:certificationDailog,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                  decoration: new InputDecoration(
                    hintText: 'Eg."HSC","SSC"',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),

                  ),
                ),
              ) ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            FlatButton(
              color: AppTheme.bh,
              onPressed: () {
                setState(() {
                  cirtificationList.add(certificationDailog.text);
                  certificationController.value=TextEditingValue(text: cirtificationList.toString());
                });
                print(cirtificationList.toString());
                Navigator.pop(context);

              },
              child: Text(
                'Ok',
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
            )
          ],
        );
      },
    );
  }
  void _showFilePikerDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Center(child:new OutlineButton(
              child: new Text("Chose file"),
              onPressed:(){
                try{
                  getfileAndUpload();

                  Navigator.of(context).pop();
                }catch(e){
                  e.toString();
                  print("excep"+e.toString());
                }
              },
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0))
          ),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }
  void _showDialogExperience(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Padding(
              padding: EdgeInsets.only(left: 5.0,right: 5.0),
              child:Container(
                child: new TextField(
                  controller:experienceDailog,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                  decoration: new InputDecoration(
                    hintText: 'Eg."1 year in java"',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),

                  ),
                ),
              ) ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            FlatButton(
              color: AppTheme.bh,
              onPressed: () {
                setState(() {
                  experienceList.add(experienceDailog.text);
                  experienceController.value=TextEditingValue(text: experienceList.toString());
                });
                print(experienceDailog.toString());
                Navigator.pop(context);

              },
              child: Text(
                'Ok',
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
            )
          ],
        );
      },
    );
  }
  void _showDialogPost(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: FlutterTagging<Language>(
              initialItems: _selectedLanguages,
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.green.withAlpha(30),
                  hintText: 'Search Tags',
                  labelText: 'Select Tags',
                ),
              ),
              findSuggestions: LanguageService.getLanguages,
              additionCallback: (value) {
                return Language(
                    name: value
                );
              },
              onAdded: (language){
                // api calls here, triggered when add to tag button is pressed
                return ;
              },
              configureSuggestion: (lang) {
                return SuggestionConfiguration(
                  title: Text(lang.name),
                  additionWidget: Chip(
                    avatar: Icon(
                      Icons.add_circle,
                      color: Colors.white,
                    ),
                    label: Text('Add New Tag'),
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              configureChip: (lang) {
                return ChipConfiguration(
                  label: Text(lang.name),
                  backgroundColor: Colors.green,
                  labelStyle: TextStyle(color: Colors.white),
                  deleteIconColor: Colors.white,
                );
              },
              onChanged: () {
                setState(() {
                  _selectedValuesJson=_selectedLanguages.map<String>((lang) => '${'"'+lang.toJson()+'"'}').toList()
                      .toString();

                });
                _selectedValuesJson=_selectedValuesJson.replaceAll("[","");
                _selectedValuesJson=_selectedValuesJson.replaceAll("]","");
                print(_selectedValuesJson.toString());
              }
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            FlatButton(
              color: AppTheme.bh,
              onPressed: () {
                print(_selectedValuesJson.toString());
                setState(() {
                  if(_selectedValuesJson.isEmpty){
                    skillController.value=TextEditingValue(text: "No Skills");
                  }
                  skillController.value=TextEditingValue(text: _selectedValuesJson.toString());
                  skilList.add(_selectedValuesJson);
                });
                print(skilList.toString());
                _selectedLanguages.clear();
                Navigator.pop(context);

              },
              child: Text(
                'Update',
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
            )
          ],
        );
      },
    );
  }
}

class LanguageService {
  /// Mocks fetching language from network API with delay of 500ms.
  static Future<List<Language>> getLanguages(String query) async {
    await Future.delayed(Duration(milliseconds: 500), null);
    return <Language>[
      Language(name: 'JavaScript'),
      Language(name: 'Python'),
      Language(name: 'Java'),
      Language(name: 'PHP'),
      Language(name: 'C#'),
      Language(name: 'C++'),
    ].where((lang) => lang.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
class Language extends Taggable{
  String name;

  Language({this.name});

  @override
  // TODO: implement props
  List<Object> get props =>[name];

  String toJson() => "$name";

}
