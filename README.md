# Tellie  - Interactive Storytelling App for Kids

An interactive Flutter mobile application that enables children (ages 6-10) to co-create unique stories with an AI storyteller through voice interaction.

## 🌟 Features

- **Interactive Storytelling**: Real-time voice conversation with AI storyteller
- **Character Selection**: Choose from pre-defined characters for stories
- **Visual Inspiration**: Upload images to inspire story settings
- **Story Library**: Save and revisit completed stories
- **Animated UI**: Engaging animations with Lottie
- **Cross-Platform**: Runs on iOS and Android from single codebase
- **Child-Safe**: Content filtering and age-appropriate interactions

## 🏗️ Architecture

### Frontend (Flutter)
- **Framework**: Flutter 3.16.0+
- **State Management**: Riverpod + Hooks
- **Navigation**: GoRouter
- **Local Storage**: Hive
- **Audio**: Record + Just Audio
- **Real-time Communication**: LiveKit
- **Network**: Dio
- **Animations**: Lottie

### Backend (Node.js)
- **Framework**: Express.js
- **Real-time Audio**: LiveKit Server SDK
- **Speech-to-Text**: OpenAI Whisper
- **AI Responses**: OpenAI GPT-4
- **Text-to-Speech**: ElevenLabs
- **File Upload**: Multer

## 📁 Project Structure

```
lib/
├── src/
│   ├── features/
│   │   ├── home/
│   │   │   └── presentation/
│   │   ├── story_creation/
│   │   │   ├── application/     # Riverpod controllers
│   │   │   ├── domain/          # Models and entities
│   │   │   └── presentation/    # UI widgets
│   │   └── story_library/
│   │       ├── domain/
│   │       └── presentation/
│   ├── common_widgets/          # Reusable UI components
│   ├── core/
│   │   ├── constants/           # App constants
│   │   └── theme/               # App theming
│   ├── routing/                 # Navigation setup
│   └── services/                # API clients
├── assets/
│   ├── animations/              # Lottie animations
│   ├── audio/                   # Sound effects
│   └── images/                  # Static images
└── main.dart
```

## 🚀 Getting Started

### Prerequisites

- **Flutter**: 3.16.0 or higher
- **Dart**: 3.8.0 or higher
- **Node.js**: 16.0.0 or higher (for backend)
- **iOS**: Xcode 15+ (for iOS development)
- **Android**: Android Studio with API level 21+

### Flutter Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd rakshu
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   # For iOS
   flutter run -d ios
   
   # For Android
   flutter run -d android
   ```

### Backend Setup

1. **Navigate to project root and setup backend**
   ```bash
   # Copy the backend package.json
   cp backend-package.json package.json
   
   # Install Node.js dependencies
   npm install
   ```

2. **Set up environment variables**
   ```bash
   # Create .env file
   LIVEKIT_API_KEY=your-livekit-api-key
   LIVEKIT_API_SECRET=your-livekit-api-secret
   OPENAI_API_KEY=your-openai-api-key
   ELEVENLABS_API_KEY=your-elevenlabs-api-key
   ```

3. **Start the backend server**
   ```bash
   # Development mode
   npm run dev
   
   # Production mode
   npm start
   ```

4. **Verify backend is running**
   ```bash
   curl http://localhost:3000/health
   ```

## 🎯 Key Components

### Story Creation Flow

1. **Home Screen**: Entry point with beautiful animations
2. **Story Setup**: Character selection, image upload, initial prompt
3. **Interactive Storytelling**: Real-time voice interaction with AI
4. **Story Library**: Browse and manage saved stories

### State Management

The app uses **Riverpod** for robust state management:

- `StorySetupController`: Manages story creation setup
- `StorytellingController`: Handles real-time storytelling session
- Providers for services (API, audio, etc.)

### Audio Pipeline

1. **Recording**: Uses `record` package for audio capture
2. **Upload**: Sends audio to backend via Dio
3. **Processing**: Backend handles STT → LLM → TTS pipeline
4. **Playback**: Uses `just_audio` for AI response playback

## 🔧 Configuration

### App Constants

Key configuration in `lib/src/core/constants/app_constants.dart`:

- API endpoints
- Animation paths
- UI dimensions
- Audio settings
- Content filtering

### Theming

Custom theme implementation in `lib/src/core/theme/app_theme.dart`:

- Light and dark mode support
- Child-friendly color palette
- Consistent typography with Poppins font

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## 📱 Platform-Specific Setup

### iOS

1. Update `ios/Runner/Info.plist` with required permissions:
   ```xml
   <key>NSMicrophoneUsageDescription</key>
   <string>This app needs microphone access for voice storytelling.</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>This app needs photo access to add inspiration images.</string>
   ```

2. Set deployment target to iOS 12.0+ in Xcode

### Android

1. Update `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.RECORD_AUDIO" />
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
   <uses-permission android:name="android.permission.INTERNET" />
   ```

2. Set minimum SDK version to 21 in `android/app/build.gradle`

## 🔒 Security & Privacy

- All AI interactions are proxied through backend with content filtering
- Child-safe personality enforced in AI prompts
- No sensitive data stored locally
- Audio recordings are temporary and deleted after processing
- Parental controls and content moderation

## 🚢 Deployment

### Flutter App

```bash
# Build for release
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

### Backend

Deploy to your preferred cloud platform:
- **AWS**: Use EC2 or Lambda
- **Google Cloud**: Use Cloud Run or Compute Engine
- **Heroku**: Direct deployment support
- **Docker**: Containerized deployment

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🎨 Design Credits

- **Animations**: Custom Lottie animations
- **Icons**: Material Icons
- **Font**: Poppins (Google Fonts)
- **Color Palette**: Child-friendly custom design

## 📞 Support

For support, please contact the Tellie team or create an issue in the repository.

---

**Tellie ** - Empowering children's creativity through interactive storytelling! 🌟📚✨
