def use_flutter_modules!
  plugins_dir = File.join('Flutter', 'plugins')

  
  # Link FlutterPluginRegistrant
  flutter_plugin_registrant_path = File.expand_path('FlutterPluginRegistrant',plugins_dir)
  puts "FlutterPluginRegistrant path: #{flutter_plugin_registrant_path}"
  pod 'FlutterPluginRegistrant', :path => flutter_plugin_registrant_path, :inhibit_warnings => true
  
  # Load and link Flutter plugins
  plugins_file = File.expand_path('.flutter-plugins-dependencies', plugins_dir)
  puts "Flutter plugins dependencies file path: #{plugins_file}"
  plugin_pods = flutter_parse_plugins_file(plugins_file)
  puts "hello: #{plugin_pods}"
  
  plugin_pods['plugins']['ios'].each do |plugin_hash|
    puts "hash: #{plugin_hash}"
    plugin_name = plugin_hash['name']
    has_native_build = plugin_hash.fetch('native_build', true)
    if plugin_name && has_native_build
      plugin_path = File.join(plugins_dir, plugin_name, 'ios')
      pod plugin_name, :path => plugin_path, :inhibit_warnings => true
    end
  end
end


def flutter_post_install(installer, skip: false)
  return if skip

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |_build_configuration|
      # flutter_additional_ios_build_settings is in Flutter root podhelper.rb
      flutter_additional_ios_build_settings(target)
    end
  end
end

def flutter_parse_plugins_file(file)
  file_path = File.expand_path(file)
  return [] unless File.exist? file_path

  dependencies_file = File.read(file)
  JSON.parse(dependencies_file)
end

def flutter_additional_ios_build_settings(target)
  return unless target.platform_name == :ios

  # [target.deployment_target] is a [String] formatted as "8.0".
  inherit_deployment_target = target.deployment_target[/\d+/].to_i < 12

  # ARC code targeting iOS 8 does not build on Xcode 14.3.
  force_to_arc_supported_min = target.deployment_target[/\d+/].to_i < 9
  #
  # # This podhelper script is at $FLUTTER_ROOT/packages/flutter_tools/bin.
  # # Add search paths from $FLUTTER_ROOT/bin/cache/artifacts/engine.
  # artifacts_dir = File.join('..', '..', '..', '..', 'bin', 'cache', 'artifacts', 'engine')
  # debug_framework_dir = File.expand_path(File.join(artifacts_dir, 'ios', 'Flutter.xcframework'), __FILE__)
  #
  # unless Dir.exist?(debug_framework_dir)
  #   # iOS artifacts have not been downloaded.
  #   raise "#{debug_framework_dir} must exist. If you're running pod install manually, make sure \"flutter precache --ios\" is executed first"
  # end
  #
  # release_framework_dir = File.expand_path(File.join(artifacts_dir, 'ios-release', 'Flutter.xcframework'), __FILE__)
  # Bundles are com.apple.product-type.bundle, frameworks are com.apple.product-type.framework.
  # target_is_resource_bundle = target.respond_to?(:product_type) && target.product_type == 'com.apple.product-type.bundle'

  target.build_configurations.each do |build_configuration|
    # Build both x86_64 and arm64 simulator archs for all dependencies. If a single plugin does not support arm64 simulators,
    # the app and all frameworks will fall back to x86_64. Unfortunately that case is not detectable in this script.
    # Therefore all pods must have a x86_64 slice available, or linking a x86_64 app will fail.
    build_configuration.build_settings['ONLY_ACTIVE_ARCH'] = 'NO' if build_configuration.type == :debug

    # Workaround https://github.com/CocoaPods/CocoaPods/issues/11402, do not sign resource bundles.
    # if target_is_resource_bundle
    #   build_configuration.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
    #   build_configuration.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
    #   build_configuration.build_settings['CODE_SIGNING_IDENTITY'] = '-'
    #   build_configuration.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = '-'
    # end

    # ARC code targeting iOS 8 does not build on Xcode 14.3. Force to at least iOS 9.
    build_configuration.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0' if force_to_arc_supported_min

    # Skip other updates if it does not depend on Flutter (including transitive dependency)
    # next unless depends_on_flutter(target, 'Flutter')

    # Bitcode is deprecated, Flutter.framework bitcode blob will have been stripped.
    build_configuration.build_settings['ENABLE_BITCODE'] = 'NO'

    # Profile can't be derived from the CocoaPods build configuration. Use release framework (for linking only).
    # TODO(stuartmorgan): Handle local engines here; see https://github.com/flutter/flutter/issues/132228
    # configuration_engine_dir = build_configuration.type == :debug ? debug_framework_dir : release_framework_dir
    # Dir.new(configuration_engine_dir).each_child do |xcframework_file|
    #   next if xcframework_file.start_with?('.') # Hidden file, possibly on external disk.
    #   if xcframework_file.end_with?('-simulator') # ios-arm64_x86_64-simulator
    #     build_configuration.build_settings['FRAMEWORK_SEARCH_PATHS[sdk=iphonesimulator*]'] = "\"#{configuration_engine_dir}/#{xcframework_file}\" $(inherited)"
    #   elsif xcframework_file.start_with?('ios-') # ios-arm64
    #     build_configuration.build_settings['FRAMEWORK_SEARCH_PATHS[sdk=iphoneos*]'] = "\"#{configuration_engine_dir}/#{xcframework_file}\" $(inherited)"
    #    # else Info.plist or another platform.
    #   end
    # end
    build_configuration.build_settings['OTHER_LDFLAGS'] = '$(inherited) -framework Flutter'

    build_configuration.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
    # Suppress warning when pod supports a version lower than the minimum supported by Xcode (Xcode 12 - iOS 9).
    # This warning is harmless but confusing--it's not a bad thing for dependencies to support a lower version.
    # When deleted, the deployment version will inherit from the higher version derived from the 'Runner' target.
    # If the pod only supports a higher version, do not delete to correctly produce an error.
    build_configuration.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET' if inherit_deployment_target

    # Override legacy Xcode 11 style VALID_ARCHS[sdk=iphonesimulator*]=x86_64 and prefer Xcode 12 EXCLUDED_ARCHS.
    build_configuration.build_settings['VALID_ARCHS[sdk=iphonesimulator*]'] = '$(ARCHS_STANDARD)'
    build_configuration.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = '$(inherited) i386'
    build_configuration.build_settings['EXCLUDED_ARCHS[sdk=iphoneos*]'] = '$(inherited) armv7'
  end
end

