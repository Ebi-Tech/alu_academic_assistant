import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:main_app/utils/constants.dart';
import 'services/assignment_service.dart';
import 'services/session_service.dart';
import 'screens/dashboard_screen.dart';
import 'screens/assignments_screen.dart';
import 'screens/schedule_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssignmentService()),
        ChangeNotifierProvider(create: (_) => SessionService()),
        // Member 4 will add ScheduleService later
      ],
      child: const ALUAcademicAssistant(),
    ),
  );
}

class ALUAcademicAssistant extends StatelessWidget {
  const ALUAcademicAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Academic Assistant',
      theme: ThemeData(
        primaryColor: ALUColors.primaryBlue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ALUColors.primaryBlue,
          primary: ALUColors.primaryBlue,
          secondary: ALUColors.progressBlue,
          brightness: Brightness.dark, // Force dark theme
        ),
        scaffoldBackgroundColor: ALUColors.primaryDark,
        appBarTheme: AppBarTheme(
          backgroundColor: ALUColors.primaryDark,
          foregroundColor: Colors.white, // Force white
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: ALUColors.cardLight,
          selectedItemColor: Colors.white, // White for selected
          unselectedItemColor: ALUColors.textGrey,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.white,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: ALUColors.textGrey,
          ),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF0033A0), // ALU Blue
          foregroundColor: Colors.white,
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(
            backgroundColor: MaterialStatePropertyAll(ALUColors.cardLight),
            elevation: const MaterialStatePropertyAll(4),
          ),
          textStyle: const TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ALUColors.cardLight.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: ALUColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF0033A0), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: ALUColors.divider),
          ),
          labelStyle: const TextStyle(color: Color(0xFFA0AEC0)),
          hintStyle: const TextStyle(color: Color(0xFFA0AEC0)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Color(0xFFA0AEC0)),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Screens for navigation
  final List<Widget> _screens = [
    const DashboardScreen(),
    const AssignmentsScreen(),
    const ScheduleScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
        ],
      ),
    );
  }
}