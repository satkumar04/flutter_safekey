# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:



-keepclassmembers class rx.internal.util.unsafe.*ArrayQueue*Field* {
    long producerIndex;
    long consumerIndex;
}

-dontwarn sun.misc.Unsafe

##tokbox
# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interfaces
# class:
#-keepclassmembers class fqcn.of.javascript.interfaces.for.webview {
#   public *;
#}


-dontwarn org.apache.commons.**
-dontwarn org.apache.http.**
-dontwarn org.apache.log4j.**
-dontnote org.apache.log4j.**
-dontwarn twitter4j.**
-dontwarn com.facebook.android.**
-dontwarn com.pclinklibrary.**
-dontwarn com.taidoc.pclinklibrary.**
-dontwarn okio.**
-dontwarn butterknife.internal.**
-dontwarn com.squareup.picasso.**
-dontwarn twitter4j.**


-dontwarn org.spongycastle.**


-dontwarn java.lang.management.**

# Suppress warnings if you are NOT using IAP:
  -dontwarn com.nnacres.app.**
  -dontwarn com.androidquery.**
  -dontwarn com.google.**
  -dontwarn org.acra.**
  -dontwarn org.apache.**
  -dontwarn com.nostra13.**
  -dontwarn net.simonvt.**
  -dontwarn android.support.**
  -dontwarn com.squareup.okhttp.**
  -dontwarn okhttp3.**

-dontwarn android.webkit.WebView
-dontwarn android.net.http.SslError
-dontwarn android.webkit.WebViewClient
-dontnote okhttp3.**, okio.**, pl.droidsonroids.**

#following line throws error
#Note: the configuration explicitly specifies 'android.net.http.SslError' to keep library class 'android.net.http.SslError'
#-keep public class android.net.http.SslError
#-keep public class android.webkit.WebViewClient

##-------------------------- Library version dependency ------------------------------------
-dontwarn  com.github.**

##------------------------------------------------------------------------------------------

-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontskipnonpubliclibraryclassmembers
-dontpreverify
-verbose
-dump class_files.txt
-printseeds seeds.txt
-printusage unused.txt
-printmapping mapping.txt
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*

-allowaccessmodification
-keepattributes *Annotation*
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable
-repackageclasses ''



-dontwarn com.facebook.stetho.**


### Glide, Glide Okttp Module, Glide Transformations

-keep public enum com.bumptech.glide.load.resource.bitmap.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}
# -keepresourcexmlelements manifest/application/meta-data@value=GlideModule 3 For dexguard

-dontwarn jp.co.cyberagent.android.gpuimage.**

### Viewpager indicator
-dontwarn com.viewpagerindicator.**

### Support v7, Design
# http://stackoverflow.com/questions/29679177/cardview-shadow-not-appearing-in-lollipop-after-obfuscate-with-proguard/29698051


# https://github.com/Gericop/Android-Support-Preference-V7-Fix/blob/master/preference-v7/proguard-rules.pro

# https://github.com/dandar3/android-support-animated-vector-drawable/blob/master/proguard-project.txt
#-keepclassmembers class android.support.graphics.drawable.VectorDrawableCompat$* {
#   void set*(***);
#   *** get*();
#}

### Reactive Network
-dontwarn com.github.pwittchen.reactivenetwork.library.ReactiveNetwork
-dontwarn io.reactivex.functions.Function
-dontwarn rx.internal.util.**
-dontwarn sun.misc.Unsafe

### Retrolambda
# as per official recommendation: https://github.com/evant/gradle-retrolambda#proguard
-dontwarn java.lang.invoke.*

# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
-keepattributes Signature

# For using GSON @Expose annotation
-keepattributes *Annotation*


# Gson specific classes
-keep class sun.misc.Unsafe { *; }


# Application classes that will be serialized/deserialized over Gson


# Prevent proguard from stripping interface information from TypeAdapterFactory,
# JsonSerializer, JsonDeserializer instances (so they can be used in @JsonAdapter)


###Apache Http

-dontwarn org.apache.http.**


### Retrofit 2


-dontwarn retrofit2.**

