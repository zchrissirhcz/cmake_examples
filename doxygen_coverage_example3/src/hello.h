#pragma once

/**
  @defgroup my_core
  @brief core functionalities
**/

/// @addtogroup my_core
/// @{

void nice();

void hello(const char* name);

/// @brief the int data version
void hello(int data);

/// @brief the templated one
template<typename T>
void hello(const char* naming);

/// @}