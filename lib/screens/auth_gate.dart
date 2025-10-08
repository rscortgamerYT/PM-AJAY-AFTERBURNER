import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../models/user_role.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';
import 'demo_home_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isDemoMode = true; // For demo purposes
  UserRoleType _demoRole = UserRoleType.centreAdmin;

  @override
  Widget build(BuildContext context) {
    // In demo mode, show demo dashboard
    if (_isDemoMode) {
      return _buildDemoModeSelector();
    }

    // In production mode, use actual authentication
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (state is AuthAuthenticated) {
          return DashboardScreen(
            user: state.user,
            userRole: state.userRole,
          );
        }
        
        return const LoginScreen();
      },
    );
  }

  Widget _buildDemoModeSelector() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PM-AJAY Demo'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isDemoMode = false;
              });
            },
            icon: const Icon(Icons.login),
            label: const Text('Production Mode'),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'PM-AJAY Demo',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Agency Mapping Platform',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Select Demo Role',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        ...UserRoleType.values.map((role) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: FilledButton.tonal(
                              onPressed: () {
                                setState(() {
                                  _demoRole = role;
                                });
                                _enterDemoMode(role);
                              },
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    role.displayName,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _getRoleDescription(role),
                                    style: Theme.of(context).textTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Demo Features',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '• Role-based dashboard views\n'
                          '• Project management interface\n'
                          '• Fund tracking simulation\n'
                          '• Agency management system\n'
                          '• Analytics and reporting\n'
                          '• Public transparency portal',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getRoleDescription(UserRoleType role) {
    switch (role) {
      case UserRoleType.centreAdmin:
        return 'Full system access, scheme setup, cross-state oversight';
      case UserRoleType.stateOfficer:
        return 'State-level project management, agency coordination';
      case UserRoleType.agencyUser:
        return 'Project execution, progress reporting, evidence upload';
      case UserRoleType.auditor:
        return 'Project verification, quality assurance, compliance';
      case UserRoleType.publicViewer:
        return 'Public dashboard access, transparency data viewing';
    }
  }

  void _enterDemoMode(UserRoleType role) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => DemoHomeScreen(demoRole: role),
      ),
    );
  }
}
