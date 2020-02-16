class userInfo{
  String firstname;
  String lastname;
  String email;
  String avatar;

  userInfo({this.firstname, this.lastname, this.email});

  userInfo.fromJson(Map<String, dynamic> map)
      :firstname=map['firstname'],
        lastname=map['lastname'],
  email=map['email'];


}
