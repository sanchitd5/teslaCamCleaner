//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_media_info/flutter_media_info_plugin.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <tflite_flutter_helper/tflite_flutter_helper_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterMediaInfoPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterMediaInfoPlugin"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  TfliteFlutterHelperPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("TfliteFlutterHelperPlugin"));
}
