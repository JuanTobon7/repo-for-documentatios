
# Prueba-Tecnica---Software-Engineer-

Aplicación Fullstack con frontend en Flutter (Dart) y backend REST API con Node.js usando NestJS.  
Ideal para apps móviles con backend escalable y modular.





## Agradecimientos

- [Awesome Readme Templates](https://github.com/matiassingers/awesome-readme)  
- [Awesome README](https://github.com/matiassingers/awesome-readme)  
- [How to Write a Good README](https://www.freecodecamp.org/news/how-to-write-a-good-readme/)


## API Reference

La documentacion en la API esta en este link: 
## Installation

### Instalacion front 

```bash
  cd /mobile
  flutter pub get

```
### Instalacion server 

```bash
  cd /server
  npm i
  npm run start
    
```


## Demo

Insert gif or link to demo






# Mobile App Documentation

## Technologies

The mobile part of the project is built using **Flutter** framework with the following key technologies and dependencies:

**Core Framework:**
- Flutter SDK ^3.8.1

**Key Dependencies:**
- `dio: ^5.0.3` for HTTP API communication
- `flutter_dotenv: ^5.0.2` for environment variable management
- `go_router: ^16.1.0` for navigation and routing
- `cupertino_icons: ^1.0.8` for iOS-style icons

## Project Structure

The mobile app follows a well-organized Flutter project structure:

```
mobile/
├── lib/
│   ├── api/          # API communication layer
│   ├── common/       # Shared utilities and components
│   ├── components/   # Reusable UI components
│   ├── models/       # Data models and DTOs
│   ├── pages/        # Screen/page widgets
│   └── main.dart     # App entry point
├── android/          # Android-specific configurations
├── ios/              # iOS-specific configurations
└── pubspec.yaml      # Dependencies and project configuration
```

## Installation

1. **Prerequisites:**
   - Install Flutter SDK (version ^3.8.1 or higher)
   - Install Dart
   - Setup Android Studio/Xcode for mobile development

2. **Setup:**
   ```bash
   cd mobile
   flutter pub get
   ```

3. **Environment Configuration:**
   - Create `assets/.env` file with API configuration [6](#2-5) 
   - Set `API_URL` variable (defaults to `http://127.0.0.1:3000/api/v1`) [7](#2-6) 

## Execution

**Development Mode:**
```bash
flutter run
```

**Build for Production:**
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Testing

The project uses Flutter's built-in testing framework:
- `flutter_test` for unit and widget testing 
- `flutter_lints: ^5.0.0` for code quality and linting

**Run tests:**
```bash
flutter test
```

## Main Features

### 1. Authentication System
- User registration and login functionality
- JWT token-based authentication with automatic header injection

### 2. Navigation Structure
The app uses declarative routing with three main screens:
- Login page (`/login`) - initial route
- Sign-up page (`/sign-up`)
- Home page (`/`) - main task management interface

### 3. Task Management System
**Core Functionality:**
- Create, read, update, and delete tasks
- Daily task status tracking (PENDING/DONE)

**Advanced Features:**
- Date-based task filtering 
- Status-based filtering (Pending/Done)
- Multi-select for bulk operations
- Floating action menu with CRUD operations

### 4. API Integration
- Singleton API client with global error handling
- Comprehensive error management for network issues, timeouts, and authentication errors 
- Automatic token management for authenticated requests

### 5. Data Models
Structured data handling with:
- Task DTO with nested daily task information
- JSON serialization/deserialization

## Server Documentation


This server implements a comprehensive documentation system using NestJS with Swagger/OpenAPI integration. Here's how each component works:

## Interactive Swagger Documentation

The interactive Swagger documentation is configured in the main application bootstrap function [1](#3-0) . The system creates a DocumentBuilder configuration with title "Gestor de Tareas Personales", description for a personal task manager technical test, and version 1.0. The Swagger UI is accessible at the `/swagger` endpoint.

## Endpoint Documentation

### Controller-Level Documentation
Controllers use comprehensive Swagger decorators for API documentation:

- **API Tags and Authentication**: Controllers are organized with `@ApiTags` and secured with `@ApiBearerAuth` [2](#3-1) 

- **Response Documentation**: Endpoints use detailed response schemas with `@ApiOkResponse`, `@ApiUnauthorizedResponse`, and other status-specific decorators [3](#3-2) 

- **Query Parameters**: API query parameters are documented using `@ApiQuery` with detailed descriptions [4](#3-3) 

### DTO Documentation
Data Transfer Objects include comprehensive field documentation using `@ApiProperty` and `@ApiPropertyOptional` decorators with examples and descriptions [5](#3-4) 

### Response Schema Integration
The system uses a standardized `ApiResponse` class with Swagger properties for consistent response formatting [6](#3-5) 

## Technical README

The technical README provides standard NestJS documentation including project setup, compilation commands, testing instructions, and deployment information [7](#3-6) 

## Project Configuration

### Dependencies
The project configuration includes `@nestjs/swagger` as a core dependency for API documentation functionality [8](#3-7) 

### Global Configuration
The application is configured with global prefix `api/v1`, CORS enabled, and global validation pipes [9](#3-8) 

## Notes

The documentation system provides a complete API documentation solution with:
- Interactive Swagger UI accessible at `/swagger`
- Comprehensive endpoint documentation with request/response schemas
- Authentication documentation with Bearer token support
- Query parameter documentation
- Standardized error response documentation
- Global API versioning with `api/v1` prefix

The system demonstrates best practices for API documentation in NestJS applications, making the API easily consumable and testable through the interactive interface.
