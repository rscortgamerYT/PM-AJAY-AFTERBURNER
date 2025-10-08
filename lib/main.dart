import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'blocs/auth/auth_bloc.dart';
import 'repositories/auth_repository.dart';
import 'screens/auth_gate.dart';
import 'config/supabase_config.dart';
import 'routes/app_routes.dart';
import 'models/user_role.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  
  runApp(const PMAjayApp());
}

class PMAjayApp extends StatelessWidget {
  const PMAjayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        authRepository: AuthRepository(),
      ),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          UserRole? userRole;
          if (state is AuthAuthenticated) {
            userRole = state.userRole;
          }
          
          return MaterialApp(
            title: 'PM-AJAY - Pradhan Mantri Anusuchit Jaati Abhyuday Yojana',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              primarySwatch: Colors.indigo,
              primaryColor: const Color(0xFF3F51B5),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF3F51B5),
                brightness: Brightness.light,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF3F51B5),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              cardTheme: CardTheme(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51B5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            routes: AppRoutes.getRoutes(userRole),
            initialRoute: AppRoutes.auth,
          );
        },
      ),
    );
  }
}
