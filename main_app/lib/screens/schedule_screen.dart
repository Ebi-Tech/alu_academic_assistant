import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widgets/session_form.dart';
import '../models/academic_session.dart';
import '../services/session_service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDemoData();
    });
  }

  Future<void> _initializeDemoData() async {
    final sessionService = Provider.of<SessionService>(context, listen: false);
    
    if (sessionService.sessions.isEmpty) {
      await _addDemoSessions(sessionService);
    }
  }

  Future<void> _addDemoSessions(SessionService sessionService) async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    
    // Monday sessions
    await sessionService.addSession(AcademicSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Software Engineering',
      date: startOfWeek.add(const Duration(days: 0)),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 11, minute: 0),
      location: 'Kigali Hall A',
      sessionType: 'Class',
      isPresent: true,
    ));

    await sessionService.addSession(AcademicSession(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      title: 'Professional Skills (PSL)',
      date: startOfWeek.add(const Duration(days: 0)),
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 15, minute: 30),
      location: 'Online (Zoom)',
      sessionType: 'PSL Meeting',
      isPresent: true,
    ));

    await sessionService.addSession(AcademicSession(
      id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
      title: 'Data Structures',
      date: startOfWeek.add(const Duration(days: 0)),
      startTime: const TimeOfDay(hour: 16, minute: 0),
      endTime: const TimeOfDay(hour: 17, minute: 30),
      location: 'Innovation Lab',
      sessionType: 'Mastery Session',
      isPresent: false,
    ));

    print('✅ Added demo sessions');
  }

  void _openSessionForm(BuildContext context, AcademicSession? session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SessionForm(
        session: session,
        onSave: (newSession) {
          final sessionService = Provider.of<SessionService>(context, listen: false);
          if (session == null) {
            sessionService.addSession(newSession);
          } else {
            sessionService.updateSession(newSession);
          }
        },
      ),
    );
  }

  List<AcademicSession> _sessionsForSelectedDate(List<AcademicSession> allSessions) {
    return allSessions.where((s) {
      return s.date.year == _selectedDate.year &&
          s.date.month == _selectedDate.month &&
          s.date.day == _selectedDate.day;
    }).toList()
      ..sort((a, b) {
        final aMinutes = a.startTime.hour * 60 + a.startTime.minute;
        final bMinutes = b.startTime.hour * 60 + b.startTime.minute;
        return aMinutes.compareTo(bMinutes);
      });
  }

  int _weekSessionCount(List<AcademicSession> allSessions) => allSessions.length;

  int _todaySessionCount(List<AcademicSession> allSessions) {
    final now = DateTime.now();
    return allSessions.where((s) {
      return s.date.year == now.year &&
          s.date.month == now.month &&
          s.date.day == now.day;
    }).length;
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Class':
        return const Color(0xFF2196F3);
      case 'Mastery Session':
        return const Color(0xFFFFC72C);
      case 'Study Group':
        return const Color(0xFF43B02A);
      case 'PSL Meeting':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF2196F3);
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Class':
        return Icons.school_outlined;
      case 'Mastery Session':
        return Icons.psychology_outlined;
      case 'Study Group':
        return Icons.groups_outlined;
      case 'PSL Meeting':
        return Icons.record_voice_over_outlined;
      default:
        return Icons.event_outlined;
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  bool _isCurrentSession(AcademicSession session) {
    final now = DateTime.now();
    if (session.date.year != now.year ||
        session.date.month != now.month ||
        session.date.day != now.day) {
      return false;
    }
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = session.startTime.hour * 60 + session.startTime.minute;
    final endMinutes = session.endTime.hour * 60 + session.endTime.minute;
    return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionService>(
      builder: (context, sessionService, child) {
        final allSessions = sessionService.sessions;
        final sessions = _sessionsForSelectedDate(allSessions);
        final isToday = _selectedDate.year == DateTime.now().year &&
            _selectedDate.month == DateTime.now().month &&
            _selectedDate.day == DateTime.now().day;

        return Scaffold(
          backgroundColor: const Color(0xFF0A192F),
          appBar: AppBar(
            title: const Text(
              "Schedule",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime.now();
                  });
                },
                icon: const Icon(Icons.today_outlined, color: Colors.white),
                tooltip: 'Go to today',
              ),
              if (allSessions.isEmpty)
                IconButton(
                  onPressed: () => _addDemoSessions(sessionService),
                  icon: const Icon(Icons.add, color: Colors.white),
                  tooltip: 'Add demo sessions',
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWeekOverviewCards(allSessions),
                const SizedBox(height: 20),
                _buildDateSelector(allSessions),
                const SizedBox(height: 20),
                _buildDayHeader(isToday, sessions),
                const SizedBox(height: 16),
                if (sessions.isEmpty)
                  _buildEmptyState()
                else
                  _buildTimeline(sessions, sessionService),
                const SizedBox(height: 24),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _openSessionForm(context, null),
            backgroundColor: const Color(0xFF0033A0),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildWeekOverviewCards(List<AcademicSession> allSessions) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: const Color(0xFF2196F3), size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      "This Week",
                      style: TextStyle(color: Color(0xFFA0AEC0), fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "${_weekSessionCount(allSessions)} Sessions",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _weekSessionCount(allSessions) / 20,
                  backgroundColor: const Color(0xFF2196F3).withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time_filled, color: const Color(0xFFFFC72C), size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      "Today",
                      style: TextStyle(color: Color(0xFFA0AEC0), fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "${_todaySessionCount(allSessions)} Sessions",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _todaySessionCount(allSessions) / 5,
                  backgroundColor: const Color(0xFFFFC72C).withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFC72C)),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(List<AcademicSession> allSessions) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          final day = startOfWeek.add(Duration(days: index));
          final isSelected = day.year == _selectedDate.year &&
              day.month == _selectedDate.month &&
              day.day == _selectedDate.day;
          final isCurrentDay = day.year == now.year &&
              day.month == now.month &&
              day.day == now.day;

          final daySessionCount = allSessions.where((s) {
            return s.date.year == day.year &&
                s.date.month == day.month &&
                s.date.day == day.day;
          }).length;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = day;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0033A0) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isCurrentDay && !isSelected
                    ? Border.all(color: const Color(0xFF0033A0).withOpacity(0.5), width: 1)
                    : null,
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('E').format(day).substring(0, 3),
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFFA0AEC0),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFFCBD5E0),
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (daySessionCount > 0)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : const Color(0xFF2196F3),
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    const SizedBox(height: 6),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDayHeader(bool isToday, List<AcademicSession> sessions) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isToday ? "Today's Sessions" : DateFormat('EEEE').format(_selectedDate),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              DateFormat('MMMM d, yyyy').format(_selectedDate),
              style: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 13),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF0033A0).withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF0033A0).withOpacity(0.3)),
          ),
          child: Text(
            "${sessions.length} ${sessions.length == 1 ? 'session' : 'sessions'}",
            style: const TextStyle(
              color: Color(0xFF2196F3),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy_outlined,
            color: const Color(0xFFA0AEC0).withOpacity(0.5),
            size: 56,
          ),
          const SizedBox(height: 16),
          const Text(
            "No Sessions Scheduled",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Tap + to add a session",
            style: TextStyle(color: Color(0xFFA0AEC0), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(List<AcademicSession> sessions, SessionService sessionService) {
    return Column(
      children: List.generate(sessions.length, (index) {
        final session = sessions[index];
        final isLast = index == sessions.length - 1;
        final isCurrent = _isCurrentSession(session);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 58,
                child: Text(
                  _formatTime(session.startTime),
                  style: TextStyle(
                    color: isCurrent ? Colors.white : const Color(0xFFA0AEC0),
                    fontSize: 12,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isCurrent ? _getTypeColor(session.sessionType) : Colors.transparent,
                      border: Border.all(
                        color: _getTypeColor(session.sessionType),
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: const Color(0xFF4A5568).withOpacity(0.4),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSessionCard(session, isCurrent, sessionService),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSessionCard(AcademicSession session, bool isCurrent, SessionService sessionService) {
    final typeColor = _getTypeColor(session.sessionType);
    final typeIcon = _getTypeIcon(session.sessionType);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: isCurrent
            ? Border.all(color: typeColor.withOpacity(0.6), width: 1.5)
            : Border.all(color: const Color(0xFF4A5568).withOpacity(0.3)),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: typeColor.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: typeColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(typeIcon, color: typeColor, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            session.sessionType,
                            style: TextStyle(
                              color: typeColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF43B02A).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF43B02A),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              "LIVE",
                              style: TextStyle(
                                color: Color(0xFF43B02A),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  session.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, color: const Color(0xFFA0AEC0), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      "${_formatTime(session.startTime)} – ${_formatTime(session.endTime)}",
                      style: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 13),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.location_on_outlined, color: const Color(0xFFA0AEC0), size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        session.location ?? 'TBD',
                        style: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF2D3748).withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    sessionService.toggleAttendance(session.id);
                  },
                  child: Row(
                    children: [
                      Icon(
                        session.isPresent ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: session.isPresent ? const Color(0xFF43B02A) : const Color(0xFFA0AEC0),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        session.isPresent ? "Present" : "Mark present",
                        style: TextStyle(
                          color: session.isPresent ? const Color(0xFF43B02A) : const Color(0xFFA0AEC0),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_horiz, color: const Color(0xFFA0AEC0), size: 20),
                  color: const Color(0xFF1E293B),
                  onSelected: (value) {
                    if (value == 'edit') {
                      _openSessionForm(context, session);
                    } else if (value == 'delete') {
                      _showDeleteDialog(context, session, sessionService);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Color(0xFF2196F3), size: 18),
                          SizedBox(width: 8),
                          Text('Edit', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Color(0xFFD32F2F), size: 18),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AcademicSession session, SessionService sessionService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Delete Session',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Delete "${session.title}"?',
          style: const TextStyle(color: Color(0xFFA0AEC0)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              sessionService.deleteSession(session.id);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFD32F2F)),
            ),
          ),
        ],
      ),
    );
  }
}
