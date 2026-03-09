# 🚀 Flutter Clean Architecture Template

**Riverpod • Dio • GoRouter • Multipart Ready • Production Ready**

---

# 📌 Overview

This project follows a **Feature-Based Clean Architecture** with clear separation of concerns:

Presentation → Domain → Data → Core

Designed to be:

- Scalable
- Modular
- Clone-friendly
- Backend-agnostic
- Production-ready

This project uses **Riverpod for state management** which provides:

- Better dependency injection
- Safe state management
- Compile-time safety
- Testability

---

# 🏗 Architecture Layers

## 1️⃣ Presentation Layer

Responsible for UI and state management.

Includes:

- UI Screens
- Riverpod Providers (ViewModels)
- UI State Handling
- Dialog & Snackbar Handling
- Navigation

---

## 2️⃣ Domain Layer

Contains pure business logic.

Includes:

- UseCases
- Repository Contracts
- Business Rules

Restrictions:

- No Flutter imports
- No Dio imports
- No UI logic

---

## 3️⃣ Data Layer

Responsible for data handling.

Includes:

- API Sources
- Repository Implementations
- Models
- JSON Mapping

---

## 4️⃣ Core Layer

Contains shared app infrastructure.

Includes:

- Dio Network Setup
- Exception Handling
- Local Storage Wrapper
- Shared Widgets
- App Theme
- Utilities

---

# 📁 Project Structure

lib/

├── core/
│
├── bootstrap/
│
├── constants/
│
├── error/
│
├── extensions/
│
├── logger/
│
├── network/
│
├── base_api_service.dart
│
├── network_api_service.dart
│
├── interceptors/
│
└── multipart_helper.dart
│
├── permissions/
│
├── shared/
│
├── dialogs/
│
├── state/
│
├── views/
│
└── widgets/
│
├── storage/
│
├── theme/
│
└── utils/
│
├── features/
│
├── auth/
│
├── branches/
│
└── other_feature/
│
├── routes/
│
├── main_dev.dart
├── main_staging.dart
├── main_prod.dart
└── main_common.dart

---

# 🧱 Feature Structure

Each feature follows this structure:

feature_name/

├── data/
│
├── model/
│
├── repositories/
│
└── sources/
│
├── domain/
│
├── repositories/
│
└── usecases/
│
└── presentation/
├── pages/
├── providers (Riverpod Providers / ViewModels)
└── widgets/

---

# 📛 Naming Conventions

Files:

auth_model.dart  
auth_api.dart  
auth_repository.dart  
auth_repository_impl.dart  
login_usecase.dart  
login_vm.dart  

Classes:

AuthRepository  
AuthRepositoryImpl  
LoginUseCase  
LoginVM  
ServerException  

---

# 🌐 Network Layer Rules

Located in:

core/network/

Rules:

- Always return `dynamic`
- No model parsing inside network layer
- JSON → Model mapping must happen inside RepositoryImpl
- Centralized exception handling
- Multipart supported

---

# 🖼 Multipart Support

Supports:

- Single image upload
- Multiple images upload
- Optional image upload
- Text + File together

Usage:

MultipartHelper.build(...)

Example Use Cases:

- Profile update with optional image
- Blog post with multiple images
- Form submission with files

---

# ❗ Error Handling System

Located in:

core/error/

Exception Types:

- NoInternetException
- ValidationException
- UnauthorizedException
- ServerException
- UnknownException

---

# ⚠ Error Handling Flow

Layer Responsibilities:

Repository → Throw AppException  
UseCase → Validate & throw  
ViewModel → Catch exception  
UI → Show error dialog  

Never show dialogs inside:

- Repository
- UseCase
- Network layer

Example:

```dart
try {
  await useCase.execute();
} on AppException catch (e) {
  await AppExceptionHandler.handle(context, e);
}
```

---

# 🔐 Authentication System

- AuthState manages login & role
- Role-based routing supported
- Router auto-refresh supported

Example:

```
refreshListenable: Listenable.merge([auth, bootstrap])
```

---

# 💾 Storage

Located in:

core/storage/

Uses SharedPreferences wrapper.

Must initialize before app start:

```
await AppLocalStorage.init();
```

---

# 🧠 Domain Rules

- No Flutter imports
- No Dio imports
- No UI logic
- Only business logic

---

# 🖥 Presentation Rules

Uses **Riverpod State Management**

Responsibilities:

- Manage UI state
- Call UseCases
- Handle loading state
- Show dialogs

Riverpod providers act as **ViewModels**.

---

# 🚫 Not Allowed

- Dio inside ViewModel
- Navigator inside Repository
- UI inside Domain
- Direct SharedPreferences inside Feature

---

# 🔄 New Feature Checklist

1. Create feature folder
2. Add data/domain/presentation layers
3. Add routes
4. Register Riverpod providers
5. Implement UI

No core modification required.

---

# 🔄 Clone Workflow

To create a new project from this template:

1. Change Base URL
2. Replace Models
3. Update Endpoints
4. Update Routes
5. Build UI

Everything else remains unchanged.

---

# 📈 Supported Capabilities

- JSON APIs
- Multipart uploads
- Optional images
- Role-based routing
- Environment configs
- Modular features
- Centralized error handling
- Riverpod state management

---

# 🏁 Status

✔ Clean Architecture  
✔ Modular  
✔ Scalable  
✔ Clone-Friendly  
✔ Production Ready  
✔ Riverpod State Management