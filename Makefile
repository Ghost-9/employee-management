# Project Metadata
APP_NAME := Employee Management
BUILD_DIR := build
OUTPUT_DIR := $(BUILD_DIR)/app/outputs/flutter-apk
APK := $(OUTPUT_DIR)/app-release.apk
AAB_DIR := $(BUILD_DIR)/app/outputs/bundle/release
BASE_HREF = /$(OUTPUT)/
GITHUB_USER = Ghost-9
GITHUB_REPO = https://github.com/$(GITHUB_USER)/$(OUTPUT)
BUILD_VERSION := $(shell grep 'version:' pubspec.yaml | awk '{print $$2}')

# Flutter Optimization Flags
FLUTTER_FLAGS := --release --split-per-abi --obfuscate --tree-shake-icons
AAB_FLAGS := --release --obfuscate --tree-shake-icons
DART_DEFINES := --dart-define=FLUTTER_WEB_USE_SKIA=true --dart-define=FLUTTER_COMPRESSED=true
DEBUG_INFO_DIR := build/debug-info/

.PHONY: all clean apk aab deploy info

all: apk deploy

info:
	@echo "📌 Flutter Version: $(shell flutter --version | head -n 1)"
	@echo "📦 Building $(APP_NAME)..."
	@echo "🔹 APK Output: $(APK)"
	@echo "🔹 AAB Output: $(AAB_DIR)"
	@echo "🔹 Build Version: $(BUILD_VERSION)"

clean:
	@echo "🧹 Cleaning build files..."
	flutter clean

apk: clean
	@echo "📦 Building optimized APK with obfuscation and performance tweaks..."
	mkdir -p $(DEBUG_INFO_DIR)
	flutter build apk $(FLUTTER_FLAGS) $(DART_DEFINES) --split-debug-info=$(DEBUG_INFO_DIR)
	@echo "✅ APK build complete!"
	@ls -lh $(OUTPUT_DIR)

aab: clean
	@echo "📦 Building optimized AAB with obfuscation and performance tweaks..."
	mkdir -p $(DEBUG_INFO_DIR)
	flutter build appbundle $(AAB_FLAGS) $(DART_DEFINES) --split-debug-info=$(DEBUG_INFO_DIR)
	@echo "✅ AAB build complete!"
	@ls -lh $(AAB_DIR)

deploy:
ifndef OUTPUT
	$(error OUTPUT is not set. Usage: make deploy OUTPUT=<output_repo_name>)
endif

	@echo "🚀 Cleaning existing repository..."
	flutter clean

	@echo "📦 Getting dependencies..."
	flutter pub get

	@echo "🔄 Generating Flutter web platform..."
	flutter create . --platform web

	@echo "🌍 Building Flutter Web..."
	flutter build web --base-href $(BASE_HREF) --release --tree-shake-icons --pwa-strategy offline-first

	@echo "🚀 Deploying to GitHub Pages..."
	cd build/web && \
	git init && \
	git add . && \
	git commit -m "Deploy Version $(BUILD_VERSION)" && \
	git branch -M gh-pages && \
	git remote add origin $(GITHUB_REPO) && \
	git push -u -f origin gh-pages

	@echo "✅ Deployment Complete!"
	@echo "🌐 View live at: https://$(GITHUB_USER).github.io/$(OUTPUT)/"