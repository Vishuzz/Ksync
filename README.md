<p align="center">
  <img src="web application/stitch/projects/6746558600738098719/screens/71dee48dfd774f118c8c87085609cc73<img width="512" height="512" alt="image" src="https://github.com/user-attachments/assets/2ecd66d4-9e70-4079-98d8-ea9fef936e3b" />
" width="120" alt="BunkBook Logo"/>
</p>

<h1 align="center">K-Sync</h1>

<p align="center">
  <b>Your college attendance & academics — beautifully synced.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%2016%2B-blue?logo=apple" />
  <img src="https://img.shields.io/badge/Swift-5.9-orange?logo=swift" />
  <img src="https://img.shields.io/badge/UI-SwiftUI-purple?logo=swift" />
  <img src="https://img.shields.io/badge/Architecture-MVVM-green" />
</p>

---

## 📖 About

**BunkBook** is a native iOS app that gives KIET students a clean, fast dashboard to track attendance, view schedules, check exam results, and stay updated — all from their phone.

It connects to the KIET CyberVidya portal, securely captures the auth token via an embedded WebView login, and then fetches all academic data through the university's API.

---

## ✨ Features

| Feature | Description |
|---|---|
| 📊 **Attendance Dashboard** | Overall & per-subject attendance percentage with visual indicators |
| 📚 **Course Overview** | All registered courses with component-wise attendance breakdowns |
| 📅 **Timetable** | Daily class schedule with faculty, classroom, and timings |
| 📝 **Exam Schedule** | Upcoming exam dates, course details, and evaluation types |
| 🎓 **Exam Results** | Semester-wise grades, SGPA, CGPA, and subject-level scores |
| 🎫 **Hall Ticket** | View and download hall tickets for exams |
| 📆 **Academic Calendar** | Holidays, events, and important academic dates |
| 🔔 **Notifications** | Push notifications for attendance changes and alerts |
| 🔐 **Secure Login** | WebView-based authentication with token capture from CyberVidya |

---

## 🏗️ Architecture

The project follows the **MVVM (Model-View-ViewModel)** pattern:

```
Ksync/
├── App/
│   └── BunkBook App.swift          # App entry point & navigation root
├── Models/
│   ├── AttendanceModels.swift       # User, courses, attendance, exams, scores
│   └── EventModel.swift            # Academic calendar events
├── ViewModels/
│   └── HomeViewModel.swift         # Central data-fetching & state management
├── Views/
│   ├── Components/
│   │   ├── AttendanceComponents.swift  # Reusable attendance cards & widgets
│   │   └── WebView.swift              # WKWebView wrapper for login
│   └── Screens/
│       ├── HomeScreen.swift           # Main dashboard
│       ├── LoginPage.swift            # WebView-based authentication
│       ├── ScheduleScreen.swift       # Daily timetable
│       ├── CourseDetailScreen.swift    # Per-course attendance & lectures
│       ├── ExamScheduleScreen.swift   # Upcoming exams
│       ├── ExamResultView.swift       # Semester-wise results & grades
│       ├── HallTicketView.swift       # Exam hall ticket viewer
│       ├── EventScreen.swift          # Academic calendar
│       ├── AboutScreen.swift          # App info
│       └── SplashScreenView.swift     # Launch animation
└── Services/
    ├── AttendanceMonitor.swift     # Background attendance tracking
    └── NotificationManager.swift   # Push notification handling
```

---

## 🚀 Getting Started

### Prerequisites

- **Xcode 15+** (with Swift 5.9)
- **iOS 16+** device or simulator
- A valid **KIET CyberVidya** student account

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/Ksync.git
   cd Ksync
   ```

2. **Open in Xcode**
   ```bash
   open Ksync.xcodeproj
   ```

3. **Build & Run**
   - Select your target device/simulator
   - Press `Cmd + R` to build and run

4. **Login**
   - The app opens a secure WebView to the KIET CyberVidya portal
   - Log in with your student credentials
   - The auth token is captured automatically and you're taken to the dashboard

---

## 🔒 Privacy & Security

- Auth tokens are stored locally in `UserDefaults` / `@AppStorage`
- No credentials are stored or transmitted by the app — login happens entirely through the official CyberVidya portal
- All API requests use the captured token with HTTPS

---

## 🛠️ Tech Stack

| Technology | Usage |
|---|---|
| **Swift 5.9** | Primary language |
| **SwiftUI** | Declarative UI framework |
| **WKWebView** | Secure login via embedded browser |
| **MVVM** | Architecture pattern |
| **UserDefaults** | Local token persistence |
| **Async/Await** | Modern concurrency for API calls |
| **Push Notifications** | Attendance alerts |

---

## 📄 License

This project is for educational and personal use.

---

<p align="center">
  Made with ❤️ for KIET students
</p>
