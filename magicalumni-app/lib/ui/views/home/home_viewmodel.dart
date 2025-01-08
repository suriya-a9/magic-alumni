import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:magic_alumni/app/app.router.dart';
import 'package:magic_alumni/model/alumni_model.dart';
import 'package:magic_alumni/model/news_model.dart';
import 'package:magic_alumni/service/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

enum DialogType {custom}

class HomeViewmodel extends BaseViewModel {
  int selectedIndex = 0;

  List<NewsModel> newsList = [];
  /// Use API Service to get the news from the API
  final ApiService apiService = ApiService();

  final NavigationService _navigationService = locator<NavigationService>();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final DialogService diologService = locator<DialogService>();

  AlumniModel? alumni;

  /// Select the college card
  void selectOtherCollege(int value){
    selectedIndex = value;
    notifyListeners();
  }

  /// Call the news API and store if the news get from the API or return empty list
  Future<void> news() async {
    if (newsList.isEmpty) {
      apiService.news().then(
        (value) {
          newsList = value;
          notifyListeners();
        } ,
      );
    }
  }

  Future<void> init() async {
    String alumniId = await storage.read(key: "alumni_id") ?? "";
    alumni = AlumniModel.fromJson(json.decode(await storage.read(key: alumniId) ?? ""));
    notifyListeners();
  }

  void navigateToNewsDetail(NewsModel news, int index) 
    => _navigationService.navigateToNewsDetailView(news: news, index: index);

  void showDialog()
    => diologService.showCustomDialog(
      variant: DialogType.custom,
      title: alumni!=null ? alumni!.alumniProfileDetail.name : "",
      description: "Your request is not approved by the college"
    );
  
}