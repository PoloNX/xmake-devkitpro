package("switch-pkg")

    

    set_kind("template")
    set_description("Switch package template")

    on_load(function (package)
        package:add("deps", "switch-pacman")
    end)

    on_fetch(function (package)
        local pkgname = assert(package:data("pkgname"), "this package must not be used directly")

        local DEVKITPRO = os.getenv("DEVKITPRO")
        
        linkdirs = {}
        pkgconfig_files = {}

        list = name and try{ function() return os.vrunv("pacman", {"-Q", "-l", name}) end }
        if not list then
            return
        end
        

        for _, line in ipairs(list:split('\n', {plain = true})) do
            line = line:trim():split('%s+')[2]
            if line:find("/pkgconfig/", 1, true) and line:endswith(".pc") then
                table.insert(pkgconfig_files, line)
            end
            if line:endswith(".so") or line:endswith(".a") or line:endswith(".lib") then
                table.insert(linkdirs, path.directory(line))
            end
        end
        linkdirs = table.unique(linkdirs)

        import("package.manager.pkgconfig.find_package", {alias = "find_package_from_pkgconfig"})

        local foundpc = false
        local result = {includedirs = {}, links = {}, linkdirs = {}}
        for _, pkgconfig_file in ipairs(pkgconfig_files) do 
            local pkgconfig_dir = path.directory(pkgconfig_file)
            local pkgconfig_name = path.basename(pkgconfig_file)
            local pcresult = find_package_from_pkgconfig(pkgconfig_name, {configdirs = pkgconfig_dir, linkdirs = linkdirs})
        
            if pcresult then
                for _, includedir in ipairs(pcresult.includedirs) do
                    table.insert(result.includedirs, includedir)
                end
                for _, linkdir in ipairs(pcresult.linkdirs) do
                    table.insert(result.linkdirs, linkdir)
                end
                for _, link in ipairs(pcresult.links) do
                    table.insert(result.links, link)
                end

                result.version = pcresult.version
                foundpc = true
            end

        end

        if foundpc == true then
            result.includedirs = table.unique(result.includedirs)
            result.linkdirs = table.unique(result.linkdirs)
            result.links = table.unique(result.links)
        end

        return result
    end)

    on_install(function (package)
        local pacman = package:dep("switch-pacman"):fetch()
        if not pacman then
            return
        end
        local pkgname = assert(package:data("pkgname"), "this package must not be used directly")

        os.vrunv("pacman", {"-S", pkgname})
    end)