CC = g++
CFLAGS = -std=c++17 -O3 -Wall
LDFLAGS = `pkg-config --static --libs glfw3` -lvulkan

INC_DIR = ./src ./src/vulkanBase ./src/vulkanApp ./src/myImgui ./imgui 
INC =$(foreach d, $(INC_DIR), -I$d)
HEADER = $(foreach d, $(INC_DIR), $(wildcard $d/*.h))
SOURCE = $(wildcard src/vulkanBase/*.cpp src/vulkanApp/*.cpp src/myImgui/*.cpp imgui/*.cpp *.cpp)
O_OBJECT= $(SOURCE:%.cpp=%.o)

all: $(O_OBJECT) VulkanTest

VulkanTest: $(O_OBJECT)
	$(CC) $(CFLAGS) $^ $(LDFLAGS)  -o $@ 

$(O_OBJECT): %.o : %.cpp 
	$(CC) $(CFLAGS) -c $^ $(INC)  -o $@ 

.PHONY: test clean

test: VulkanTest
	/usr/share/vulkan/explicit_layer.d ./VulkanTest

clean:
	find . -type f -name '*.o' -delete
	rm -f VulkanTest

.PHONY: clang-format
clang-format:
	/bin/bash ./clang-format-wrapper.sh $(SOURCE) $(HEADER)
	clang-format -i -style=file $(SOURCE) $(HEADER)