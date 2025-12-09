# 🚀 DevApp — Your Personal Tech Growth & Career Companion

DevApp is a powerful, all-in-one platform designed for developers, students, job seekers, and aspiring tech professionals. It helps users learn faster, grow smarter, and build their careers using AI-powered systems, personalized insights, and automation.

Built with scalability using Clean Architecture, SOLID Principles, Firebase, and Hive for offline-ready performance.

---

## 🌟 Key Features

### 📰 Tech News & Startup Insights (API-Free)

* Latest tech news
* Startup insights
* Market trends
* Developer-focused updates
* Aggregated and summarized in real-time without paid APIs

### 💼 Auto Job Apply System

* Finds relevant jobs automatically
* Fills repetitive application forms
* Auto-applies to matching roles (Coming Soon)
* Tracks applied jobs with a smart dashboard

### 🧠 Skill Gap Analysis + Personalized Learning Path

* Analyzes skills, resume, portfolio, and interests
* Recommends skills to learn
* Provides courses, roadmaps, and tasks
* Sets realistic goals based on the user's level

### ✍️ AI Resume & Portfolio Builder

* ATS-optimized resume creation
* Personalized portfolio website generation
* AI-written project descriptions
* Custom cover letters and LinkedIn posts

### 🤖 AI Career Mentor

* 24/7 assistant for technical doubts
* Suggests projects and DSA practice
* Helps with system design, app development, ML, etc.
* Offers interview prep guidance

### 💾 Offline Mode (Hive)

* Save articles and read offline
* Store drafts and notes
* Continue tasks without connectivity

### 🔐 Firebase Authentication

* Secure login/signup
* Google sign-in
* Email/password login
* Encrypted data storage

---

## 🧩 Tech Stack

| Category             | Technology Used                         |
| -------------------- | --------------------------------------- |
| **Frontend**         | Flutter                                 |
| **Backend**          | Firebase (Firestore, Auth, Functions)   |
| **Offline Storage**  | Hive                                    |
| **AI Engine**        | Custom API + Local ML + LLM Integration |
| **Architecture**     | Clean Architecture + SOLID              |
| **State Management** | Riverpod / Provider                     |
| **Deployment**       | Firebase Hosting + Android/iOS          |

---

## 📂 Folder Structure

```
lib/
│
├── main.dart
├── core/                  # Constants, themes, utilities
├── data/                  # Models, repositories, services
│   ├── models/
│   ├── repositories/
│   ├── services/
│       ├── firebase_service.dart
│       ├── hive_service.dart
│
├── domain/                # Entities, use-cases
│
├── presentation/          # Screens, widgets, UI logic
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── job_apply_screen.dart
│   │   ├── news_screen.dart
│   │   ├── learning_path_screen.dart
│   │   ├── ai_assistant_screen.dart
│   │   ├── skill_recommendation_screen.dart
│   │   ├── login_screen.dart
│
├── providers/             # Riverpod/Provider states
└── utils/                 # Helpers, extensions
```

---

## ⚙️ Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/devapp.git
```

### 2. Navigate into the Project

```bash
cd devapp
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Setup Firebase

* Create a Firebase project
* Enable Authentication & Firestore
* Add `google-services.json` to `android/app/`
* Add `GoogleService-Info.plist` to `ios/Runner/`

### 5. Run the App

```bash
flutter run
```

---

## 🛡️ Security

* Firebase Authentication ensures secure user login
* Firestore rules protect user data
* Hive storage is encrypted locally
* Sensitive data is never stored in plain text

---

## 📸 Screenshots

<img width="2752" height="1536" alt="group_1" src="https://github.com/user-attachments/assets/cdea6f23-6912-4a8e-a6b1-966fef1a7b06" />
<img width="2752" height="1536" alt="group_2" src="https://github.com/user-attachments/assets/e9962aa3-a019-4fc5-85fd-ac7cc2b41a8b" />

---

## 🤝 Contributing

Contributions are welcome! Feel free to open an Issue or submit a Pull Request.

---

## 👨‍💻 Author

**Harsh Mule**
📧 Email: [code.harsh26@gmail.com](mailto:code.harsh26@gmail.com)
🌐 Portfolio: [https://codeharsh27-0213cd.webflow.io/](https://codeharsh27-0213cd.webflow.io/)

---

## 📄 License

This project is licensed under the MIT License.
