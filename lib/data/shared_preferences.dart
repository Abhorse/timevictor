import 'package:shared_preferences/shared_preferences.dart';
import 'package:timevictor/modals/user_info.dart';

enum UserData { name, email, age, gender }

class SharedPref {
  Future<void> saveUserInfo(UserInfo userInfo) async {
    await save('name', userInfo.name);
    await save('email', userInfo.email);
    await save('age', userInfo.age);
    await save('gender', userInfo.gender);
    if (userInfo.profilePicURL != null && userInfo.profilePicURL.isNotEmpty) {
      await save('profilePicURL', userInfo.profilePicURL);
    }
  }

  Future<UserInfo> getUserInfo() async {
    String name = await getStringValue('name');
    String email = await getStringValue('email');
    String age = await getStringValue('age');
    String gender = await getStringValue('gender');
    String profilePicURL = await getStringValue('profilePicURL');

    // return UserInfo(
    //   name: await getStringValue('name'),
    //   email: await getStringValue('email'),
    //   age: await getStringValue('age'),
    //   gender: await getStringValue('gender'),
    //   profilePicURL: await getStringValue('profilePicURL'),
    // );

    return UserInfo(
      name: name,
      email: email,
      age: age,
      gender: gender,
      profilePicURL: profilePicURL,
    );
  }

  saveUID(String uid) async {
    await save('uid', uid);
  }

  Future<String> getUID() async {
    return getStringValue('uid');
  }

  savePhoneNumber(String phoneNumber) async {
    await save('phoneNumber', phoneNumber);
  }

  Future<String> getPhoneNumber() async {
    return getStringValue('phoneNumber');
  }

  save(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    }
  }

  //get value from shared preferences
  Future<String> getStringValue(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String value = pref.getString(key) ?? null;
    return value;
  }
}
