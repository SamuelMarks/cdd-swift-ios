TOOL_NAME = cdd-swift
VERSION = 0.1.0
BUILD_DIR = $(PWD)
CURRENT_PATH = $(PWD)
BUILD_PATH = .build/release/$(TOOL_NAME)
PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(TOOL_NAME)

install:
	swift build --disable-sandbox -c release
	cp $(BUILD_PATH) ~/.bin/$(TOOL_NAME)

build:
	swift build
	
run: build
	.build/debug/cdd-swift Models.swift

clean:
	swift package clean