import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../viewmodels/sausage_view_model.dart';

/* THis class is the Shared preference Service singleton
to instantiate the class only one time which handles the fetching
deleting, and saving part of the data in shared preference */

class SharedPreferencesService {
  static late SharedPreferences _prefs;
  static const sausageData = "data_store";

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance => _prefs;

  // fetching sausages from shared preference
  Future<List<SausageRollViewModel>> fetchSausages() async {
    final String? rawJson = _prefs.getString(sausageData);
    if (rawJson != null) {
      final decodeJson = json.decode(rawJson) as List<dynamic>;
      Iterable<SausageRollViewModel> sausageList =
          decodeJson.map<SausageRollViewModel>(
              (item) => SausageRollViewModel.fromJson(item));
      return sausageList.toList();
    }
    return [];
  }

  // saving sausages from shared preference
  Future<void> saveSausage(SausageRollViewModel sausageRollViewModel) async {
    try {
      var sausageList = await fetchSausages();
      if (sausageList.isNotEmpty) {
        sausageList.add(sausageRollViewModel);
      } else {
        sausageList = [sausageRollViewModel];
      }
      final result = await saveSausageList(sausageList);
      if (!result) {
        return Future.error(Exception("Save failed"));
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  // saving sausages list to shared preference
  Future<bool> saveSausageList(List<SausageRollViewModel> sausageList) async {
    try {
      final List<Map<String, dynamic>> jsonSausageList =
          sausageList.map((sausage) => sausage.toJson()).toList();
      String sampleStringList = jsonEncode(jsonSausageList);
      return await _prefs.setString(sausageData, sampleStringList);
    } catch (e) {
      return Future.error(e);
    }
  }

  // clearing data from shared preference
  Future<bool> clearData() async {
    try {
      return await _prefs.remove(sausageData);
    } catch (e) {
      return Future.error(e);
    }
  }
}
