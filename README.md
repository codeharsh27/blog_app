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
<img width="1080" height="2424" alt="application_page" src="https://github.com/user-attachments/assets/c7dc1f69-5984-46e9-bc97-ec78af7d4424" />
<img width="1080" height="2424" alt="app_logo" src="https://github.com/user-attachments/assets/6cae8a7a-e6a5-4b08-a11b-9416867cab9a" />
<img width="1080" height="2424" alt="template_selection" src="https://github.com/user-attachments/assets/d92944bc-7d20-4a14-ab77-bbb3bc55872c" />
<img width="1080" height="2424" alt="resume_built" src="https://github.com/user-attachments/assets/f0f4b1d0-b495-470f-94f8-59606da7f438" />
<img width="1080" height="2424" alt="resume_builder_landing" src="https://github.com/user-attachments/assets/dd4c67d7-5339-445d-9475-f5495be14613" />
<img width="1080" height="2424" alt="profile_page" src="https://github.com/user-attachments/assets/50c19816-83bd-48aa-828d-7f3c20d9fb22" />
<img width="1080" height="2424" alt="profile_detail_section" src="https://github.com/user-attachments/assets/b62812b0-b760-4b6e-af0c-9a30ff09b45e" />
<img width="1080" height="2424" alt="info_collection_for_resume" src="https://github.com/user-attachments/assets/7f4f16b0-c914-4044-8044-54634bd45a30" />
<img width="1080" height="2424" alt="home_page" src="https://github.com/user-attachments/assets/9a8e7208-910a-4daa-9e36-8b421397411e" />
<img width="1080" height="2424" alt="explore_page" src="https://github.com/user-attachments/assets/3efbbcae-4fcb-4a54-8ab7-a0cc63a67cbd" />


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
