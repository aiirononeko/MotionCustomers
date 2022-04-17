class Customers {

  String _uid = '';
  String _points = '0';
  String _coffeeTickets = '0';
  bool _isPremium = false;

  Customers();

  String get uid => _uid;
  String get points => _points;
  String get coffeeTickets => _coffeeTickets;
  bool get isPremium => _isPremium;

  Customers.fromMap(Map<String, dynamic>? map) {
    _uid = map!['uid'];
    if (map['points'] < 10) {
      _points = '0${map['points'].toString()}';
    } else {
      _points = map['points'].toString();
    }
    if (map['coffeeTickets'] < 10) {
      _coffeeTickets = '0${map['coffeeTickets'].toString()}';
    } else {
      _coffeeTickets = map['coffeeTickets'].toString();
    }
    _isPremium = map['isPremium'];
  }
}
