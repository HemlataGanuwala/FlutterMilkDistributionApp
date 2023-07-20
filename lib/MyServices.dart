class MyServices {

  static final MyServices _instance = MyServices._internal();

  // passes the instantiation to the _instance object
  factory MyServices() => _instance;

  //initialize variables in here
  MyServices._internal() {
    // _myUrl = "http://192.168.0.178:8088/api/";
    _myUrl = "http://evmilkapi.skyvisionitsolutions.com/api/";
    _companyId = "";
    _isLoggedIn = false;
    _buyerCompanyId = "";
    _milkCompanyId = "";
    _videostatus = false;
    _milkPin = "";
  }

  String? _myUrl;
  String? _companyId;
  bool? _isLoggedIn;
  String? _buyerCompanyId;
  String? _milkCompanyId;
  String? _firstname;
  String? _mobileno;
  bool? _videostatus;
  String? _milkPin;
  String? _buyerPin;

  //short getter for my variable
  String? get myUrl => _myUrl;
  //short setter for my variable
  set myUrl(String? value) => _myUrl = value;

  String? get myCompanyId => _companyId;
  set myCompanyId(String? value) => _companyId = value;

  bool? get myLoggedIn => _isLoggedIn;
  set myLoggedIn(bool? value) => _isLoggedIn = value;

  String? get myBuyerCompanyId => _buyerCompanyId;
  set myBuyerCompanyId(String? value) => _buyerCompanyId = value;

  String? get myMilkCompanyId => _milkCompanyId;
  set myMilkCompanyId(String? value) => _milkCompanyId = value;

  String? get myFirstname => _firstname;
  set myFirstname(String? value) => _firstname = value;

  String? get myMobileno => _mobileno;
  set myMobileno(String? value) => _mobileno = value;

  bool? get myVideoStatus => _videostatus;
  set myVideoStatus(bool? value) => _videostatus = value;

  String? get myMilkPin => _milkPin;
  set myMilkPin(String? value) => _milkPin = value;

  String? get myBuyerPin => _buyerPin;
  set myBuyerPin(String? value) => _buyerPin = value;

  void myglobalUrl() => _myUrl;
  void myglobalCompanyid() => _companyId;
  void myglobalBuyerCompid() => _buyerCompanyId;
  void myglobalMilkCompid() => _milkCompanyId;
  void myglobalMilkPin() => _milkPin;
  void myglobalBuyerPin() => _buyerPin;

}
