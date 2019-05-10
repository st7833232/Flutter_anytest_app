package com.example.anytest_app;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.example.anytest_app/anytest_app";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler((methodCall, result) -> {
      if (methodCall.method.equals("TestCode")) {
        String val = methodCall.argument("name");
        if (val.equals("Java Code Test")) {
          result.success("Return from Java");
        }
        else {
          result.error("Error", "Error", "Error");
        }
      }
    });
  }
}
