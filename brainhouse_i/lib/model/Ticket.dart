class Ticket{

   static const int TYPE_STATUS_WAITING_TO_ACCEPT = 0;
   static final int TYPE_STATUS_IN_PROGRESS = 1;
   static final int TYPE_STATUS_PAUSE = 2;
   static final int TYPE_STATUS_PASS = 3;
   static final int TYPE_STATUS_SUSPEND = 4;
   static final int TYPE_STATUS_EXPERT_CLOSED = 5;
   static final int TYPE_STATUS_CLOSED = 6;

    static const String STATUS_WAITING_TO_ACCEPT = "Awaiting Acceptance";
    static final String STATUS_IN_PROGRESS = "In Progress";
    static final String STATUS_PAUSE = "Paused";
    static final String STATUS_PASS = "Passed";
    static final String STATUS_SUSPEND = "Suspended";
    static final String STATUS_EXPERT_CLOSED = "Requested for Closing";
    static final String STATUS_CLOSED = "Closed";

    static final String SERVER_STATUS_WAITING_TO_ACCEPT = "Waiting to Accept";
    static final String SERVER_STATUS_IN_PROGRESS = "In Progress";
    static final String SERVER_STATUS_PAUSE = "PAUSE";
    static final String SERVER_STATUS_PASS = "PASS";
    static final String SERVER_STATUS_SUSPEND = "SUSPEND";
    static final String SERVER_STATUS_EXPERT_CLOSED = "EXPERT_CLOSED";
    static final String SERVER_STATUS_CLOSED = "CLOSED";

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