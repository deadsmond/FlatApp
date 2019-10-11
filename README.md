# flatapp

Flutter example app, made for learning purposes,
specifically security research.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Notes on security

[Security tips from Android team](https://developer.android.com/training/articles/security-tips)

[On safe storage](https://developer.android.com/guide/topics/data/data-storage.html#filesInternal):

    Internal storage (currently used in FlatApp)

    By default, files saved to the internal storage are private to your app, and other apps cannot access them 
    (nor can the user, unless they have root access). This makes internal storage a good place for internal app data 
    that the user doesn't need to directly access. The system provides a private directory on the file system 
    for each app where you can organize any files your app needs.
    
    When the user uninstalls your app, the files saved on the internal storage are removed. Because of this behavior, 
    you should not use internal storage to save anything the user expects to persist independently of your app. 
    

    External storage  (not used in FlatApp)
    
    Files created on external storage, such as SD cards, are globally readable and writable. 
    Because external storage can be removed by the user and also modified by any application, 
    don't store sensitive information using external storage.
    
    To read and write files on external storage in a more secure way, consider using the Security library, 
    which provides the EncryptedFile class.
    
Password should be stored and read from Android KeyStore System 
([source](https://academy.realm.io/posts/secure-storage-in-android-san-francisco-android-meetup-2017-najafzadeh/)):
    
    The conclusion is that there is no safe place to store data on disk. You can use encryption to prevent an attacker 
    from being able to understand the data when they gain access to it.

    An encryption algorithm will require a key, but where should the key be stored? 
    Fortunately, the Android Keystore System can help with this. Its sole purpose is to store keys, 
    so it does not work like a database. You cannot store whatever data you want.
    
Flutter utilises AKSS with [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage).

Simple password hashing code is presented in [password](https://pub.dev/packages/password#-readme-tab-) package.


