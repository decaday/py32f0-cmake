cmake_minimum_required(VERSION 3.25)

# If your GCC has been added to the environment variable,
# there is no need to set GCC_PATH

# set(GCC_PATH "C:/path/to/your/arm-none-eabi-gcc/bin")

# project settings
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD 11)


# Use HAL lib or LL lib
set(USE_HAL_OR_LL HAL)


set(MCU_MODEL PY32F030x6)


# Enable printf float %f support
set(ENABLE_PRINTF_FLOAT ON)
# Build with CMSIS DSP functions
set(USE_DSP ON)
# Enable auto generation of Misc/pyocd.yaml if needed
set(AUTO_GENERATE_PYOCD_YAML ON)


include_directories(App)
FILE(GLOB_RECURSE USER_SOURCES App/*.c)
