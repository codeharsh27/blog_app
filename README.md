# 📰 Blog App

A modern and feature-rich **Blog Application** that keeps users updated with the **latest tech news** and **job alerts**, while also allowing them to **create and share their own blogs**.
Built with **Clean Architecture** and following **SOLID Principles**, this app ensures maintainability, scalability, and readability with a seamless user experience. It integrates **Firebase Authentication** for secure user management and **Hive** for efficient **offline storage**.

---

## 🚀 Features

* 🧠 **Tech News Feed** – Stay up-to-date with the latest trends, innovations, and insights in the tech industry.
* 💼 **Job Alerts** – Get notified about new job opportunities tailored for developers and tech enthusiasts.
* ✍️ **User Blogs** – Create, edit, and upload your own blog posts to share your thoughts with the community.
* 🔐 **Firebase Authentication** – Secure login and signup functionality with Google and Email/Password support.
* 💾 **Offline Mode (Hive Integration)** – Read saved blogs and drafts even without an internet connection.
* 🧱 **Clean Architecture + SOLID Principles** – Ensures maintainable, scalable, and testable code structure.
* 🌙 **Modern UI/UX** – Clean, intuitive interface for smooth reading and writing experience.

---

## 🧩 Tech Stack

| Category                 | Technology Used                                    |
| ------------------------ | -------------------------------------------------- |
| **Frontend**             | Flutter                                            |
| **Backend**              | Firebase (Firestore & Auth)                        |
| **Offline Storage**      | Hive                                               |
| **Authentication**       | Firebase Auth                                      |
| **Architecture Pattern** | Clean Architecture                                 |
| **Principles Followed**  | SOLID Principles                                   |
| **State Management**     | Provider / Riverpod (based on your implementation) |

---

## ⚙️ Installation

Follow these steps to run the project locally:

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/blog-app.git
   ```
2. **Navigate to the project directory**

   ```bash
   cd blog-app
   ```
3. **Install dependencies**

   ```bash
   flutter pub get
   ```
4. **Set up Firebase**

   * Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   * Enable Authentication and Firestore Database
   * Download the `google-services.json` file and add it to `android/app/`
   * For iOS, add the corresponding `GoogleService-Info.plist` to your iOS project folder
5. **Run the app**

   ```bash
   flutter run
   ```

---

## 🧠 Folder Structure

```
lib/
│
├── main.dart
├── core/                  # Constants, utilities, theme, and error handling
├── data/                  # Data sources, repositories, and models
│   ├── models/
│   ├── repositories/
│   ├── services/
│   │   ├── firebase_service.dart
│   │   ├── hive_service.dart
│
├── domain/                # Business logic, entities, and use-cases
├── presentation/          # Screens, widgets, and state management
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── blog_screen.dart
│   │   ├── add_blog_screen.dart
│   │   ├── login_screen.dart
│
├── providers/
└── utils/
```

---

## 📱 Screenshots

<img width="1920" height="1080" alt="devapp" src="https://github.com/user-attachments/assets/9b1137e0-86a7-4451-b9a7-31ae388cde6b" />
<img width="1920" height="1080" alt="Tech news and Job alerts (1)" src="https://github.com/user-attachments/assets/9fa1761b-8212-4b9c-abd2-394eb6503d72" />


---

## 🛡️ Security

* User data is protected using **Firebase Authentication**.
* Blogs and job data are securely stored in **Cloud Firestore**.
* Sensitive data is never stored in plain text locally.

---

## 🤝 Contributing

Contributions are welcome!
If you have suggestions or find any issues, feel free to open an **Issue** or submit a **Pull Request**.

---

## 🧑‍💻 Author

**Harsh Mule**
📧 [[your.email@example.com](mailto:your.email@example.com)]
🌐 [LinkedIn Profile or Portfolio link]

---

## 🏁 License

This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file for details.
