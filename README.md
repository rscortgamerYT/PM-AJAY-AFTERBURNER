# PM-AJAY Agency Mapping Platform

A comprehensive Flutter application for managing PM-AJAY (Pradhan Mantri Anusuchit Jaati Abhyuday Yojana) projects with Supabase backend integration.

## Features

- **Role-based Access Control**: Centre Admin, State Officer, Agency User, Auditor, and Public Viewer roles
- **Material 3 Design**: Modern, government-compliant UI with responsive layouts
- **Real-time Updates**: Live project status and fund tracking via Supabase
- **PFMS Integration**: Fund flow management and transparency
- **Evidence Management**: Geo-tagged document uploads and milestone tracking
- **Public Transparency**: Open dashboard for public accountability

## Architecture

- **Frontend**: Flutter 3.24+ with Material 3
- **Backend**: Supabase (PostgreSQL + Real-time + Auth + Storage)
- **State Management**: BLoC pattern
- **Database**: PostgreSQL with Row Level Security (RLS)

## Setup Instructions

### 1. Prerequisites

- Flutter 3.24 or higher
- Dart 3.0 or higher
- Supabase account

### 2. Supabase Setup

1. Create a new Supabase project at [supabase.com](https://supabase.com)
2. Run the SQL schema from `supabase/schema.sql` in your Supabase SQL editor
3. Copy your project URL and anon key

### 3. Flutter Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Update Supabase configuration in `lib/config/supabase_config.dart`:
   ```dart
   static const String url = 'YOUR_SUPABASE_URL';
   static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';
   ```

4. Run the application:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── blocs/              # BLoC state management
├── config/             # Configuration files
├── models/             # Data models
├── repositories/       # Data repositories
├── screens/            # UI screens
├── widgets/            # Reusable widgets
└── main.dart          # App entry point

supabase/
└── schema.sql         # Database schema
```

## User Roles & Permissions

### Centre Admin (MoSJE)
- Full system access
- Scheme setup and policy management
- Cross-state oversight
- PFMS integration configuration

### State Admin/Officers
- State-level project management
- Agency onboarding and assignment
- Fund allocation and tracking
- State-specific reporting

### Agency Users
- Project acceptance and execution
- Progress reporting with evidence
- Milestone tracking
- Beneficiary feedback collection

### Auditor/QA
- Project verification and audits
- Quality assurance workflows
- Compliance checking
- Audit trail management

### Public Viewer
- Public dashboard access
- Transparency data viewing
- Grievance submission

## Key Components

### PM-AJAY Component Distribution
- **Adarsh Gram**: ~50% (Village development projects)
- **Hostel**: ~2% (Educational infrastructure)
- **GIA**: General Infrastructure and Administration
- **Admin**: ~5% (Administrative costs)

### PFMS Integration
- Real-time fund release tracking
- Utilization monitoring
- EAT (Electronic Accounting Transfer) support
- MIS integration for transparency

## Development Roadmap

### Phase 1 (MVP - 90 days)
- ✅ Core Flutter app structure
- ✅ Authentication and RBAC
- ✅ Basic project management
- ✅ Responsive dashboard layouts
- 🔄 PFMS integration simulation
- 🔄 Evidence upload pipeline

### Phase 2 (90-180 days)
- 📋 Advanced analytics and reporting
- 📋 Public transparency portal
- 📋 Mobile offline capabilities
- 📋 Multi-language support

### Phase 3 (180+ days)
- 📋 AI-powered insights
- 📋 Advanced workflow automation
- 📋 Integration with other government systems

## Demo Accounts

For testing purposes, you can create accounts with these roles:

- **Centre Admin**: admin@pmajay.gov.in
- **State Officer**: state@pmajay.gov.in  
- **Agency User**: agency@pmajay.gov.in
- **Password**: demo123

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is developed for the Government of India under PM-AJAY initiative.

## Support

For technical support or questions, please contact the development team.
