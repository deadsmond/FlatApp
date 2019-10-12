# flatapp

Flutter example app, made for learning purposes, specifically security research.

Current version:
* **v0.1**: application can store 1 note in file note.txt, which is available only for FlatApp.

Incoming version:
* v0.2: access to application is encrypted.

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
    
FlatApp current minSdkVersion (Android level) is 18.

## Files: read and write

Flutter tutorial and documentation is [here](https://flutter.dev/docs/cookbook/persistence/reading-writing-files).
It requires [path_provider](https://pub.dev/packages/path_provider#-installing-tab-) package.

## Security: passwords and encryption

###[Security tips from Android team](https://developer.android.com/training/articles/security-tips)

[On safe storage](https://developer.android.com/guide/topics/data/data-storage.html#filesInternal):

> Internal storage (currently used in FlatApp)

> By default, files saved to the internal storage are private to your app, and other apps cannot access them 
> (nor can the user, unless they have root access). This makes internal storage a good place for internal app data 
> that the user doesn't need to directly access. The system provides a private directory on the file system 
> for each app where you can organize any files your app needs.
    
> When the user uninstalls your app, the files saved on the internal storage are removed. Because of this behavior, 
> you should not use internal storage to save anything the user expects to persist independently of your app. 
    

> External storage  (not used in FlatApp)
    
> Files created on external storage, such as SD cards, are globally readable and writable. 
> Because external storage can be removed by the user and also modified by any application, 
> don't store sensitive information using external storage.
    
> To read and write files on external storage in a more secure way, consider using the Security library, 
> which provides the EncryptedFile class.
    
Password should be stored and read from Android KeyStore System 
([source](https://academy.realm.io/posts/secure-storage-in-android-san-francisco-android-meetup-2017-najafzadeh/)):
    
> The conclusion is that there is no safe place to store data on disk. You can use encryption to prevent an attacker 
> from being able to understand the data when they gain access to it.

> An encryption algorithm will require a key, but where should the key be stored? 
> Fortunately, the Android Keystore System can help with this. Its sole purpose is to store keys, 
> so it does not work like a database. You cannot store whatever data you want.
    
Flutter utilises AKSS with [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage).

###Encryption details
Per [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) documentation:

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


