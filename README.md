# FlatApp

Flutter example app, made for learning purposes, specifically security research.

Previous versions:
* v0.1: application can store 1 note in file note.txt, which is available only for FlatApp.
* v0.2: password validation object is present but mostly inactive
* v0.3: access to application is encrypted.
* v0.4: password can be changed in separate view.
* v0.5: further debugging and processing improvement.

Current version:
* **v0.6:** fingerprint scan is required to log in.

Incoming version:
* v0.7: further debugging and processing improvement.


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Installing project

* Download repository to your desired location. 
* Flutter requires **Android Studio** for Android deployment. 
    
    Recommended IDLE to code is **Intellij IDEA**.
    
* Remember to install **Flutter** plugin, following [these instructions](https://flutter.dev/docs/get-started/install).
* install packages required for this project with `flutter pub get`, run in **your project folder!**

    Any additional packages should be implemented in **pubspec.yaml file** and installed as written above.
    
## Design notes

### Technical details
FlatApp current min SDKVersion (Android level) is 18.

App main colour is `HEX: 0197f8` or `RGBA: 1 151 248 100`.

Custom icons were created in [Android Asset Studio Launcher icon generator](https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html#foreground.type=clipart&foreground.clipart=filter_vintage&foreground.space.trim=1&foreground.space.pad=0.25&foreColor=rgb(1%2C%20151%2C%20248)&backColor=rgb(255%2C%20255%2C%20255)&crop=0&backgroundShape=circle&effects=none&name=ic_launcher).
No custom icons for iOS are developed yet.

New screens (or views) should be operated by Navigator as in [this example](https://flutter.dev/docs/cookbook/navigation/navigation-basics).

### Routes

FlatApp operates on views - every change on the screen (movement to another option) draws another view.
Current views flow:

    LoginRoute -> NoteRoute <-> PasswordRoute

## Files: read and write

Flutter tutorial and documentation is [here](https://flutter.dev/docs/cookbook/persistence/reading-writing-files).
It requires [path_provider](https://pub.dev/packages/path_provider#-installing-tab-) package.

Reading and writing data should be asynchronous according to [this manual](https://dart.dev/codelabs/async-await).

## Security: passwords and encryption

###[Security tips from Android team](https://developer.android.com/training/articles/security-tips)

[On safe storage](https://developer.android.com/guide/topics/data/data-storage.html#filesInternal):

> **Internal storage (not used in FlatApp)**

> By default, files saved to the internal storage are private to your app, and other apps cannot access them 
> (nor can the user, unless they have root access). This makes internal storage a good place for internal app data 
> that the user doesn't need to directly access. The system provides a private directory on the file system 
> for each app where you can organize any files your app needs.
    
> When the user uninstalls your app, the files saved on the internal storage are removed. Because of this behavior, 
> you should not use internal storage to save anything the user expects to persist independently of your app. 
    

> **External storage  (not used in FlatApp)**
    
> Files created on external storage, such as SD cards, are globally readable and writable. 
> Because external storage can be removed by the user and also modified by any application, 
> don't store sensitive information using external storage.
    
> To read and write files on external storage in a more secure way, consider using the Security library, 
> which provides the EncryptedFile class.

Internal storage in FlatApp was being operated via ContentStorage object in previous versions.
Now password and note should be stored and read from Secure Storage. 
The key to encrypt these contents is stored in AKSS:
([source](https://academy.realm.io/posts/secure-storage-in-android-san-francisco-android-meetup-2017-najafzadeh/)):
    
> The conclusion is that there is no safe place to store data on disk. You can use encryption to prevent an attacker 
> from being able to understand the data when they gain access to it.

> An encryption algorithm will require a key, but where should the key be stored? 
> Fortunately, the Android Keystore System can help with this. Its sole purpose is to store keys, 
> so it does not work like a database. You cannot store whatever data you want.
    
Flutter utilises AKSS with [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage).
FlatApp does it via PasswordStorage and SecureStorage objects.

###Encryption details
Per [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) documentation:

> AES encryption (of content - red.) is used for Android. AES secret key is encrypted with RSA and RSA key is stored in KeyStore

**Defaults**

> In almost cases, you should rely on default PRNG for salts. 
> It is cryptographically secure and unique for each password.

> On the other hand, you are encouraged to change interations count for what your hardware can handle.

**PBKDF2 hash algorithm**

| Data              | value             |
| ----------------- | ----------------- |
| Digest	        | SHA-512           |
| Block size	    | 64 bytes          |
| Salt	            | 32 bytes Fortuna  |
| Iteration count   | 10000             |
| Key length	    | 64 bytes          |

### Passwords handling

Simple password hashing code is presented in [password](https://pub.dev/packages/password#-readme-tab-) package.

## Fingerprint handling

documentation of [local_auth](https://pub.dev/packages/local_auth)

## Debugging notes

### On reading Future values

Dart utilizes specific form of asynchronous processing, called Future.
Future objects allow application to work while their work is not finished.

Reading Future\<String\> value results in returning "Instance of Future\<String>" response, 
not actual content of variable, due to the asynchronicity thereof.  

If the Future objects are being accessed too fast (before the Future happened), 
application will fail to load them as `null` value would be returned 
(as the object itself exists in the future).

This can be prevented with example coding 
([documentation](https://dart.dev/codelabs/async-await)):

```dart
// use async library
import 'dart:async';
```
```dart
class A {
  Future<int> getInt() {
    return Future.value(10);
  }
}

class B {
  checkValue() async {
    final val = await A().getInt();
    print(val == 10 ? "yes" : "no");
  }
}
```
```dart
void foo() async {
  final user = await _fetchUserInfo(id);
}

Future someMethod() async {
  String s = await someFuncThatReturnsFuture();
}
```
```dart
someMethod() {
  someFuncTahtReturnsFuture().then((s) {
    print(s);
  });
}
```

### On safely managing logins

[keystore](https://developer.android.com/training/articles/keystore.html)
 | [keystore UserAuthentication](https://developer.android.com/training/articles/keystore.html#UserAuthentication)

    Require user authentication for key use
    When generating or importing a key into the AndroidKeyStore 
    you can specify that the key is only authorized to be used if 
    the user has been authenticated. The user is authenticated using a 
    subset of their secure lock screen credentials (pattern/PIN/password, 
    fingerprint).
    
    This is an advanced security feature which is generally 
    useful only if your requirements are that a compromise of your 
    application process after key generation/import (but not before or during) 
    cannot bypass the requirement for the user to be authenticated to use the key.
    
    When a key is authorized to be used only if the user has been 
    authenticated, it is configured to operate in one of the two modes:
    
    User authentication authorizes the use of keys for a duration of time. 
    All keys in this mode are authorized for use as soon as the user unlocks 
    the secure lock screen or confirms their secure lock screen credential 
    using the KeyguardManager.createConfirmDeviceCredentialIntent flow. 
    The duration for which the authorization remains valid is specific to each 
    key, as specified using setUserAuthenticationValidityDurationSeconds during 
    key generation or import. Such keys can only be generated or imported if 
    the secure lock screen is enabled (see KeyguardManager.isDeviceSecure()). 
    These keys become permanently invalidated once the secure lock screen is 
    disabled (reconfigured to None, Swipe or other mode which doesn't authenticate 
    the user) or forcibly reset (e.g. by a Device Administrator).
    
    User authentication authorizes a specific cryptographic operation associated 
    with one key. In this mode, each operation involving such a key must be 
    individually authorized by the user. Currently, the only means of such 
    authorization is fingerprint authentication: FingerprintManager.authenticate. 
    Such keys can only be generated or imported if at least one fingerprint is 
    enrolled (see FingerprintManager.hasEnrolledFingerprints). 
    
    These keys become permanently invalidated once a new fingerprint is 
    enrolled or all fingerprints are unenrolled.

It is recommended to check whether user has been authenticated in some period of time before logging him in,
as it may be forced entry (via root). This authentication is strong enough to prevent malicious actions.
