class Glob {
  static Glob _instance;
  factory Glob() => _instance ??= new Glob._();
  Glob._();
  String Userrole="";
  List sites =[];
  String pickkedvideo="";
  String currentpage="";
  String totalsites='0';
  String totalonlinesite='0',totalofflinesite='0';
  List projects= [];
      String logintoken='';
      String projectname="";
  String projectids="";
  String selectedprojectid="";
  String selectedSiteId="";
  String selectedbankname="";
  Map<String,dynamic> ticketstatus =new Map<String,dynamic>();
  Map<String,dynamic> actionstatus =new Map<String,dynamic>();
  Map<String,dynamic> incidentstatus =new Map<String,dynamic>();

  String getServerUrl(){
    return 'https://ncrsbiinnitiate.aparinnosys.com/rest';
  }
  String getLoginUrl(){
    return getServerUrl()+ '/api/Mobile/Login';
  }
  String getappliancecontrol(){
    return getServerUrl()+'/api/Mobile/ApplianceControl/';
  }
  String getSites(){
    return getServerUrl()+'/api/Mobile/AllSiteDetails';
  }
  String getTicketCount(){
    return getServerUrl()+'/api/Mobile/SiteTicketDashboard';
  }
  String getCameraDetails(){
    return getServerUrl()+"/api/Mobile/GetAllCamera";
  }
  String getcameraageing(){
    return getServerUrl()+"/api/Mobile/GetCameraIssuesDetails";
  }
  String getincidentdetails(){
    return getServerUrl()+"/api/Mobile/GetIncidentCategoryList";
  }
  String getSensorDetailslist(){
    return getServerUrl()+"/api/Mobile/GetSiteSensorlist/";
  }
  String getVideoDetails(){
    return getServerUrl()+"/api/Mobile/SiteFileNames";
  }
  String getbulgaryreport(){
    return getServerUrl()+"/api/Mobile/GetCloseTicketDetails";
  }
  String getincidentreport(){
    return getServerUrl()+"/api/Mobile/GetIncidentCategoryReport";
  }
  String getVideoDownload(){
    return getServerUrl()+"/api/Mobile/DownloadVideo";
  }
  String getallsitesstatus(){
return getServerUrl()+"/api/Mobile/GetSiteStatus";
  }
  String getsitedetails(){
    return getServerUrl() +"/api/Mobile/GetSpecificSite/";
  }
  String getsensordetails(){
    return getServerUrl() +"/api/Mobile/GetSensorDetails/";
  }
String getattendencedeatils(){
    return getServerUrl() +"/api/Mobile/GetAttendanceDetails/";
}
String getcontactdetails(){
    return getServerUrl() +"/api/Mobile/GetContactDetails/";
}
  String postcomplaint(){
    return getServerUrl() +"/api/Mobile/InsertComplaint";
  }
  String getappliance(){
    return getServerUrl() +"/api/Mobile/GetApplianceControl/";
  }
  String getsitestatus(){
    return getServerUrl() +"/api/Mobile/GetSiteAmbiance/";
  }
  String getsitetcktcount(){
    return getServerUrl() +"/api/Mobile/GetTicketDetails/";
  }
  String getAnnouncement(){
    return getServerUrl() +"/api/Mobile/PlayAudioCommand/";
  }

}