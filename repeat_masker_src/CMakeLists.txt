
file(GLOB REPEAT_MASKER_CU_SRC "${CMAKE_CURRENT_SOURCE_DIR}/*.cu")
file(GLOB REPEAT_MASKER_CPP_SRC "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp")
file(GLOB COMMON_CU_SRC "${CMAKE_CURRENT_SOURCE_DIR}/../common/*.cu")
file(GLOB COMMON_CPP_SRC "${CMAKE_CURRENT_SOURCE_DIR}/../common/*.cpp")

if(hip_FOUND)
    set_source_files_properties(${COMMON_CU_SRC} PROPERTIES LANGUAGE CXX)
    set_source_files_properties(${REPEAT_MASKER_CU_SRC} PROPERTIES LANGUAGE CXX)

    add_executable(segalign_repeat_masker ${COMMON_CU_SRC} ${COMMON_CPP_SRC} ${REPEAT_MASKER_CU_SRC} ${REPEAT_MASKER_CPP_SRC})
    target_link_libraries(segalign_repeat_masker PRIVATE ${DEP_LIBS} hip::device roc::rocthrust)

else()
    add_executable(segalign_repeat_masker ${COMMON_CU_SRC} ${COMMON_CPP_SRC} ${REPEAT_MASKER_CU_SRC} ${REPEAT_MASKER_CPP_SRC})
    target_link_libraries(segalign_repeat_masker PRIVATE ${DEP_LIBS})
endif()

target_compile_options(segalign_repeat_masker PRIVATE -DTBB_SUPPRESS_DEPRECATED_MESSAGES)
target_include_directories(segalign_repeat_masker PRIVATE ${PROJECT_SOURCE_DIR}/common/ ${PROJECT_SOURCE_DIR}/src/ ${DEP_INCLUDES} )

install(TARGETS segalign_repeat_masker DESTINATION bin)
