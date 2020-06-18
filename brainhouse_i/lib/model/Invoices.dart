class Invoice{
  bool paymentFlag;
  int serviceRate;
  String paymentDate;
  int expertId;
  String serviceHour;
  String totalBill;
  String billiingDate;
  String clientName;
  int ticketId;
  int clientId;
  int id;
  String invoiceNumber;
  String expertName;
  String clientWebAddress;
  String clientCompanyName;
  String ticketJobTitle;
  bool hasCustomerId;

  Invoice({this.serviceRate, this.serviceHour, this.totalBill, this.billiingDate,
      this.invoiceNumber, this.expertName, this.clientWebAddress,
      this.clientCompanyName, this.ticketJobTitle});

}