

import 'package:brainhouse_i/model/DemoTicket.dart';

class TicketResponse{
  TicketResponse._();
  static const String STATUS_WAITING_TO_ACCEPT = "Awaiting Acceptance";
  static final String STATUS_IN_PROGRESS = "In Progress";
  static final String STATUS_PAUSE = "Paused";
  static final String STATUS_PASS = "Passed";
  static final String STATUS_SUSPEND = "Suspended";
  static final String STATUS_EXPERT_CLOSED = "Requested for Closing";
  static final String STATUS_CLOSED = "Closed";
}
class TicketCloseData{
  TicketCloseData._();
  static List tickets = [
  Ticket(
  ticketUID: "#brnhs2019010232-1234",
  companyName: "Vector It",
  jobDetail: "Need to configure NGINX web proxy server.",
  jobTitle: "AWS, Nginx",
  workRate: "10\$",
  currentHandler: "Rizvy Ahmed",
  createdAt: "23-01-2020",
  closedAt: "15-02-2020",
  status:TicketResponse.STATUS_CLOSED,
  lastStatus: "",
  skillGroupId: "AWS"),
  Ticket(
  ticketUID: "#brnhs2019010232-1234",
  companyName: "Vector It",
  jobDetail: "Need to configure NGINX web proxy server.",
  jobTitle: "AWS, Nginx",
  workRate: "10\$",
  currentHandler: "Rizvy Ahmed",
  createdAt: "23-01-2020",
  closedAt: "15-02-2020",
  status: TicketResponse.STATUS_CLOSED,
  lastStatus: "",
  skillGroupId: "AWS"),
  Ticket(
  ticketUID: "#brnhs2019010232-1234",
  companyName: "Vector It",
  jobDetail: "Need to configure NGINX web proxy server.",
  jobTitle: "AWS, Nginx",
  workRate: "10\$",
  currentHandler: "Rizvy Ahmed",
  createdAt: "23-01-2020",
  closedAt: "15-02-2020",
  status: TicketResponse.STATUS_CLOSED,
  lastStatus:
  "Configuration file is configured and tested in stage server.",
  skillGroupId: "AWS")
  ];

}