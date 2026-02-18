package com.example.noor

data class PrayerTime(
    val name: String,
    val time: String,
    val isHighlight: Boolean = false,
    val isTomorrow: Boolean = false
)
