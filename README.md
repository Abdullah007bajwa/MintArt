# MintArt

**MintArt** is a Flutter-based image generation platform where users can create unique images based on their token balance. It’s designed to provide a seamless and engaging experience, allowing users to sign up, get free tokens, generate images, and easily manage their token balance. The app ensures secure and efficient token management and features a responsive UI that reflects users' balance in real time.

**MintArt** is a perfect tool for artists and creators, offering an intuitive way to access AI-generated art while leveraging a token-based system.

---

## Key Features

- **Token-Based Image Generation**: Users can generate unique images by spending tokens. The app currently provides an unlimited number of tokens (future updates will implement token limits).
- **Free Tokens on Signup**: New users receive a limited number of free tokens to get started with image generation.
- **Easy Image Download**: Users can easily download the generated images.
- **Responsive UI**: A modern, user-friendly design that updates the token balance in real time.
- **Secure Payment Gateway**: A future feature to allow users to purchase more tokens via a secure payment integration.
- **Token Management**: The app includes backend validation for token usage to ensure security and a smooth user experience.
- **Cross-Platform**: Built with Flutter, MintArt is ready to provide a smooth experience on both Web and Android.

---

## Screenshots

![MintArt Screenshot](assets/images/mintart_screenshot1.jpg)  
_Experience unique image generation on MintArt_

![MintArt Screenshot](assets/images/mintart_screenshot2.jpg)  
_A seamless token-based system_

---

## Installation

Follow these steps to get started with MintArt:

1. **Clone the repository**:
    ```bash
    git clone https://github.com/Abdullah007bajwa/MintArt.git
    ```

2. **Install dependencies**:
    Navigate to the project directory and run the following command to install required dependencies:
    ```bash
    flutter pub get
    ```

3. **Configure Firebase**:
    - Set up Firebase for your project by following the Firebase setup guide.
    - Ensure the `firebase_options.dart` file is properly configured with your Firebase project credentials.

4. **Run the app**:
    After setting up Firebase, you can run the app using the following command:
    ```bash
    flutter run
    ```

---

## Tech Stack

- **Flutter**: For building a beautiful, performant, and cross-platform app.
- **Firebase**: Firebase Authentication and Firestore for secure user management and data storage.
- **Rive**: For smooth and interactive animations within the app.
- **Awesome Dialog**: For custom dialog boxes that enhance user interactions.
- **HTTP**: For network requests and token management.
- **Flutter Bloc**: For state management to ensure the app is scalable and maintainable.
- **Flutter Screenutil**: For responsive layout adjustments across various screen sizes.

---

## Directory Structure

Here’s a high-level overview of the project structure:

```plaintext
lib/
├── firebase_options.dart
├── main.dart
├── core/
│   └── widgets/
├── helpers/
├── logic/
│   └── cubit/
├── routing/
├── screens/
├── theming/
    ├── colors.dart
    └── styles.dart
```

- **core/**: Contains reusable widgets and components.
- **helpers/**: Utility functions and helpers.
- **logic/cubit/**: State management for handling authentication and token balance.
- **routing/**: Manages app navigation and routes.
- **screens/**: Contains all the main screens (login, signup, home, etc.).
- **theming/**: Global styles and color schemes.

---

## Future Features

- **Token Limit Implementation**: The token system will soon have limits and be managed through backend validation.
- **Image Generation API**: Future integration with an AI-based image generation API to create high-quality images based on user input.
- **Enhanced Payment System**: Secure payment gateway integration to allow users to purchase more tokens.
- **User Profiles**: Personalized user profiles with image history and custom settings.

---

## Contributing

We welcome contributions to make MintArt even better! If you'd like to contribute, follow these steps:

1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature-branch`)
5. Create a new Pull Request

---

## License

MintArt is open-source and released under the [CC0-1.0 License](https://creativecommons.org/publicdomain/zero/1.0/).

---

## Contact

- **Developer**: Abdullah Bajwa
- **Email**: bajwa15523@gmail.com
- **GitHub**: [Abdullah007bajwa](https://github.com/Abdullah007bajwa)
- **Project Repository**: [MintArt GitHub](https://github.com/Abdullah007bajwa/MintArt)
