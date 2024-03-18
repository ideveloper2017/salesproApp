import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/user_role_model.dart';


// getCurrency() async {
//   final prefs = await SharedPreferences.getInstance();
//   String? data = prefs.getString('currency');
//   if(data.isEmptyOrNull ){
//     currency = data!;
//   }
// }



String currency = '\$';
String currencyName = 'United States Dollar';





// List<String> items = [
//   '\$ (US Dollar)',
//   '৳ (Taka)',
//   "₹ (Rupee)",
//   "€ (Euro)",
//   "₽ (Ruble)",
//   "£ (UK Pound)",
//   "R (Rial)",
//   "؋( Af ⁄ Afs)",
//   "₺ (Turkish lira)",
//   "¥ (Japanese yen)",
//   "RON (Romanian leu)",
//   "₫ (Dong)",
//   "฿ (Baht)",
//   "zł (Polish złoty)",
//   "Ft (Forint)",
//   "₩ (Korean won)",
//   "RM (Malaysian Ringgit)",
//   "Rp (rupiah)",
//   "₴ (Ukrainian hryvnia)",
//   "KM (Bosnia-Herzegovina)",
//   "Rs (Pakistani rupee)",
//   "LKR (Sri Lankan Rupee)",
//   "﷼(Iranian Rial)",
//   "KHR (Cambodian riel)",
//   "LAK (Laotian Kip)",
//   "ZAR (Rand)",
//   "SEK (Swedish Krona)",
//   "ALL (Albanian Lek)",
//   "CHF (Swiss Franc)",
//   "AZN (Azerbaijani Manat)",
//   "₸ (Kazakhstani Tenge)",
//   "NPR (Nepalese Rupee)",
//   "K (Myanmar Kyat)",
//   "RMB(Renminbi)",
//   "Tsh (TZ Shillings)",
// ];

List<String> items = [
  '\$ (US Dollar)',
  "so`m (Uzbekistan Som)",
  "руб (Russian Ruble)",
];

// String localCurrency = 'Tsh';

// List<String> items = [
//   'Tsh (TZ Shillings)',
//   '\$ (US Dollar)',
//   ];

String constUserId = '';
bool isSubUser = false;
String subUserTitle = '';
String subUserEmail = '';
bool isSubUserDeleted = true;
//
String userPermissionErrorText = 'Access not granted';

UserRoleModel finalUserRoleModel = UserRoleModel(
  email: '',
  userTitle: '',
  databaseId: '',
  salePermission: true,
  partiesPermission: true,
  purchasePermission: true,
  productPermission: true,
  profileEditPermission: true,
  addExpensePermission: true,
  lossProfitPermission: true,
  dueListPermission: true,
  stockPermission: true,
  reportsPermission: true,
  salesListPermission: true,
  purchaseListPermission: true,
);

class CurrentUserData {
  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    constUserId = prefs.getString('userId') ?? '';
    isSubUser = prefs.getBool('isSubUser') ?? false;
    subUserEmail = prefs.getString('subUserEmail') ?? '';
    await updateData();
  }

  Future<void> updateData() async {
    final prefs = await SharedPreferences.getInstance();
    final ref = FirebaseDatabase.instance.ref(constUserId).child('User Role');
    ref.keepSynced(true);
    ref.orderByKey().get().then(
      (value) async {
        for (var element in value.children) {
          var data = UserRoleModel.fromJson(jsonDecode(jsonEncode(element.value)));
          if (data.email == subUserEmail) {
            isSubUserDeleted = false;
            finalUserRoleModel = data;
            await prefs.setString('userTitle', data.userTitle);
            subUserTitle = prefs.getString('userTitle') ?? '';
          }
        }
      },
    );
  }

  Future<bool> isSubUserEmailNotFound() async {
    bool isMailMatch = true;
    final ref = FirebaseDatabase.instance.ref(constUserId).child('User Role');

    await ref.orderByKey().get().then((value) async {
      for (var element in value.children) {
        var data = UserRoleModel.fromJson(jsonDecode(jsonEncode(element.value)));
        if (data.email == subUserEmail) {
          isMailMatch = false;
          return;
        }
      }
    });
    return isMailMatch;
  }

  void putUserData({required String userId, required bool subUser, required String title, required String email}) async {
    final prefs = await SharedPreferences.getInstance();
    constUserId = userId;
    isSubUser = subUser;

    await prefs.setString('userId', userId);
    await prefs.setString('subUserEmail', email);
    await prefs.setString('userTitle', title);
    await prefs.setBool('isSubUser', subUser);
    getUserData();
  }
}

bool newSelect = false;
