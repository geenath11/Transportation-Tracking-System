# Project specific ProGuard/R8 rules.
#
# Flutter embedding, Firebase and the Google Play services plugins ship their
# own consumer rules, so nothing extra is required here yet.
# Add keep rules for anything removed by R8 that is only referenced by
# reflection (e.g. serializable models).
