# Release APK Diagnostic Checklist

## What to Test When Release APK Doesn't Work

### 1. **Initial Launch Test**
- Install release APK on device
- Click app icon to launch
- **Expected**: App starts, shows loading indicator
- **If crashes**: Check logcat for ClassNotFoundException or MethodNotFoundException

### 2. **Location Permission Test**
- App should prompt for location permission
- Grant permission when asked
- **Expected**: "Location Found" appears, prayer times load
- **If stuck on "Fetching location..."**: Grant permission in Settings > Apps > Noor > Permissions

### 3. **Prayer Times Display Test**
- Wait for API call to complete
- **Expected**: Sehri, Iftar, and prayer times appear
- **If blank**: Check internet connection, verify API endpoint works

### 4. **Countdown Timer Test**
- Launch app with prayer times visible
- Wait 10 seconds
- **Expected**: Countdown updates ("2h 45m", etc.)
- **If doesn't update**: Timer logic may be obfuscated

### 5. **Theme Toggle Test**
- Tap sun/moon button at bottom right
- **Expected**: Colors change from light to dark (or vice versa)
- **If doesn't work**: SharedPreferences access obfuscated

### 6. **Widget Test**
- Long press home screen
- Select "Widgets"
- Find and add "Noor" widget
- **Expected**: Widget displays with prayer info
- **If doesn't appear**: GlanceAppWidget class obfuscated

### 7. **Logcat Error Analysis**

Run this command to see app logs:
```
adb logcat com.example.noor:V *:S
```

Look for errors like:
- `ClassNotFoundException` → Add -keep rule for that class
- `MethodNotFoundException` → Add -keepclassmembers rule
- `NullPointerException` → Check if objects being null due to obfuscation
- `NoSuchMethodError` → Constructor signature changed

## If You Find Specific Errors

### For ClassNotFoundException:
```
E: ClassNotFoundException: com.example.noor.SomeClass
```
Add to proguard-rules.pro:
```
-keep class com.example.noor.SomeClass { *; }
```

### For MethodNotFoundException:
```
E: MethodNotFoundException: com.example.noor.SomeClass.someMethod()
```
Add to proguard-rules.pro:
```
-keepclassmembers class com.example.noor.SomeClass {
    *** someMethod(...);
}
```

### For Serialization Issues:
If getting JSON parsing errors, ensure:
```
-keep class org.json.** { *; }
-keepclassmembers class org.json.** { *; }
```

## Current ProGuard Configuration

The updated proguard-rules.pro includes:
✅ All application classes preserved
✅ BroadcastReceiver classes preserved
✅ GlanceAppWidget preserved
✅ WorkManager Worker preserved
✅ Jetpack Compose preserved
✅ Kotlin metadata preserved
✅ JSON parsing preserved
✅ Google Play Services preserved
✅ All constructors preserved
✅ Enum classes preserved
✅ Reflection methods (get/set) preserved

## Next Steps if Issues Persist

1. **Enable Logging**:
   - Add `android:debuggable="false"` in AndroidManifest.xml release build variant
   - Or keep it true for easier debugging

2. **Review Mapping File**:
   - Check `app/build/outputs/mapping/release/mapping.txt`
   - This shows what was obfuscated

3. **Test Unobfuscated Release**:
   - Temporarily set `isMinifyEnabled = false` in build.gradle.kts
   - Rebuild and test
   - If it works, ProGuard rules need updating

4. **Update ProGuard Rules**:
   - Add missing -keep rules for any obfuscated classes
   - Rebuild with minification enabled
   - Test again

5. **Check Manifest**:
   - Ensure all activities and receivers are declared
   - Verify permissions are correct
   - Check widget provider registration

## Common Release APK Issues by Feature

| Feature | Common Issue | Solution |
|---------|--------------|----------|
| App Launch | Crash on start | Keep all app classes |
| Prayer Times | API fails silently | Keep JSON parsing, URL classes |
| Location | Permission denied | Ensure runtime permissions granted |
| Notifications | Don't fire | Keep BroadcastReceiver classes |
| Widget | Doesn't appear | Keep GlanceAppWidget classes |
| Theme | Won't toggle | Keep SharedPreferences access (get/set methods) |
| Countdown | Doesn't update | Keep Timer/Calendar classes |

## Files to Check

After building release APK:
- `app/build/outputs/mapping/release/mapping.txt` - All obfuscation mappings
- `app/build/outputs/mapping/release/usage.txt` - What was removed
- `app/build/outputs/mapping/release/seeds.txt` - What was kept
- `app/build/outputs/apk/release/app-release.apk` - Final APK file

