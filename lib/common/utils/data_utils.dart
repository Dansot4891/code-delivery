import 'package:authentication/common/const/data.dart';

class DataUtils{
  static String pathToUrl(String val){
    return 'http://$ip$val';
  }

  static List<String> listPathsToUrls(List paths){
    return paths.map((e) => pathToUrl(e)).toList();
  }
}