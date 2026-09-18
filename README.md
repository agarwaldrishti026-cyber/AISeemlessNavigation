NavExa
AI-Powered Seamless Navigation
About the Project
NavExa is an AI-based navigation prototype designed to provide seamless vehicle navigation when GPS/NavIC signals become unavailable.

The system demonstrates the use of Dead Reckoning to continue navigation during GPS-denied situations such as tunnels.

Problem
GPS/NavIC signals may become unavailable in tunnels and other GPS-denied environments, causing interruptions in navigation.

Proposed Solution
NavExa combines satellite-based navigation with AI-assisted Dead Reckoning to maintain continuous navigation during temporary signal loss.

Main Features
GPS/NavIC-based navigation
Vehicle movement on map
GPS-denied tunnel simulation
AI Dead Reckoning mode
Automatic navigation-status changes
Navigation analytics
Technology Used
Flutter
Dart
Python
AI/ML
GPS/NavIC
IMU/Sensor data
Map technology
Project Structure
NavExa/
├── android/              # Android configuration
├── ios/                  # iOS configuration
├── lib/                  # Main Flutter application code
├── web/                  # Web configuration
├── test/                 # Flutter test files
├── code/                 # AI/ML Python code
├── data/                 # Navigation datasets
├── model/                # Trained AI/ML models
├── result/               # AI/ML results
├── bugs.md               # Bug tracking
├── README.md             # Project documentation
└── pubspec.yaml          # Flutter dependencies and configuration
Team
Prachi — Flutter UI
Hrashita — Map
Mahak — Tunnel Simulation
Parisha — Dataset & AI/ML
Drishti — Integration & Project Management
Anshul — UI/UX & Testing
Bug Tracking
Project bugs should be recorded in bugs.md.

Each bug should include:

Problem
Assigned team member
Status
Notes
Example:

Problem: Map does not load
Assigned to: Member 2
Status: Pending
Notes: Check map configuration and API setup

Project Status
Prototype under development.

Demo Flow
Start Journey ↓ Vehicle Movement ↓ Enter Tunnel ↓ GPS/NavIC Signal Lost ↓ AI Dead Reckoning Active ↓ Exit Tunnel ↓ GPS/NavIC Reconnected
