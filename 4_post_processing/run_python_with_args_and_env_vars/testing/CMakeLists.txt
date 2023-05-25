add_custom_target(tests
  COMMENT "Running python script..."
  COMMAND ${PYTHON_EXECUTABLE} ${PROJECT_SOURCE_DIR}/testing/runtests.py --yes --nice
)
