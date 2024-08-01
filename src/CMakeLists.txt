
file(GLOB SEGALIGN_CU_SRC "${CMAKE_CURRENT_SOURCE_DIR}/*.cu")
file(GLOB SEGALIGN_CPP_SRC "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp")
file(GLOB COMMON_CU_SRC "${CMAKE_CURRENT_SOURCE_DIR}/../common/*.cu")
file(GLOB COMMON_CPP_SRC "${CMAKE_CURRENT_SOURCE_DIR}/../common/*.cpp")

if(hip_FOUND)
    set_source_files_properties(${COMMON_CU_SRC} PROPERTIES LANGUAGE HIP)
    set_source_files_properties(${SEGALIGN_CU_SRC} PROPERTIES LANGUAGE HIP)

    add_executable(segalign ${COMMON_CU_SRC} ${COMMON_CPP_SRC} ${SEGALIGN_CU_SRC} ${SEGALIGN_CPP_SRC})
    target_link_libraries(segalign PRIVATE ${DEP_LIBS} hip::host roc::rocthrust)

else()
    add_executable(segalign ${COMMON_CU_SRC} ${COMMON_CPP_SRC} ${SEGALIGN_CU_SRC} ${SEGALIGN_CPP_SRC})
    target_link_libraries(segalign PRIVATE ${DEP_LIBS})
endif()

target_compile_options(segalign PRIVATE -DTBB_SUPPRESS_DEPRECATED_MESSAGES)
target_include_directories(segalign PRIVATE ${PROJECT_SOURCE_DIR}/common/ ${PROJECT_SOURCE_DIR}/src/ ${DEP_INCLUDES} )

install(TARGETS segalign DESTINATION bin)
