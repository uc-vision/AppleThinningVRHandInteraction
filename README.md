# AppleThinningVRHandInteraction
VR Hand Interaction sandbox for testing functionality to interact with objects in VR using hand controls.

This game has been created to test users performance when picking apple fruitlets off a branch using different interaction mechanics.

A Pre exported APK of this game is available by clicking the Releases tab in GitHub.


## Build and Export
To build or export this game you will need to set up Godot.
1. Firstly download Godot from official channels https://godotengine.org/download. 
2. Download android studio and set it up.
3. in the "welcome to android studio screen" navigate to More actions > SDK Manager > SDK tools and have the following tools selected and downloaded:
    - Android SDK Build-Tools 32
    - NDK
    - Android SDK Command-line Tools
    - CMake
    - Android Emulator
    - Android Emulator Hypervisor Driver for AMD Processors
    - Android SDK Platform-Tools
4. At the top of the same page, copy and save somewhere the Android SDK Location
5. Download and Install OpenJDK 11 from the following link: https://adoptium.net/temurin/releases/?version=11
6. Open a command prompt at the location where you want to store your Android Debug Keystore, for windows, the location C:/Users/user/.android is a good location. Also copy this location.
7. In the command prompt enter in the following command to generate a keystore


    keytool -keyalg RSA -genkeypair -alias androiddebugkey -keypass android -keystore debug.keystore -storepass android -dname "CN=Android Debug,O=Android,C=US" -validity 9999 -deststoretype pkcs12


8. Enable developer mode on your Meta Quest device. The following link has instructions on how to do that: https://learn.adafruit.com/sideloading-on-oculus-quest/enable-developer-mode

9. Now in Godot, open up this project and then navigate to Project > Export and make sure all of the necessary files are downloaded for the android export. Then close that tab

10. Navigate to Editor > Editor Settings > Export > Android. In this page copy in the location of the debug keystore created in step 7 into the Debug Keystore setting. It should look something like this: 


    C:/Users/rutge/.android/debug.keystore


11. In the same screen, copy in the location of the SDK which you saved in step 4 into the Android Sdk Path setting. It should look something like this:


    C:\Users\rutge\AppData\Local\Android\Sdk


12. Finally, Plug in your Meta Quest headset to your computer and allow debuging in the headset. An android icon should now appear at the top right of the godot application next to the run application buttons. When you click this the app will be deployed onto your Meta Quest Headset.

13. (Optional) To generate the APK for the game simply navigate to Project > Export, click on the Android (Runnable) option and then click Export Project.