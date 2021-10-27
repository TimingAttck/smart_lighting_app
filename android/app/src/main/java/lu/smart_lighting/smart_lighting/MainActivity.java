package lu.smart_lighting.smart_lighting;

import io.flutter.embedding.android.FlutterActivity;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import android.nfc.Tag;
import android.nfc.tech.NfcV;
import android.util.Log;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.IntentFilter;
import android.provider.Settings;
import android.content.Context;
import android.nfc.NfcAdapter;
import android.nfc.NfcManager;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Build;


public class MainActivity extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            // Workaround
            // Samsung navigation bar icon colors are not changing using flutter correctly (bug)
            // When the app is registered simply set the color to gray
            // Flutter will override the theme related navigation bar color
            // Then the icons color will be fixed
            getWindow().setNavigationBarColor(Color.parseColor("#212121"));
        }

    }

}
