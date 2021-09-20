vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libass/libass
    REF 0.15.2
    SHA512 ae3ea533e57ab3c386ce457dbaa39a256801b7340649d5ff80a51410481e73ab194724744b97d85cb6d111798e45eee594bb22da2f1f3c547fe8e331e0690127
    HEAD_REF master
    PATCHES
      enable-asm-with-msvc-compiler.patch
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/libass/ass/meson.build DESTINATION ${SOURCE_PATH}/libass/ass)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/libass/profile/meson.build DESTINATION ${SOURCE_PATH}/libass/profile)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/libass/test/meson.build DESTINATION ${SOURCE_PATH}/libass/test)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/libass/meson.build DESTINATION ${SOURCE_PATH}/libass)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/libass.def DESTINATION ${SOURCE_PATH}/libass)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/meson.build DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/meson_options.txt DESTINATION ${SOURCE_PATH})

if("asm" IN_LIST FEATURES)
    list(APPEND FEATURE_OPTIONS -Dasm=enabled)
    vcpkg_find_acquire_program(NASM)
    get_filename_component(NASM_EXE_PATH ${NASM} DIRECTORY)
    vcpkg_add_to_path(${NASM_EXE_PATH})
endif()

vcpkg_configure_meson(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS ${FEATURE_OPTIONS}
)

vcpkg_install_meson()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