# Platform calls Class.forName on types which do not exist on Android to determine platform.
-dontnote retrofit2.Platform
# Platform used when running on RoboVM on iOS. Will not be used at runtime.
-dontnote retrofit2.Platform$IOS$MainThreadExecutor
# Platform used when running on Java 8 VMs. Will not be used at runtime.
-dontwarn retrofit2.Platform$Java8
# Retain generic type information for use by reflection by converters and adapters.
-keepattributes Signature
# Retain declared checked exceptions for use by a Proxy instance.
-keepattributes Exceptions

-dontwarn retrofit2.adapter.rxjava.CompletableHelper$** # https://github.com/square/retrofit/issues/2034
#To use Single instead of Observable in Retrofit interface

#Retrofit does reflection on generic parameters. InnerClasses is required to use Signature and
# EnclosingMethod is required to use InnerClasses.
-keepattributes Signature, InnerClasses, EnclosingMethod
# Retain service method parameters when optimizing.
-keepclassmembers,allowshrinking,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}


 -keep interface okhttp3.* { *; }
     -keepattributes Annotation
     -keepattributes Signature
     -keepattributes Exceptions

    -dontwarn retrofit2.**
    -keepattributes Signature
    -keepattributes Exceptions

    -keepclasseswithmembers class * {
        @retrofit2.http.* <methods>;
    }

     # For using GSON @Expose annotation and otto @Subscribe annotation
     -keepattributes *Annotation*


# Ignore JSR 305 annotations for embedding nullability information.
-dontwarn javax.annotation.**
# Guarded by a NoClassDefFoundError try/catch and only used when on the classpath.
-dontwarn kotlin.Unit
# Top-level functions that can only be used by Kotlin.
-dontwarn retrofit2.-KotlinExtensions


### OkHttp3

-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
# A resource is loaded with a relative path so the package of this class must be preserved.


### Picasso
-dontwarn com.squareup.okhttp.**

### new Relic


-dontwarn com.newrelic.**
-keepattributes Exceptions, Signature, InnerClasses, LineNumberTable, SourceFile, EnclosingMethod



-keep class **$Properties
# If you do not use SQLCipher:
-dontwarn org.greenrobot.greendao.database.**
# If you do not use RxJava:
-dontwarn rx.**
### greenDAO 2

-keep class **$Properties


### Fabric
# In order to provide the most meaningful crash reports
-keepattributes SourceFile,LineNumberTable
# If you're using custom Eception
-keep public class * extends java.lang.Exception


-dontwarn com.crashlytics.**

### Crash report
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable

### Other
-dontwarn com.google.errorprone.annotations.*

### Exoplayer2
-dontwarn com.google.android.exoplayer2.**

### Android Architecture Components
# Ref: https://issuetracker.google.com/issues/62113696
# LifecycleObserver's empty constructor is considered to be unused by proguard
#-keepclassmembers class * implements android.arch.lifecycle.LifecycleObserver {
#    <init>(...);
#}
-keep class * implements android.arch.lifecycle.LifecycleObserver {
    <init>(...);
}




# keep Lifecycle State and Event enums values
-keepclassmembers class android.arch.lifecycle.Lifecycle$State { *; }
-keepclassmembers class android.arch.lifecycle.Lifecycle$Event { *; }
# keep methods annotated with @OnLifecycleEvent even if they seem to be unused
# (Mostly for LiveData.LifecycleBoundObserver.onStateChange(), but who knows)
-keepclassmembers class * {
    @android.arch.lifecycle.OnLifecycleEvent *;
}

## Databinding or library depends on databinding
-dontwarn android.databinding.**



# https://github.com/Kotlin/kotlinx.atomicfu/issues/57
-dontwarn kotlinx.atomicfu.**



### Kotlin
#https://stackoverflow.com/questions/33547643/how-to-use-kotlin-with-proguard
#https://medium.com/@AthorNZ/kotlin-metadata-jackson-and-proguard-f64f51e5ed32
-keepclassmembers class **$WhenMappings {
    <fields>;
}
-keep class kotlin.Metadata { *; }
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}
-keepclassmembers public class * {
    @com.google.gson.annotations.SerializedName *;
}


### Adjust SDK, android.installreferrer
-keep public class com.adjust.sdk.** { *; }
-keep class com.google.android.gms.common.ConnectionResult {
    int SUCCESS;
}



### Nothing for Butterknife 8, Realm, RxJava2, RxBinding, RxRelay, Dagger2, OneSignal, Google Play Services, Firebase, Facebook SDK, Room DB,