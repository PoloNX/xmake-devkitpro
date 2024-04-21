includes("toolchain/*.lua")

add_repositories("switch-repo https://github.com/PoloNX/switch-repo.git")


add_requires("libsdl", "libsdl_mixer", "libsdl_ttf", "libsdl_image")

target("sdl2-demo")
    set_arch("aarch64")
    add_rules("switch")
    set_toolchains("devkita64")

    set_values("switch.name", "sdl2-demo")
    set_values("switch.author", "PoloNX")
    set_values("switch.version", "1.0.0")
    
    set_values("switch.romfs", "romfs")
    set_values("switch.icon", "icon.jpg")

    add_files("example/*.cpp")

    add_packages("libsdl", "libsdl_mixer", "libsdl_ttf", "libsdl_image")





