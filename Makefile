TMP = tmp
DIST = dist
OBJDIR = .obj
GENERATED = src/generated
ENTRYPOINT = $(OBJDIR)/entrypoint.o
C_ENTRYPOINT = src/native/entrypoint.c
JS_ENTRYPOINT = $(GENERATED)/js-entrypoint.c
NATIVE_BINDINGS = $(wildcard src/native/binding/*.c)
BIN = $(DIST)/app
SDL2_VERSION = 2.0.10
SDL2_FRAMEWORK = $(TMP)/SDL2.framework
CC_SDL2_OPTIONS_MACOS = -rpath @executable_path/../Frameworks -F $(TMP) -framework SDL2

.PHONY: all
all: clean prod

.PHONY: clean
clean:
	-@$(RM) -rf $(TMP) $(DIST) $(OBJDIR) $(GENERATED)

.PHONY: prod
prod: dev
	cp -R dev/gawain.app $(DIST)/gawain.app
	@mkdir -p $(DIST)/gawain.app/Contents/MacOS
	cp $(BIN) $(DIST)/gawain.app/Contents/MacOS/app
	@mkdir -p $(DIST)/gawain.app/Contents/Frameworks
	cp -R $(SDL2_FRAMEWORK) $(DIST)/gawain.app/Contents/Frameworks/SDL2.framework

.PHONY: dev
dev: $(BIN)

$(BIN): $(ENTRYPOINT) $(patsubst src/native/binding/%.c, $(OBJDIR)/%.o, $(NATIVE_BINDINGS))
	@mkdir -p $(DIST)
	$(CC) $(CC_SDL2_OPTIONS_MACOS) -L/usr/local/lib/quickjs -lquickjs -o $@ $^

$(ENTRYPOINT): $(JS_ENTRYPOINT) $(C_ENTRYPOINT)
	@mkdir -p $(OBJDIR)
	$(CC) $(CC_SDL2_OPTIONS_MACOS) -I/usr/local/include/quickjs -c -o $@ $(C_ENTRYPOINT)

$(OBJDIR)/%.o: src/native/binding/%.c $(SDL2_FRAMEWORK)
	@mkdir -p $(OBJDIR)
	$(CC) $(CC_SDL2_OPTIONS_MACOS) -I/usr/local/include/quickjs -c -o $@ $<

$(JS_ENTRYPOINT): src/entrypoint.js
	@mkdir -p $(GENERATED)
	qjsc -c -m -M sdl.so,sdl -o $@ src/entrypoint.js

$(SDL2_FRAMEWORK):
	@mkdir -p $(TMP)
	curl -o "$(TMP)/SDL2-$(SDL2_VERSION).dmg" https://www.libsdl.org/release/SDL2-$(SDL2_VERSION).dmg
	hdiutil mount $(TMP)/SDL2-$(SDL2_VERSION).dmg
	cp -R /Volumes/SDL2/SDL2.framework $(SDL2_FRAMEWORK)
	hdiutil unmount /Volumes/SDL2
