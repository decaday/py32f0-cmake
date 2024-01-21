cmake_minimum_required(VERSION 3.25)

# If your GCC has been added to the environment variable,
# there is no need to set GCC_PATH

# set(GCC_PATH "C:/path/to/your/arm-none-eabi-gcc/bin")

# project settings
project(stm32g0 C CXX ASM)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD 11)


# Use HAL lib or LL lib
set(USE_HAL_OR_LL HAL)


set(MCU_MODEL PY32F030x6)


# Enable printf float %f support
set(ENABLE_PRINTF_FLOAT OFF)
# Build with CMSIS DSP functions
set(USE_DSP OFF)
# If debug and flash with PYOCD
set(USE_PYOCD ON)
# path to PyOCD
set(PYOCD_PATH pyocd)


include_directories(Src)
file(GLOB_RECURSE USER_SOURCES Src/*)



add_definitions(
        -DUSE_HAL_DRIVER
)