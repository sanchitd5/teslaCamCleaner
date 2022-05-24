//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_media_info/flutter_media_info_plugin.h>
#include <tflite_flutter_helper/tflite_flutter_helper_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) flutter_media_info_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterMediaInfoPlugin");
  flutter_media_info_plugin_register_with_registrar(flutter_media_info_registrar);
  g_autoptr(FlPluginRegistrar) tflite_flutter_helper_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "TfliteFlutterHelperPlugin");
  tflite_flutter_helper_plugin_register_with_registrar(tflite_flutter_helper_registrar);
}
