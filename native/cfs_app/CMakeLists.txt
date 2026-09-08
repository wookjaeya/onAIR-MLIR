project(CFE_AI_LEARNER C)
# E12: compiled Learner as a cFS application, statically linked against the
# minimal IREE runtime (PIC build). Contract figures are injected as defines.
set(IREE_SRC "/tmp/iree-src")
set(IREE_B   "${IREE_SRC}/build-rt")
file(GLOB_RECURSE IREE_RT_LIBS "${IREE_B}/runtime/*.a")
list(APPEND IREE_RT_LIBS
  "${IREE_B}/build_tools/third_party/flatcc/libflatcc_parsing.a"
  "${IREE_B}/build_tools/third_party/flatcc/libflatcc_runtime.a"
  "${IREE_B}/build_tools/third_party/printf/libprintf_printf.a")
add_cfe_app(ai_learner fsw/src/ai_learner.c)
target_include_directories(ai_learner PRIVATE "${IREE_SRC}/runtime/src" "${IREE_B}/runtime/src")
target_compile_definitions(ai_learner PRIVATE
  IREE_ALLOCATOR_SYSTEM_CTL=iree_allocator_libc_ctl
  CONTRACT_BOUNDED_BYTES=786476 CONTRACT_PER_CALL_BYTES=65580 CONTRACT_CONST_BYTES=720896
  AI_LEARNER_BUDGET_BYTES=1048576)
target_link_libraries(ai_learner -Wl,--start-group ${IREE_RT_LIBS} -Wl,--end-group m dl)
# cFS applies -std=c99 -pedantic -Werror to apps; IREE headers use C11 static_assert
# and anonymous unions (GNU extension in C99). Relax for this app only.
target_compile_options(ai_learner PRIVATE -std=gnu11 -Wno-pedantic -Wno-error -Wno-unused-result)
