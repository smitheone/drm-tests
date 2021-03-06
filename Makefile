# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Pull in chromium os defaults
OUT ?= $(PWD)/build-opt-local

include common.mk

PC_DEPS = libdrm egl gbm
PC_CFLAGS := $(shell $(PKG_CONFIG) --cflags $(PC_DEPS))
PC_LIBS := $(shell $(PKG_CONFIG) --libs $(PC_DEPS))

DRM_LIBS = -lGLESv2
CFLAGS += $(PC_CFLAGS)
LDLIBS += $(PC_LIBS)

all: CC_BINARY(null_platform_test) CC_BINARY(vgem_test) CC_BINARY(vgem_fb_test) CC_BINARY(swrast_test) CC_BINARY(atomictest) CC_BINARY(gamma_test)

CC_BINARY(null_platform_test): null_platform_test.o
CC_BINARY(null_platform_test): LDLIBS += $(DRM_LIBS)

CC_BINARY(vgem_test): vgem_test.o
CC_BINARY(vgem_fb_test): vgem_fb_test.o

CC_BINARY(swrast_test): swrast_test.o
CC_BINARY(swrast_test): LDLIBS += -lGLESv2

CC_BINARY(atomictest): atomictest.o bo.o dev.o modeset.o
CC_BINARY(atomictest): CFLAGS += -DUSE_ATOMIC_API
CC_BINARY(atomictest): LDLIBS += $(DRM_LIBS)

CC_BINARY(gamma_test): gamma_test.o dev.o bo.o modeset.o
CC_BINARY(gamma_test): LDLIBS += -lm $(DRM_LIBS)
