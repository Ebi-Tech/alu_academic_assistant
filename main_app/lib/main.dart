import 'package:flutter/material.dart';
import 'package:main_app/utils/constants.dart';
import 'screens/dashboard_screen.dart'; 
// import 'screens/assignments_screen.dart';
import 'screens/schedule_screen.dart';

void main() {
  runApp(const ALUAcademicAssistant());
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
        ),
        scaffoldBackgroundColor: ALUColors.primaryDark, 
        appBarTheme: AppBarTheme(
          backgroundColor: ALUColors.primaryDark, 
          foregroundColor: ALUColors.textWhite, 
          elevation: 2,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: ALUColors.cardDark, 
          selectedItemColor: ALUColors.primaryBlue,
          unselectedItemColor: ALUColors.textGrey, 
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



class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        backgroundColor: ALUColors.primaryDark, 
      ),
      backgroundColor: ALUColors.primaryDark, 
      body: const Center(
        child: Text(
          'Assignments Screen - Esther will implement',
          style: TextStyle(color: ALUColors.textWhite),
        ),
      ),
    );
  }
}
