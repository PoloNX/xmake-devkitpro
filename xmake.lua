includes("toolchain/*.lua")

add_requires("pacman::switch-curl")

target("example")
    set_arch("aarch64")
    add_rules("switch")
    set_toolchains("devkita64")

    set_values("switch.name", "example")
    set_values("switch.author", "PoloNX")
    set_values("switch.version", "1.0.0")
    
    set_values("switch.romfs", "romfs")
    set_values("switch.icon", "icon.jpg")

    add_files("example/*.cpp")
    set_targetdir("Out")

    add_packages("switch-curl")




