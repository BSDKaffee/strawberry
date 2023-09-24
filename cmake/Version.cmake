set(STRAWBERRY_VERSION_MAJOR 1)
set(STRAWBERRY_VERSION_MINOR 0)
set(STRAWBERRY_VERSION_PATCH 20)
#set(STRAWBERRY_VERSION_PRERELEASE rc1)

set(INCLUDE_GIT_REVISION OFF)

set(majorminorpatch "${STRAWBERRY_VERSION_MAJOR}.${STRAWBERRY_VERSION_MINOR}.${STRAWBERRY_VERSION_PATCH}")

set(STRAWBERRY_VERSION_DISPLAY "${majorminorpatch}")
set(STRAWBERRY_VERSION_PACKAGE "${majorminorpatch}")
set(STRAWBERRY_VERSION_RPM_V   "${majorminorpatch}")
set(STRAWBERRY_VERSION_RPM_R   "1")
set(STRAWBERRY_VERSION_PAC_V   "${majorminorpatch}")
set(STRAWBERRY_VERSION_PAC_R   "1")

if(STRAWBERRY_VERSION_PRERELEASE)
  set(STRAWBERRY_VERSION_DISPLAY "${STRAWBERRY_VERSION_DISPLAY} ${STRAWBERRY_VERSION_PRERELEASE}")
  set(STRAWBERRY_VERSION_RPM_R   "0.${STRAWBERRY_VERSION_PRERELEASE}")
  set(STRAWBERRY_VERSION_PACKAGE "${STRAWBERRY_VERSION_PACKAGE}${STRAWBERRY_VERSION_PRERELEASE}")
endif(STRAWBERRY_VERSION_PRERELEASE)


if(INCLUDE_GIT_REVISION AND EXISTS "${CMAKE_SOURCE_DIR}/.git")

  find_program(GIT_EXECUTABLE git)
  if(NOT GIT_EXECUTABLE OR GIT_EXECUTABLE-NOTFOUND)
    message(FATAL_ERROR "Missing GIT executable." )
  endif()

  # Get the current working branch
  execute_process(
    COMMAND ${GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    RESULT_VARIABLE GIT_CMD_RESULT_BRANCH
    OUTPUT_VARIABLE GIT_BRANCH
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET
  )
  # Get the latest abbreviated commit hash of the working branch
  execute_process(
    COMMAND ${GIT_EXECUTABLE} describe --long --tags --always
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    RESULT_VARIABLE GIT_CMD_RESULT_REVISION
    OUTPUT_VARIABLE GIT_REVISION
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET
  )

  if(NOT ${GIT_CMD_RESULT_REVISION} EQUAL 0)
    message(FATAL_ERROR "GIT command failed to get revision string '${GIT_REVISION}'")
  endif()

endif()

if(FORCE_GIT_REVISION)
  set(GIT_REVISION ${FORCE_GIT_REVISION})
endif()

if(GIT_REVISION)

  string(REGEX REPLACE "^(.+)-([0-9]+)-(g[a-f0-9]+)$" "\\1;\\2;\\3" GIT_PARTS ${GIT_REVISION})

  if(NOT GIT_PARTS)
    message(FATAL_ERROR "Failed to parse git revision string '${GIT_REVISION}'")
  endif()

  list(LENGTH GIT_PARTS GIT_PARTS_LENGTH)
  if(NOT GIT_PARTS_LENGTH EQUAL 3)
    message(FATAL_ERROR "Failed to parse git revision string '${GIT_REVISION}'")
  endif()

  list(GET GIT_PARTS 0 GIT_TAGNAME)
  list(GET GIT_PARTS 1 GIT_COMMITCOUNT)
  list(GET GIT_PARTS 2 GIT_SHA1)

  set(HAS_GIT_REVISION ON)

  set(STRAWBERRY_VERSION_DISPLAY "${GIT_REVISION}")
  set(STRAWBERRY_VERSION_PACKAGE "${GIT_TAGNAME}.${GIT_COMMITCOUNT}.${GIT_SHA1}")
  set(STRAWBERRY_VERSION_RPM_V   "${GIT_TAGNAME}")
  set(STRAWBERRY_VERSION_RPM_R   "2.${GIT_COMMITCOUNT}.${GIT_SHA1}")
  set(STRAWBERRY_VERSION_PAC_V   "${GIT_TAGNAME}.r${GIT_COMMITCOUNT}.${GIT_SHA1}")
  set(STRAWBERRY_VERSION_PAC_R   "1")

endif()

message(STATUS "Strawberry Version:")
message(STATUS "Display:  ${STRAWBERRY_VERSION_DISPLAY}")
message(STATUS "Package:  ${STRAWBERRY_VERSION_PACKAGE}")
message(STATUS "RPM:      ${STRAWBERRY_VERSION_RPM_V}-${STRAWBERRY_VERSION_RPM_R}")
message(STATUS "PAC:      ${STRAWBERRY_VERSION_PAC_V}-${STRAWBERRY_VERSION_PAC_R}")
