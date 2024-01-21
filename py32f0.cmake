cmake_minimum_required(VERSION 3.25)

# If your GCC has been added to the environment variable,
# there is no need to set GCC_PATH

# set(GCC_PATH "C:/path/to/your/arm-none-eabi-gcc/bin")

# project settings
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD 11)

# Use HAL lib or LL lib
set(USE_HAL_OR_LL LL)




# MCU:
#   PY32F002Ax5
#   PY32F002Bx5
#   PY32F003x4, PY32F003x6, PY32F003x8
#   PY32F030x4, PY32F030x6, PY32F030x7, PY32F030x8
#   more info see readme
set(MCU_MODEL PY32F030x6)


# Enable printf float %f support
# seems need 20KB Flash, 0.8KB RAM!
set(ENABLE_PRINTF_FLOAT OFF)

# Build with CMSIS DSP functions
set(USE_DSP OFF)
# Enable auto generation of Misc/pyocd.yaml if needed
set(AUTO_GENERATE_PYOCD_YAML ON)


include_directories(App)
FILE(GLOB_RECURSE USER_SOURCES App/*.c)
