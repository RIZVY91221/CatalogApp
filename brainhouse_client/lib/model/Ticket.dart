class Ticket{

    String id;
    String ticketno;
    String title;
    String tags;
    int  serviceid;
    String description;

   Ticket({this.id,this.ticketno,this.title, this.tags, this.serviceid, this.description});

   Ticket.fromJson(Map<String,dynamic>json){
     id=json['id'] ;
     ticketno= json['ticketno'];
     title=json['detail']['title'] ;
     tags=json['detail']['tags'];
     serviceid= json['detail']['serviceid'];
     description=json['detail']['description'];
   }
   Map<String,dynamic>toJson(){
     var map = new Map<String, dynamic>();
     map['id']=id;
     map['ticketno']=ticketno;
     if(title!=null){
       map['title']=title;
     }

     map['tags']=tags;
     map['serviceid']=serviceid;
     map['description']=description;
     return map;
   }


}