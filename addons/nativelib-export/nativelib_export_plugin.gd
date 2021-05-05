tool
extends EditorPlugin

class NativeLibExportPlugin:
    extends EditorExportPlugin

    func _ios_add_bundles() -> void:
        var dir = Directory.new()
        if dir.open('res://addons/nativelib-export/iOS') == OK:
            dir.list_dir_begin()
            var file_name = dir.get_next()
            while file_name != '':
                if dir.current_is_dir() and file_name.ends_with('.bundle'):
                    var bundle = dir.get_current_dir() + "/" + file_name
                    print('Add iOS bundle: %s'%bundle)
                    add_ios_bundle_file(bundle)
                file_name = dir.get_next()
        else:
            print('Can not open iOS addon directory!')
    
    func _ios_add_installed_frameworks() -> void:
        var dir = Directory.new()
        if dir.open('res://addons/nativelib-export/iOS') == OK:
            dir.list_dir_begin()
            var file_name = dir.get_next()
            while file_name != '':
                if dir.current_is_dir() and (file_name.ends_with('.framework') or file_name.ends_with('.xcframework')):
                    var framework = dir.get_current_dir() + "/" + file_name
                    print('Add iOS framework: %s'%framework)
                    add_ios_framework(framework)
                file_name = dir.get_next()
        else:
            print('Can not open iOS addon directory!')

    func _ios_add_standard_frameworks() -> void:
        var f = File.new()
        f.open('res://addons/nativelib-export/iOS/std_frameworks.txt', File.READ)
        while not f.eof_reached():
            var fr = f.get_line()
            if fr.begins_with('#') or fr == '':
                # skip comments
                continue
            add_ios_framework(fr)
            print('Add standard framework: %s'%fr)
    
    func _ios_add_plist_content() -> void:
        var dir = Directory.new()
        if dir.open('res://addons/nativelib-export/iOS') == OK:
            dir.list_dir_begin()
            var file_name = dir.get_next()
            while file_name != '':
                if not dir.current_is_dir() and file_name.ends_with('.plist'):
                    if file_name == 'GoogleService-Info.plist':
                        var bundle = dir.get_current_dir() + "/" + file_name
                        add_ios_bundle_file(bundle)
                        print('Add plist bundle: %s'%bundle)
                    else:
                        var plist = dir.get_current_dir() + "/" + file_name
                        print('Add plist content: %s'%plist)
                        var f = File.new()
                        f.open(plist, File.READ)
                        var content = f.get_as_text()
                        f.close()
                        add_ios_plist_content(content)
                file_name = dir.get_next()
        else:
            print('Can not open iOS addon directory!')

    func _process_hooks(hooks_path: String, args: Array) -> void:
        var dir = Directory.new()
        if dir.open(hooks_path) == OK:
            dir.list_dir_begin()
            var file_name = dir.get_next()
            while file_name != '':
                if not dir.current_is_dir() and file_name.ends_with('.gd'):
                    var hook = load(dir.get_current_dir() + "/" + file_name)
                    hook.callv('process', args)
                file_name = dir.get_next()
        else:
            # ignore error
            pass

    func _process_start_hooks(features: PoolStringArray, debug: bool, path: String, flags: int) -> void:
        _process_hooks('res://addons/nativelib-export/start_hook', [features, debug, path, flags])

    func _process_end_hooks() -> void:
        _process_hooks('res://addons/nativelib-export/end_hook', [])

    func _export_begin(features: PoolStringArray, debug: bool, path: String, flags: int) -> void:
        _process_start_hooks(features, debug, path, flags)
        if 'iOS' in features:
            add_ios_linker_flags("-ObjC")
            _ios_add_installed_frameworks()
            _ios_add_bundles()
            _ios_add_standard_frameworks()
            _ios_add_plist_content()
        elif 'Android' in features:
            pass
        else:
            # skip platform
            pass

    func _export_end() -> void:
        _process_end_hooks()
        pass

func _init():
    add_export_plugin(NativeLibExportPlugin.new())

func _enter_tree():
    pass

func _exit_tree():
    pass
