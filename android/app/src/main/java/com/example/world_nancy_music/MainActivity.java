package com.example.world_nancy_music;

import io.flutter.embedding.android.FlutterActivity;
import com.chaquo.python.Python;
import com.chaquo.python.PyObject;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import androidx.annotation.NonNull;
import java.util.HashMap;
import java.util.Map;

public class MainActivity extends FlutterActivity {
}
import com.chaquo.python.PyObject;
import com.chaquo.python.Python;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

@Override
public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "yt_dlp")
        .setMethodCallHandler((call, result) -> {
            if (call.method.equals("getAudioUrl")) {
                String url = call.argument("url");
                Python py = Python.getInstance();
                PyObject pyObj = py.getModule("ytdlp_wrapper");
                PyObject data = pyObj.callAttr("get_audio_url", url);

                Map<String, Object> map = new HashMap<>();
                for (PyObject key : data.asMap().keySet()) {
                    map.put(key.toString(), data.asMap().get(key).toString());
                }
                result.success(map);
            } else {
                result.notImplemented();
            }
        });
}
