
import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ClientProfile extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ClientProfile>
    with SingleTickerProviderStateMixin {
  String profileUrl="https://brainhouse.net/apiv2/client/profile";
  String updateProfileUri="https://brainhouse.net/apiv2/client/profile/all";
//  List<Language> _selectedLanguages = [];
//  String _selectedValuesJson = 'Nothing to show';
//  List<String>skilList=[];
//  List<String>cirtificationList=[];
  bool _status = true;
  bool isLoading=false;
  String token;
  String userId;
  String id,fristname,lastName,email,country,city,webAddress,companyName,postalCode,address,professionalOverview;

  TextEditingController fristNameController=new TextEditingController();
  TextEditingController lastNameController=new TextEditingController();
  TextEditingController emailController=new TextEditingController();
  TextEditingController webAddressCotroller=new TextEditingController();
  TextEditingController countryController=new TextEditingController();
  TextEditingController postalController=new TextEditingController();
  TextEditingController professionalOverviewController=new TextEditingController();
  TextEditingController addressController=new TextEditingController();
  TextEditingController cityController=new TextEditingController();
  TextEditingController companyNameController=new TextEditingController();
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
    fristname=response.data['data']['contact']['firstname'];
    lastName=response.data['data']['contact']['lastname'];
    email=response.data['data']['contact']['email'];
    city=response.data['data']['detail']['city'];
    country=response.data['data']['detail']['country'];
    webAddress=response.data['data']['detail']['website_address'];
    companyName=response.data['data']['detail']['company_name'];
    postalCode=response.data['data']['detail']['postalCode'];
    address=response.data['data']['detail']['address'];
    professionalOverview=response.data['data']['detail']['professionalOverview'];
    setState(() {
      fristNameController.value=TextEditingValue(text: fristname);
      lastNameController.value=TextEditingValue(text: lastName);
      emailController.value=TextEditingValue(text: email);
      companyNameController.value=TextEditingValue(text: companyName);
      webAddressCotroller.value=TextEditingValue(text: webAddress);
      if(address!=null){
        addressController.value=TextEditingValue(text: address);
      }
      if(postalCode!=null){
        postalController.value=TextEditingValue(text: postalCode);
      }
      if(city!=null){
        cityController.value=TextEditingValue(text: city);
      }
      if(country!=null){
        countryController.value=TextEditingValue(text: country);
      }


    });
    setState(() {
      isLoading=false;
    });
  }
  Future updateProfileData(String uEmail,String uLastName,String uFirstName
      ,String uPfover,String uPostal,String uCity,String uCountry,String company,
      String uAddress,String web)async{
    setState(() {
      isLoading=true;
    });
    getToken().then((value){
      token=value;
    });

    getUserId().then((value){
      userId=value;
    });
    Map contract={
      "email": uEmail,
      "lastname": uLastName,
      "firstname": uFirstName,
    };
    Map detail={
      "company_name":company,
      "website_address":webAddress,
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
      "contact":contract
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


  @override
  void initState() {
    // TODO: implement initState
    getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: AppTheme.nearlyWhite,
        body:isLoading?Center(child:CircularProgressIndicator()): new Container(
          color: AppTheme.nearlyWhite,
          child: new ListView(
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
                                        image: new ExactAssetImage(
                                            'assets/images/as.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 90.0, right: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new CircleAvatar(
                                      backgroundColor: Color(0xfffd9992),
                                      radius: 25.0,
                                      child: new Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
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
                                        'Client Information',
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
                                      controller:professionalOverviewController ,
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
                                        'Web Address',
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
                                      controller:webAddressCotroller,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Web Address"),
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
                                        'Company Name',
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
                                      controller: companyNameController,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Company Name"),
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
                                      controller: cityController,
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
                         /* Padding(
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
                                                    print("ex");
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
                                                    print("Supporting doc");
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
                                      ],
                                    )),

                              ],
                            ),
                          ),*/
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
                      updateProfileData(emailController.text, lastNameController.text,fristNameController.text,
                          professionalOverviewController.text,
                          postalController.text,cityController.text,countryController.text,
                          companyNameController.text, addressController.text,webAddressCotroller.text);
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
  /*void _showDialogCertification(BuildContext context) {
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
  }*/
 /* void _showDialogPost(BuildContext context) {
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
  }*/
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
