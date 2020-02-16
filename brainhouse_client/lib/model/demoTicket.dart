class Ticket{
  String id;
  String chatKey;
  String ticketUID;
  String firstName;
  String lastName;
  int clientId;
  String clientName;
  String companyName;
  String email;
  String jobTitle;
  String skillGroupId;
  String skillGroupName;
  int serviceId;
  String serviceName;
  String workRate;
  String jobDetail;
  String currentHandler;
  String createdAt;
  String modified;
  String closedAt;
  int statusType;
  String status;
  String serverStatus;
  String workHistory;
  String conversionHistory;
  //List<AuditTrail> auditTrailList;
  String lastStatus;

  Ticket({this.ticketUID, this.companyName, this.jobTitle, this.skillGroupId,
    this.workRate, this.jobDetail, this.currentHandler, this.createdAt,
    this.closedAt, this.status, this.lastStatus});
}