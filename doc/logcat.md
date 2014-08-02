# logcat

	easter logcat

Underneath, this calls `adb logcat`, however, it does several extra things:

* Clear the log with `adb logcat -c`
* Filter it so that only relevant messages are shown

Typical usage is to run `easter logcat` first and then manually start your Moai app.
In most situations, the [run](run.md) command offers a more convenient way to run your app.
