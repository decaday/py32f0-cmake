set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION 1)
cmake_minimum_required(VERSION 3.25)

project(py32_cmake_template C CXX ASM)
include(py32f0.cmake)


set(MCU_LOWER $<LOWER_CASE:${MCU_MODEL}>)




# HALs
if("${MCU_MODEL}" MATCHES "PY32F002A|PY32F003|PY32F030")
    if("${USE_HAL_OR_LL}" STREQUAL "HAL")
        FILE(GLOB LIB_SOURCES Drivers/PY32F0xx_HAL_Driver/Src/*)
        list(APPEND SOURCES ${LIB_SOURCES})
        list(APPEND INCLUDE_DIRS Drivers/PY32F0xx_HAL_Driver/Inc)
    elseif("${USE_HAL_OR_LL}" STREQUAL "LL")
        FILE(GLOB LIB_SOURCES Libraries/PY32F0xx_LL_Driver/Src/*)
        list(APPEND SOURCES ${LIB_SOURCES})
        list(APPEND INCLUDE_DIRS Drivers/PY32F0xx_HAL_Driver/Inc)
    else()
        message(FATAL_ERROR "Wrong setting: USE_HAL_OR_LL ${USE_HAL_OR_LL}")
    endif()
elseif()
endif()


# Startup file
if("${MCU_MODEL}" MATCHES "PY32F002A")
    list(APPEND SOURCES Drivers/CMSIS/Device/PY32F0xx/Source/gcc/startup_py32f002a.s)
elseif("${MCU_MODEL}" MATCHES "PY32F003")
    list(APPEND SOURCES Drivers/CMSIS/Device/PY32F0xx/Source/gcc/startup_py32f003.s)
elseif("${MCU_MODEL}" MATCHES "PY32F030")
    list(APPEND SOURCES Drivers/CMSIS/Device/PY32F0xx/Source/gcc/startup_py32f030.s)
elseif("${MCU_MODEL}" MATCHES "PY32F002B")
    list(APPEND SOURCES Drivers/CMSIS/Device/PY32F0xx/Source/gcc/startup_py32f002b.s)

endif()

# ld_script
set(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/Drivers/LDScripts/${MCU_LOWER}.ld)

# system_py32f0xx.c
list(APPEND SOURCES Drivers/CMSIS/Device/PY32F0xx/Source/system_py32f0xx.c)

list(APPEND SOURCES ${USER_SOURCES})

include_directories(
        Drivers/CMSIS/Include
        Drivers/CMSIS/Device/PY32F0xx/Include
        ${INCLUDE_DIRS}
        )

message(STATUS "Maximum optimization for speed")

add_definitions(-DDEBUG
        -DUSE_HAL_DRIVER
        -D${MCU_MODEL}
        )


# auto generate pyocd.yaml
if(AUTO_GENERATE_PYOCD_YAML)
    set(PYOCD_CONENT "target_override: ${MCU_MODEL}\npack: Misc/Puya.PY32F0xx_DFP.1.1.9.pack\nfrequency: 1000000")
    file(WRITE Misc/pyocd.yaml ${PYOCD_CONENT})
endif()





# specify cross-compilers and tools
if (GCC_PATH)
    if (WIN32)  # add .exe for windows
        set(CMAKE_C_COMPILER ${GCC_PATH}/arm-none-eabi-gcc.exe)
        set(CMAKE_CXX_COMPILER ${GCC_PATH}/arm-none-eabi-g++.exe)
        set(CMAKE_ASM_COMPILER ${GCC_PATH}/arm-none-eabi-gcc.exe)
        set(CMAKE_AR ${GCC_PATH}/arm-none-eabi-ar.exe)
        set(CMAKE_OBJCOPY ${GCC_PATH}/arm-none-eabi-objcopy.exe)
        set(CMAKE_OBJDUMP ${GCC_PATH}/arm-none-eabi-objdump.exe)
        set(SIZE ${GCC_PATH}/arm-none-eabi-size.exe)
    else ()
        set(CMAKE_C_COMPILER ${GCC_PATH}/arm-none-eabi-gcc)
        set(CMAKE_CXX_COMPILER ${GCC_PATH}/arm-none-eabi-g++)
        set(CMAKE_ASM_COMPILER ${GCC_PATH}/arm-none-eabi-gcc)
        set(CMAKE_AR ${GCC_PATH}/arm-none-eabi-ar)
        set(CMAKE_OBJCOPY ${GCC_PATH}/arm-none-eabi-objcopy)
        set(CMAKE_OBJDUMP ${GCC_PATH}/arm-none-eabi-objdump)
        set(SIZE ${GCC_PATH}/arm-none-eabi-size)
    endif ()
else ()
    set(CMAKE_C_COMPILER arm-none-eabi-gcc)
    set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
    set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
    set(CMAKE_AR arm-none-eabi-ar)
    set(CMAKE_OBJCOPY arm-none-eabi-objcopy)
    set(CMAKE_OBJDUMP arm-none-eabi-objdump)
    set(SIZE arm-none-eabi-size)
endif ()

#Uncomment for software floating point
#add_compile_options(-mfloat-abi=soft)

add_compile_options(-mcpu=cortex-m0plus -mthumb -mthumb-interwork)
add_compile_options(-ffunction-sections -fdata-sections -fno-common -fmessage-length=0)

# uncomment to mitigate c++17 absolute addresses warnings
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-register")

# Enable assembler files preprocessing
add_compile_options($<$<COMPILE_LANGUAGE:ASM>:-x$<SEMICOLON>assembler-with-cpp>)

if ("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
    message(STATUS "Maximum optimization for speed")
    add_compile_options(-Ofast)
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
    message(STATUS "Maximum optimization for speed, debug info included")
    add_compile_options(-Ofast -g)
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "MinSizeRel")
    message(STATUS "Maximum optimization for size")
    add_compile_options(-Os)
else ()
    message(STATUS "Minimal optimization, debug info included")
    add_compile_options(-Og -g)
endif ()

if(ENABLE_PRINTF_FLOAT)
    add_link_options(-u _printf_float)
endif ()
add_link_options(-Wl,-gc-sections,--print-memory-usage,-Map=${PROJECT_BINARY_DIR}/${PROJECT_NAME}.map)
add_link_options(-specs=nano.specs -specs=nosys.specs -static -lc -lm)
add_link_options(-Wl,--no-warn-rwx-segments)
add_link_options(-mcpu=cortex-m0plus -mthumb -mthumb-interwork)
add_link_options(-T ${LINKER_SCRIPT})

add_executable(${PROJECT_NAME}.elf ${SOURCES} ${LINKER_SCRIPT})

set(HEX_FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.hex)
set(BIN_FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.bin)

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -Oihex $<TARGET_FILE:${PROJECT_NAME}.elf> ${HEX_FILE}
        COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${PROJECT_NAME}.elf> ${BIN_FILE}
        COMMENT "Building ${HEX_FILE}
Building ${BIN_FILE}")
