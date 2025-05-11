################################################################################
## CONFIG ######################################################################
################################################################################

PROJECT_NAME	:= verdant
PROJECT_VERSION	:= 0.1.0
PROJECT_BUILD	?= debug
PROJECT_STRICT	?= nostrict

PROJECT_CC	?= clang-19
PROJECT_LD	?= clang-19
PROJECT_AR	?= ar

################################################################################
## FILES AND FOLDERS ###########################################################
################################################################################

BIN_DIR			:= bin
OBJ_DIR			:= obj
RES_DIR			:= res
LOG_DIR			:= log
VENDOR_DIR		:= vendor

SYSTEMS_SRC_DIR		:= verdant-systems
API_SRC_DIR		:= verdant-api
ENGINE_SRC_DIR		:= verdant-engine
GAME_SRC_DIR		:= verdant
TESTING_SRC_DIR		:= verdant-testing
SYSTEMS_TEST_SRC_DIR	:= verdant-systems_test
API_TEST_SRC_DIR	:= verdant-api_test
ENGINE_TEST_SRC_DIR	:= verdant-engine_test
GAME_TEST_SRC_DIR	:= verdant_test

SYSTEMS_SRC		:= $(wildcard $(SYSTEMS_SRC_DIR)/*.c)
API_SRC			:= $(wildcard $(API_SRC_DIR)/*.c)
ENGINE_MAIN_SRC		:= $(ENGINE_SRC_DIR)/main.c
ENGINE_SRC		:= $(filter-out $(ENGINE_MAIN_SRC),$(wildcard $(ENGINE_SRC_DIR)/*.c))
GAME_SRC		:= $(wildcard $(GAME_SRC_DIR)/*.c)
TESTING_SRC		:= $(wildcard $(TESTING_SRC_DIR)/*.c)
SYSTEMS_TEST_SRC	:= $(wildcard $(SYSTEMS_TEST_SRC_DIR)/*.c)
API_TEST_SRC		:= $(wildcard $(API_TEST_SRC_DIR)/*.c)
ENGINE_TEST_SRC		:= $(wildcard $(ENGINE_TEST_SRC_DIR)/*.c)
GAME_TEST_SRC		:= $(wildcard $(GAME_TEST_SRC_DIR)/*.c)

SYSTEMS_OBJ		:= $(SYSTEMS_SRC:%.c=$(OBJ_DIR)/%.o)
API_OBJ			:= $(API_SRC:%.c=$(OBJ_DIR)/%.o)
ENGINE_MAIN_OBJ		:= $(ENGINE_MAIN_SRC:%.c=$(OBJ_DIR)/%.o)
ENGINE_OBJ		:= $(ENGINE_SRC:%.c=$(OBJ_DIR)/%.o)
GAME_OBJ		:= $(GAME_SRC:%.c=$(OBJ_DIR)/%.o)
TESTING_OBJ		:= $(TESTING_SRC:%.c=$(OBJ_DIR)/%.o)
SYSTEMS_TEST_OBJ	:= $(SYSTEMS_TEST_SRC:%.c=$(OBJ_DIR)/%.o)
API_TEST_OBJ		:= $(API_TEST_SRC:%.c=$(OBJ_DIR)/%.o)
ENGINE_TEST_OBJ		:= $(ENGINE_TEST_SRC:%.c=$(OBJ_DIR)/%.o)
GAME_TEST_OBJ		:= $(GAME_TEST_SRC:%.c=$(OBJ_DIR)/%.o)

SYSTEMS_DEP		:= $(SYSTEMS_OBJ:.o=.d)
API_DEP			:= $(API_OBJ:.o=.d)
ENGINE_MAIN_DEP		:= $(ENGINE_MAIN_OBJ:.o=.d)
ENGINE_DEP		:= $(ENGINE_OBJ:.o=.d)
GAME_DEP		:= $(GAME_OBJ:.o=.d)
TESTING_DEP		:= $(TESTING_OBJ:.o=.d)
SYSTEMS_TEST_DEP	:= $(SYSTEMS_TEST_OBJ:.o=.d)
API_TEST_DEP		:= $(API_TEST_OBJ:.o=.d)
ENGINE_TEST_DEP		:= $(ENGINE_TEST_OBJ:.o=.d)
GAME_TEST_DEP		:= $(GAME_TEST_OBJ:.o=.d)

ALL_OBJ			:= $(SYSTEMS_OBJ) $(API_OBJ) $(ENGINE_MAIN_OBJ) $(ENGINE_OBJ) \
                           $(GAME_OBJ) $(TESTING_OBJ) \
                           $(SYSTEMS_TEST_OBJ) $(API_TEST_OBJ) $(ENGINE_TEST_OBJ) \
                           $(GAME_TEST_OBJ)
ALL_DEP			:= $(SYSTEMS_DEP) $(API_DEP) $(ENGINE_MAIN_DEP) $(ENGINE_DEP) \
                           $(GAME_DEP) $(TESTING_DEP) \
                           $(SYSTEMS_TEST_DEP) $(API_TEST_DEP) $(ENGINE_TEST_DEP) \
                           $(GAME_TEST_DEP)

SYSTEMS_LIB_NAME	:= $(PROJECT_NAME)_systems
API_LIB_NAME		:= $(PROJECT_NAME)_api
ENGINE_LIB_NAME		:= $(PROJECT_NAME)_engine
GAME_LIB_NAME		:= $(PROJECT_NAME)_game
TESTING_LIB_NAME	:= $(PROJECT_NAME)_testing
SYSTEMS_TEST_NAME	:= $(SYSTEMS_LIB_NAME)-test
API_TEST_NAME		:= $(API_LIB_NAME)-test
ENGINE_TEST_NAME	:= $(ENGINE_LIB_NAME)-test
GAME_TEST_NAME		:= $(GAME_LIB_NAME)-test

SYSTEMS_LIB		:= $(BIN_DIR)/lib$(SYSTEMS_LIB_NAME).a
API_LIB			:= $(BIN_DIR)/lib$(API_LIB_NAME).a
ENGINE_LIB		:= $(BIN_DIR)/lib$(ENGINE_LIB_NAME).so
ENGINE_EXE		:= $(BIN_DIR)/$(PROJECT_NAME)
GAME_LIB		:= $(BIN_DIR)/lib$(GAME_LIB_NAME).so
TESTING_LIB		:= $(BIN_DIR)/lib$(TESTING_LIB_NAME).a
SYSTEMS_TEST		:= $(BIN_DIR)/$(SYSTEMS_TEST_NAME)
API_TEST		:= $(BIN_DIR)/$(API_TEST_NAME)
ENGINE_TEST		:= $(BIN_DIR)/$(ENGINE_TEST_NAME)
GAME_TEST		:= $(BIN_DIR)/$(GAME_TEST_NAME)

################################################################################
## COMPILER ####################################################################
################################################################################

CC		:= $(PROJECT_CC)
LD		:= $(PROJECT_LD)
AR		:= $(PROJECT_AR)

CFLAGS		+= -std=c2x -g -MMD -Wall -Wextra -Wpedantic -I$(PWD) -I$(VENDOR_DIR)
LDFLAGS		+= -L$(BIN_DIR) -L$(VENDOR_DIR) -lglad -lglfw3 -lstb -lm
ARFLAGS		:= rcs

ifeq ($(PROJECT_BUILD),debug)
	CFLAGS += -O0
endif
ifeq ($(PROJECT_BUILD),release)
	CFLAGS += -O3 -DNDEBUG
endif
ifeq ($(PROJECT_STRICT),strict)
	CFLAGS += -Werror
endif

$(ENGINE_EXE):	LDFLAGS += -l$(ENGINE_LIB_NAME)
$(ENGINE_LIB):	LDFLAGS += -shared
$(GAME_LIB):	LDFLAGS += -shared -l$(ENGINE_LIB_NAME)

################################################################################
## COMMANDS ####################################################################
################################################################################

MKDIR_P	:= mkdir -p
RM_F	:= rm -f
RM_RF	:= rm -rf

################################################################################
## TARGETS #####################################################################
################################################################################

.PHONY: all run test clean

all: $(ENGINE_EXE) $(GAME_LIB)
test: $(SYSTEMS_TEST) $(API_TEST) $(ENGINE_TEST) $(GAME_TEST)
	./$(SYSTEMS_TEST)
	./$(API_TEST)
	./$(ENGINE_TEST)
	./$(GAME_TEST)
run: all
	LD_LIBRARY_PATH=$(BIN_DIR) ./$(ENGINE_EXE) \
                --log-dir  $(LOG_DIR) \
                --user-dir $(HOME)/.$(PROJECT_NAME) \
                --mods-dir $(BIN_DIR)

$(ENGINE_EXE): $(ENGINE_MAIN_OBJ) | $(ENGINE_LIB)
	@$(MKDIR_P) $(@D)
	$(LD) -o $@ $^ $(LDFLAGS)
$(ENGINE_LIB): $(ENGINE_OBJ) $(API_LIB) $(SYSTEMS_LIB)
	@$(MKDIR_P) $(@D)
	$(LD) -o $@ $^ $(LDFLAGS)
$(GAME_LIB): $(GAME_OBJ) $(ENGINE_LIB)
	@$(MKDIR_P) $(@D)
	$(LD) -o $@ $^ $(LDFLAGS)
$(API_LIB): $(API_OBJ)
	@$(MKDIR_P) $(@D)
	$(AR) $(ARFLAGS) $@ $^
$(SYSTEMS_LIB): $(SYSTEMS_OBJ)
	@$(MKDIR_P) $(@D)
	$(AR) $(ARFLAGS) $@ $^
$(TESTING_LIB): $(TESTING_OBJ)
	@$(MKDIR_P) $(@D)
	$(AR) $(ARFLAGS) $@ $^

$(SYSTEMS_TEST): $(SYSTEMS_TEST_OBJ) $(SYSTEMS_LIB) $(TESTING_LIB)
	@$(MKDIR_P) $(@D)
	$(LD) -o $@ $^ $(LDFLAGS)
$(API_TEST): $(API_TEST_OBJ) $(API_LIB) $(TESTING_LIB)
	@$(MKDIR_P) $(@D)
	$(LD) -o $@ $^ $(LDFLAGS)
$(ENGINE_TEST): $(ENGINE_TEST_OBJ) $(ENGINE_LIB) $(TESTING_LIB)
	@$(MKDIR_P) $(@D)
	$(LD) -o $@ $^ $(LDFLAGS)
$(GAME_TEST): $(GAME_TEST_OBJ) $(ENGINE_LIB) $(TESTING_LIB)
	@$(MKDIR_P) $(@D)
	$(LD) -o $@ $^ $(LDFLAGS)

-include $(ALL_DEP)
$(ALL_OBJ): $(OBJ_DIR)/%.o: %.c
	@$(MKDIR_P) $(@D)
	$(CC) -o $@ -c $< $(CFLAGS)

clean:
	$(RM_RF) $(BIN_DIR)
	$(RM_RF) $(OBJ_DIR)
	$(RM_RF) $(LOG_DIR)
