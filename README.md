## Time victor
A fantasy Application

## Firebase Console Settings 

* Create a Firebase project
* Generate google-services.json file and place at android -> app 
* Add SHA1 key.
* In firebase console click on Authentication -> Sign-in Methods then enable phone authentication.
* Create Cloud Firestore database and inside rules add
`rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
     match /users/{uid}/{document=**} {
      allow read, write: if request.auth.uid == uid;
    }
  }
}`

Now we are upto date with firebase.





