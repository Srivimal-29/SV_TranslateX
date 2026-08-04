# SV TranslateX 🌐

> **Translate · Connect · Understand**

A premium, production-ready Flutter translation app supporting **100+ languages** with **voice input**, **text-to-speech output**, **offline detection**, and an automated **CI/CD pipeline** to GitHub Pages.

---

## ✨ Features

| Feature | Description |
| :--- | :--- |
| 🌍 **100+ Languages** | Translate between any of 100+ world languages using a dual-engine approach |
| 🎙️ **Voice Input (STT)** | Speak directly into the microphone to transcribe and translate |
| 🔊 **Text-to-Speech (TTS)** | Hear translations spoken aloud in the target language |
| 🔁 **Dual-Engine Fallback** | Primary: Google Translate GTX API → Fallback: MyMemory API |
| 📶 **Offline Detection** | Gracefully handles no-internet state with visual indicators |
| 💾 **Translation History** | Saves last 50 translations locally using SharedPreferences |
| 🎨 **Premium Dark UI** | Custom SV TranslateX red & silver emblem branding |
| 🚀 **Automated CI/CD** | GitHub Actions auto-builds & deploys Flutter Web to GitHub Pages |

---

## 📱 Platform Support

| Platform | Status |
| :--- | :--- |
| Android | ✅ Release APK |
| Web (PWA) | ✅ GitHub Pages |
| Windows | ✅ Desktop |
| iOS | 🔧 Requires macOS for build |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0 <4.0.0`
- Dart SDK
- Android SDK (for APK builds)
- Chrome (for web dev)

### Clone & Run

```bash
git clone https://github.com/Srivimal-29/SV_TranslateX.git
cd SV_TranslateX
flutter pub get
flutter run -d chrome    # Web
flutter run              # Android / default device
```

### Build Release APK

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Build Release Web

```bash
flutter build web --release --base-href /SV_TranslateX/
```

---

## 🏗️ Architecture

```
lib/
├── main.dart                     # App entry point, theme & providers
├── models/
│   ├── language.dart             # Language model (100+ languages)
│   └── translation_history.dart  # History model with JSON serialization
├── providers/
│   └── translator_provider.dart  # State management (ChangeNotifier)
├── screens/
│   ├── home_screen.dart          # Main translation screen
│   └── history_screen.dart       # Translation history browser
├── services/
│   ├── translation_service.dart  # Dual-engine translation API
│   ├── tts_service.dart          # Text-to-Speech wrapper
│   ├── stt_service.dart          # Speech-to-Text wrapper
│   └── connectivity_service.dart # Online/offline detection
└── widgets/
    ├── translation_card.dart     # Input/output card with mic & TTS
    └── language_selector.dart    # Modal bottom sheet language picker
```

---

## 🧪 Tests

```bash
flutter test
```

Tests cover:
- `TranslationService` — empty input, whitespace, valid translation, auto-detect
- `TranslatorProvider` — all state transitions (10 tests)
- `Language` model — auto-detect, 50+ languages, list integrity
- `TranslationHistory` model — JSON round-trip, timestamp preservation

---

## 🚀 CI/CD Pipeline

Every push to `main` triggers:
1. ✅ Flutter SDK setup (stable channel)
2. ✅ `flutter pub get`
3. ✅ `flutter build web --release --base-href /SV_TranslateX/`
4. ✅ Deploy `build/web` to `gh-pages` branch via GitHub Actions

**Live App**: [https://srivimal-29.github.io/SV_TranslateX/](https://srivimal-29.github.io/SV_TranslateX/)

---

## 📦 Dependencies

| Package | Purpose |
| :--- | :--- |
| `http` | HTTP API calls |
| `provider` | State management |
| `flutter_tts` | Text-to-speech output |
| `speech_to_text` | Voice input recognition |
| `shared_preferences` | Local history storage |
| `flutter_animate` | UI micro-animations |
| `google_fonts` | Inter & Outfit typography |

---

## 📄 License

This project is for personal/educational use. © 2026 Srivimal.
