🧠 Prototype – Flutter Project Setup Guide
This guide helps you set up your Flutter project with automatic environment and build flavor support.

✅ Step 1: Project Setup
Make sure Flutter is installed. Then clone the repo and run:
flutter pub get

⚙️ Step 2: Generate Environment Files
Run the following command to generate:

.env.example (if missing)
.env.dev, .env.staging, .env.prod
Sets name: and version: in pubspec.yaml

Command : dart tools/setup_project.dart

🧪 Step 3: Create Flavor Entry Points
Generate the following files (if not present):

lib/main_dev.dart
lib/main_staging.dart
lib/main_prod.dart

Each of these will point to the main Dart entry file and pass a flavor name.
Command : dart tools/generate_flavors.dart

🚀 Step 4: Build All Flavors
To build APKs for all flavors: 

Command : dart tools/build_all.dart

🚀 Step 5: To connect project with supabase (This will generated all files)
Command : dart tools/setup_supabase.dart

🚀 Step 6: To setup local db isar (This will generated all files)
Command : dart tools/setup_db_isar.dart