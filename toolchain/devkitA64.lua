toolchain("devkita64")
    add_defines("__SWITCH__")

    set_kind("standalone")

    set_toolset("cc", "aarch64-none-elf-gcc")
    set_toolset("cxx", "aarch64-none-elf-g++")
    set_toolset("ld", "aarch64-none-elf-g++")
    set_toolset("sh", "aarch64-none-elf-g++")

    on_check("check")

    local DEVKITPRO = os.getenv("DEVKITPRO")

    if not DEVKITPRO then
        echo("Please set DEVKITPRO var")
        return
    end

    add_linkdirs(path.join(DEVKITPRO, "/libnx/lib"))
    add_includedirs(path.join(DEVKITPRO, "/libnx/include"))

    on_load(function(toolchain)
        local devkita64 = toolchain:arch()
        if devkita64 then
            toolchain:add("defines", "__SWITCH__")
            toolchain:add("arch", "-march=armv8-a+crc+crypto", "-mtune=cortex-a57", "-mtp=soft", "-fPIE")
            toolchain:add("cxxflags", "-fno-rtti", "-fno-exceptions", {force = true})
            toolchain:add("cxflags", "-march=armv8-a+crc+crypto", "-mtune=cortex-a57", "-mtp=soft", "-fPIE", {force = true})
            toolchain:add("cflags", "-g", "-Wall", "-O2", "-ffunction-sections", {force = true})
            toolchain:add("asflags", "-g", "-march=armv8-a+crc+crypto", "-mtune=cortex-a57", "-mtp=soft", "-fPIE", {force = true})
            toolchain:add("ldflags", "-specs=C:/devkitPro/libnx/switch.specs", "-g", "-W", "-fPIC","$(notdir $*.map)", {force = true})
        end
        toolchain:add("linkdirs", "${DEVKITPRO}/libnx/lib", "${DEVKITPRO}/portlibs/switch/lib")
        toolchain:add("syslinks", "gcc", "c", "m", "nx")
        toolchain:add("links", "nx")

    end)


