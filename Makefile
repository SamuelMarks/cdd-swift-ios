BUILD_DIR=.

run:
	swift build && .build/debug/cdd-swift Models.swift
