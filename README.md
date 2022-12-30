# lap-tracker
A single code base to visualize and manage lap data for racing purposes


> For help getting started with Flutter development, view the \
> [online documentation](https://docs.flutter.dev/), which offers tutorials,\
> samples, guidance on mobile development, and a full API reference.\
#
## Download the project
Clone the project (and the submodule `configs` if you have the rights)
```bash
git clone --recurse-submodules git@github.com:Panther-Racing-AUTh/lap-tracker.git
```

#
## Ignore files that have been tracked
This is for files that maybe will be added to `.gitignore` but are already tracked by git.
```bash
git rm -r --cached . && git add . && git commit -am "Remove ignored files"
```

#
## Run the project
If you have the rights clone our private repository `configs` that has all the keys and credentials inside, then you are good to go, just run
```bash
flutter clean && flutter pub get && flutter run #only the first time
flutter run #every other time
```

If you don't have the rights to clone, follow the instructions below to get started.
> Be carefull on the directories

To run this project you need `configs` repo inside the `lib` directory.
Inside the `configs` you should have
- `supabase_credentials.dart`
- `key.properties`
- `panther-keystore.jks`

### Details
1. Create `supabase_credentials.dart` under `lib/configs` directory and paste the following snippet:
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseCredentials {
  static const String APIKEY =
      "YOUR_KEY_GOES_HERE";
  static const String APIURL = "https://YOUR_API_URL_GOES_HERE";

  static SupabaseClient supabaseClient = SupabaseClient(APIURL, APIKEY);
}
```
2. Create a keystore under `lib/configs` directory:
> More info can be found  here [Flutter - create an upload keystore](https://docs.flutter.dev/deployment/android#create-an-upload-keystore)
```bash
cd lib/configs
keytool -genkey -v -keystore YOUR_KEYSTORE_NAME-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias YOUR_ALIAS
```

3. Create a `key.properties` under `lib/configs` directory and paste the following snippet: 
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=YOUR_KEY_ALIAS
storeFile=YOUR_PATH_TO/YOUR_KEYSTORE_NAME-keystore.jks
```
