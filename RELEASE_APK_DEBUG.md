# Release APK Debugging Guide

## Common Issues & Solutions

### 1. **App Crashes on Launch**

**Symptoms:**
- App force closes immediately after opening
- No UI appears

**Causes:**
- Classes were obfuscated/removed that are needed at runtime
- Missing ProGuard rules for critical components

**Solutions Already Applied:**
- ✅ Enhanced ProGuard rules to keep all application classes
- ✅ Added rules to preserve Compose, Kotlin metadata, and JSON parsing
- ✅ Kept all constructors and reflection-related methods

### 2. **Location Permission Issues**

**Symptoms:**
- "Permission Denied" message when app starts
- Prayer times not loading

**Solutions:**
1. **Check Manifest Permissions** - Ensure AndroidManifest.xml has:
   ```xml
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
   <uses-permission android:name="android.permission.INTERNET" />
   ```

2. **Runtime Permissions** - Grant location permission when prompted

3. **Device Settings** - Check app permissions in Settings > Apps > Noor > Permissions

### 3. **Widget Not Loading**

**Symptoms:**
- Widget shows error or blank screen
- Widget crashes when tapped

**Causes:**
- GlanceAppWidget classes were obfuscated

**Solutions:**
- ✅ Added ProGuard rules to keep GlanceAppWidget and GlanceAppWidgetReceiver classes
- ✅ Preserved `provideGlance` method
- Reinstall the app and re-add the widget to home screen

### 4. **Prayer Times Not Fetching**

**Symptoms:**
- API call fails silently
- Shows "Fetching location..." forever

**Causes:**
- JSON parsing classes obfuscated
- Network classes modified

**Solutions:**
- ✅ Added rules to keep org.json classes
- ✅ Added rules to keep java.net.URL classes (already kept by default)
- Check internet connection on device
- Test with device WiFi if mobile data is unstable

### 5. **Notifications/Alarms Not Working**

**Symptoms:**
- No notification appears at prayer time
- AlarmManager seems to not work

**Causes:**
- BroadcastReceiver was obfuscated
- NotificationReceiver class was removed

**Solutions:**
- ✅ Added rules to keep all BroadcastReceiver classes
- ✅ Preserved constructor signatures for WorkManager
- Check if device notifications are enabled for the app

### 6. **Theme Switching Not Working**

**Symptoms:**
- Light/Dark mode button does nothing
- Theme always shows as default

**Causes:**
- SharedPreferences access was obfuscated

**Solutions:**
- ✅ Added rules to keep all get/set methods (reflection)
- ✅ Preserved MainActivity class completely
- Clear app data and restart the app

## Testing Release APK Locally

### Step 1: Build Release APK
```bash
./gradlew assembleRelease
```

### Step 2: Locate APK
```
app/build/outputs/apk/release/app-release.apk
```

### Step 3: Install on Device
```bash
adb install app/build/outputs/apk/release/app-release.apk
```

### Step 4: Test All Features
- ✅ Location permission grant
- ✅ Prayer times load correctly
- ✅ Countdown timer works
- ✅ Theme switching works
- ✅ Widget appears and updates
- ✅ Notifications fire at prayer times

## ProGuard/R8 Configuration Details

### Current Settings:
- **Minification**: Enabled (`isMinifyEnabled = true`)
- **Obfuscation**: Enabled (default with R8)
- **Optimization Passes**: 5

### Key Rules Applied:

1. **Preserve Application Classes**
   ```
   -keep class com.example.noor.** { *; }
   ```

2. **Preserve Android Framework Classes**
   - BroadcastReceiver
   - GlanceAppWidget
   - ListenableWorker

3. **Preserve Metadata**
   - Kotlin metadata (for reflection)
   - Android Resources (R$ classes)
   - Enum value() and valueOf() methods

4. **Disable Optimization for Critical Features**
   - Keep method signatures for reflection
   - Keep constructors
   - Keep native methods

## Advanced Debugging

### Enable ProGuard Mapping
To debug obfuscated crashes, use the mapping file:
```
app/build/outputs/mapping/release/mapping.txt
```

### Check What Was Removed
After building, inspect:
```
app/build/outputs/mapping/release/usage.txt  # Removed code
app/build/outputs/mapping/release/seeds.txt # Kept code
```

### Test Without Obfuscation
To verify the issue is obfuscation-related, temporarily disable minification:

In `build.gradle.kts`:
```kotlin
buildTypes {
    release {
        isMinifyEnabled = false  // Temporarily disable
        // ...
    }
}
```

Then rebuild and test. If it works, the ProGuard rules need updating.

## Submission Checklist

Before releasing to Google Play:

- [ ] Release APK tested on multiple devices
- [ ] All permissions working correctly
- [ ] Prayer times fetching and displaying
- [ ] Widget functioning properly
- [ ] Notifications firing at correct times
- [ ] Theme switching working
- [ ] No force closes or crashes
- [ ] App data persists correctly

## Support & Further Help

If the release APK still has issues after these steps:

1. **Check Logcat output**:
   ```bash
   adb logcat | grep -i "com.example.noor"
   ```

2. **Look for specific errors**:
   - `ClassNotFoundException` - Need to keep that class
   - `MethodNotFoundException` - Need to keep that method
   - `NoSuchMethodError` - Constructor signature changed

3. **Update ProGuard rules** based on errors

4. **Rebuild and retest**


