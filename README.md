# Shoofly - Car Spare Parts App

A modern Flutter application for finding and ordering car spare parts with a beautiful blue and orange UI theme.

## Features

### 🔐 Authentication
- **Login Screen**: Secure user authentication
- **Signup Screen**: New user registration
- **Forgot Password**: Password reset functionality
- **Reset Password**: Complete password reset flow

### 🏠 Home Screen
- Welcome message with user name
- Current location display with refresh capability
- Recent requests history
- Quick access to find spare parts

### 📸 Camera Integration
- Take photos of car parts using camera
- Select images from gallery
- Multiple image selection support
- Image preview and management

### 💰 Price Range Selection
- Set desired price range for parts
- Add part details and description
- Select urgency level (Normal/Urgent)
- Submit requests to backend

### 🔍 Request Status
- Real-time search progress
- Visual progress timeline
- Request details display
- Animated status updates

### 🏪 Store Selection
- View available stores with parts
- Compare prices and ratings
- Store verification badges
- Distance and delivery time information
- Order placement functionality

### 👤 Profile Management
- Edit personal information
- View order history
- App settings and preferences
- Logout functionality

## Technologies Used

- **Flutter**: Cross-platform mobile development
- **Dart**: Programming language
- **Google Fonts**: Modern typography
- **Image Picker**: Camera and gallery access
- **Geolocator**: Location services
- **Shared Preferences**: Local data storage
- **HTTP**: API communication

## UI/UX Features

### 🎨 Modern Design
- **Primary Colors**: Shiny Blue (#2196F3) and Orange (#FF9800)
- **Gradients**: Beautiful gradient backgrounds
- **Animations**: Smooth transitions and loading states
- **Material Design**: Following Material 3 guidelines

### 📱 Responsive Layout
- Optimized for different screen sizes
- Consistent spacing and typography
- Touch-friendly interface elements

## Backend Integration Ready

The app is designed to work with a Node.js + PostgreSQL + Express backend:

### API Endpoints Structure
```
POST /auth/login          - User authentication
POST /auth/register       - User registration
POST /auth/forgot-password - Password reset request
POST /auth/reset-password  - Password reset confirmation
POST /upload/image        - Image upload
POST /requests/create     - Create spare part request
GET  /stores              - Get available stores
POST /orders/create       - Place order
```

## Installation & Setup

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Android Studio / VS Code
- Android device or emulator

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.1.0
  image_picker: ^1.0.4
  geolocator: ^9.0.2
  permission_handler: ^11.0.1
  shared_preferences: ^2.2.2
  google_fonts: ^6.1.0
```

### Running the App

1. **Clone and Setup**
   ```bash
   cd "path/to/shoofly"
   flutter pub get
   ```

2. **Run on Device/Emulator**
   ```bash
   flutter run
   ```

3. **Build APK**
   ```bash
   flutter build apk --release
   ```

## Permissions

The app requires the following permissions:
- **Camera**: For taking photos of car parts
- **Location**: For finding nearby stores
- **Storage**: For saving and accessing images
- **Internet**: For API communication

## App Flow

1. **Splash Screen** → Shows app logo and checks login status
2. **Authentication** → Login/Signup/Password Reset
3. **Home Screen** → Welcome + Location + Recent Requests
4. **Camera Screen** → Take/Select photos of car parts
5. **Price Range** → Set budget and part details
6. **Request Status** → Real-time search progress
7. **Store Selection** → Choose from available stores
8. **Order Confirmation** → Complete the purchase

## Features for Backend Integration

### User Management
- JWT token authentication
- User profile management
- Password reset with email verification

### Request Processing
- Image upload and processing
- AI/ML integration for part recognition
- Real-time store inventory checking

### Store Management
- Partner store integration
- Real-time pricing updates
- Delivery time calculations
- Order tracking system

## Future Enhancements

- 🔔 Push notifications
- 💬 In-app chat with stores
- ⭐ Rating and review system
- 📍 Real-time order tracking
- 💳 Multiple payment options
- 🌐 Multi-language support

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.

---

**Shoofly** - Making car spare parts accessible and affordable! 🚗✨
