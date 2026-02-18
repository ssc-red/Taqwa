# Quick Troubleshooting Guide

## If Still Slow
- Check Logcat for "NetworkOnMainThreadException" (shouldn't happen now)
- Monitor memory in Android Profiler (should be < 100MB)
- Verify internet connection is stable

## If Widget Doesn't Update
```adb shell
run-as com.example.noor
cat shared_prefs/NoorPrefs.xml
```

## If Colors Look Off
- Verify display settings aren't using color filters
- Check phone brightness settings

## If Location Not Found
- Enable location permission: Settings → Apps → Noor → Location
- Turn on GPS: Settings → Location
- Try outdoors for better signal

## Common Fixes
- **ANR errors**: ✅ Already fixed (using coroutines now)
- **Blocking network**: ✅ Already fixed (Dispatchers.Default)
- **Memory leaks**: ✅ Already fixed (optimized widget updates)
- **Slow list**: ✅ Already fixed (stable keys added)

## Test Commands
```
# View logs
adb logcat | grep -i "noor"

# Check permissions
adb shell dumpsys package com.example.noor | grep LOCATION
```

## Key Files to Check
- `MainActivity.kt` - Network and location logic
- `NoorWidget.kt` - Widget UI and styling
- `build.gradle.kts` - Minification settings

