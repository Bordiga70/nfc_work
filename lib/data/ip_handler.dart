import 'notifiers.dart' as Notifiers;

class IpHandler {
  //  TODO handle wrong input
  void format(String ip) {
    final List<String> split = ip.split(':');

    /*
    final List<String> digits = split[0].split(".");

    if (digits.length != 4) {
      print('Invalid IP length');
      return;
    }
    */

    Notifiers.ip.value = split.first;
    Notifiers.port.value = split.last;
  }
}
