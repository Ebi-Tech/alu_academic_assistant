import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';
import '../models/academic_session.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Selected date for the horizontal date picker
  DateTime _selectedDate = DateTime.now();

  // Sample sessions data (grouped by day)
  final List<AcademicSession> _allSessions = [
    // Monday sessions
    AcademicSession(
      id: '1',
      title: 'Software Engineering',
      date: _getNextWeekday(DateTime.monday),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 11, minute: 0),
      location: 'Kigali Hall A',
      sessionType: 'Class',
    ),
    AcademicSession(
      id: '2',
      title: 'Professional Skills (PSL)',
      date: _getNextWeekday(DateTime.monday),
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 15, minute: 30),
      location: 'Online (Zoom)',
      sessionType: 'PSL Meeting',
    ),
    AcademicSession(
      id: '3',
      title: 'Data Structures',
      date: _getNextWeekday(DateTime.monday),
      startTime: const TimeOfDay(hour: 16, minute: 0),
      endTime: const TimeOfDay(hour: 17, minute: 30),
      location: 'Innovation Lab',
      sessionType: 'Mastery Session',
    ),
    // Tuesday sessions
    AcademicSession(
      id: '4',
      title: 'Entrepreneurship',
      date: _getNextWeekday(DateTime.tuesday),
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 12, minute: 0),
      location: 'Auditorium B',
      sessionType: 'Class',
    ),
    AcademicSession(
      id: '5',
      title: 'Algorithms Study Group',
      date: _getNextWeekday(DateTime.tuesday),
      startTime: const TimeOfDay(hour: 13, minute: 0),
      endTime: const TimeOfDay(hour: 14, minute: 30),
      location: 'Library Room 3',
      sessionType: 'Study Group',
    ),
    AcademicSession(
      id: '6',
      title: 'Industry Talk: AI in Africa',
      date: _getNextWeekday(DateTime.tuesday),
      startTime: const TimeOfDay(hour: 16, minute: 0),
      endTime: const TimeOfDay(hour: 17, minute: 30),
      location: 'Main Auditorium',
      sessionType: 'Industry Talk',
    ),
    // Wednesday sessions
    AcademicSession(
      id: '7',
      title: 'Software Engineering',
      date: _getNextWeekday(DateTime.wednesday),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 11, minute: 0),
      location: 'Kigali Hall A',
      sessionType: 'Class',
    ),
    AcademicSession(
      id: '8',
      title: 'Data Structures Workshop',
      date: _getNextWeekday(DateTime.wednesday),
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 16, minute: 0),
      location: 'Computer Lab 2',
      sessionType: 'Workshop',
    ),
    // Thursday sessions
    AcademicSession(
      id: '9',
      title: 'Entrepreneurship',
      date: _getNextWeekday(DateTime.thursday),
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 12, minute: 0),
      location: 'Auditorium B',
      sessionType: 'Class',
    ),
    AcademicSession(
      id: '10',
      title: 'Professional Skills (PSL)',
      date: _getNextWeekday(DateTime.thursday),
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 15, minute: 30),
      location: 'Online (Zoom)',
      sessionType: 'PSL Meeting',
    ),
    // Friday sessions
    AcademicSession(
      id: '11',
      title: 'Data Structures',
      date: _getNextWeekday(DateTime.friday),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 11, minute: 0),
      location: 'Innovation Lab',
      sessionType: 'Class',
    ),
    AcademicSession(
      id: '12',
      title: 'Peer Learning Session',
      date: _getNextWeekday(DateTime.friday),
      startTime: const TimeOfDay(hour: 15, minute: 0),
      endTime: const TimeOfDay(hour: 16, minute: 30),
      location: 'Library Room 1',
      sessionType: 'Study Group',
    ),
  ];

  /// Gets the nearest date for a given weekday from the current week.
  static DateTime _getNextWeekday(int weekday) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day + (weekday - 1),
    );
  }

  /// Returns sessions for the selected date.
  List<AcademicSession> get _sessionsForSelectedDate {
    return _allSessions.where((s) {
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

  /// Returns the count of sessions for the full week.
  int get _weekSessionCount => _allSessions.length;

  /// Returns the count of sessions today.
  int get _todaySessionCount {
    final now = DateTime.now();
    return _allSessions.where((s) {
      return s.date.year == now.year &&
          s.date.month == now.month &&
          s.date.day == now.day;
    }).length;
  }

  /// Color mapping for session types.
  Color _getTypeColor(String type) {
    switch (type) {
      case 'Class':
        return ALUColors.progressBlue;
      case 'Mastery Session':
        return ALUColors.warningYellow;
      case 'Study Group':
        return ALUColors.successGreen;
      case 'PSL Meeting':
        return const Color(0xFF9C27B0); // Purple for PSL
      case 'Industry Talk':
        return const Color(0xFFFF6D00); // Orange for industry talks
      case 'Workshop':
        return const Color(0xFF00BCD4); // Cyan for workshops
      default:
        return ALUColors.progressBlue;
    }
  }

  /// Icon mapping for session types.
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
      case 'Industry Talk':
        return Icons.campaign_outlined;
      case 'Workshop':
        return Icons.build_outlined;
      default:
        return Icons.event_outlined;
    }
  }

  /// Formats a TimeOfDay to a readable string.
  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dt);
  }

  /// Checks if a session is currently happening.
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
    final sessions = _sessionsForSelectedDate;
    final isToday = _selectedDate.year == DateTime.now().year &&
        _selectedDate.month == DateTime.now().month &&
        _selectedDate.day == DateTime.now().day;

    return Scaffold(
      backgroundColor: ALUColors.primaryDark,
      appBar: AppBar(
        title: const Text(
          "Schedule",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ALUColors.textWhite,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: ALUColors.textWhite),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
              });
            },
            icon: const Icon(Icons.today_outlined, color: ALUColors.textWhite),
            tooltip: 'Go to today',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_outlined, color: ALUColors.textWhite),
            tooltip: 'Filter',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Week Overview Stats ──
            _buildWeekOverviewCards(),
            const SizedBox(height: 20),

            // ── Horizontal Date Picker ──
            _buildDateSelector(),
            const SizedBox(height: 20),

            // ── Selected Day Header ──
            _buildDayHeader(isToday),
            const SizedBox(height: 16),

            // ── Timeline / Sessions List ──
            if (sessions.isEmpty)
              _buildEmptyState()
            else
              _buildTimeline(sessions),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // WEEK OVERVIEW STATS (two cards at top)

  Widget _buildWeekOverviewCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ALUColors.cardDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: ALUColors.progressBlue, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "This Week",
                      style: TextStyle(color: ALUColors.textGrey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "$_weekSessionCount Sessions",
                  style: const TextStyle(
                    color: ALUColors.textWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _weekSessionCount / 20, // assume 20 max per week
                  backgroundColor: ALUColors.progressBlue.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(ALUColors.progressBlue),
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
              color: ALUColors.cardDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time_filled, color: ALUColors.warningYellow, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Today",
                      style: TextStyle(color: ALUColors.textGrey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "$_todaySessionCount Sessions",
                  style: const TextStyle(
                    color: ALUColors.textWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _todaySessionCount / 5,
                  backgroundColor: ALUColors.warningYellow.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(ALUColors.warningYellow),
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

  // HORIZONTAL DATE PICKER (scrollable week)

  Widget _buildDateSelector() {
    // Build the current week (Mon–Sun)
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: ALUColors.cardDark,
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

          // Count sessions on this day
          final daySessionCount = _allSessions.where((s) {
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
                color: isSelected
                    ? ALUColors.primaryBlue
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isCurrentDay && !isSelected
                    ? Border.all(color: ALUColors.primaryBlue.withOpacity(0.5), width: 1)
                    : null,
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('E').format(day).substring(0, 3),
                    style: TextStyle(
                      color: isSelected
                          ? ALUColors.textWhite
                          : ALUColors.textGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isSelected
                          ? ALUColors.textWhite
                          : ALUColors.textLight,
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Dot indicator for sessions
                  if (daySessionCount > 0)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ALUColors.textWhite
                            : ALUColors.progressBlue,
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

  // DAY HEADER

  Widget _buildDayHeader(bool isToday) {
    final sessions = _sessionsForSelectedDate;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isToday
                  ? "Today's Sessions"
                  : DateFormat('EEEE').format(_selectedDate),
              style: const TextStyle(
                color: ALUColors.textWhite,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              DateFormat('MMMM d, yyyy').format(_selectedDate),
              style: TextStyle(color: ALUColors.textGrey, fontSize: 13),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: ALUColors.primaryBlue.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ALUColors.primaryBlue.withOpacity(0.3)),
          ),
          child: Text(
            "${sessions.length} ${sessions.length == 1 ? 'session' : 'sessions'}",
            style: const TextStyle(
              color: ALUColors.progressBlue,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // EMPTY STATE (no sessions)

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: ALUColors.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy_outlined,
            color: ALUColors.textGrey.withOpacity(0.5),
            size: 56,
          ),
          const SizedBox(height: 16),
          const Text(
            "No Sessions Scheduled",
            style: TextStyle(
              color: ALUColors.textWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Enjoy your free time! 🎉",
            style: TextStyle(color: ALUColors.textGrey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // TIMELINE LIST

  Widget _buildTimeline(List<AcademicSession> sessions) {
    return Column(
      children: List.generate(sessions.length, (index) {
        final session = sessions[index];
        final isLast = index == sessions.length - 1;
        final isCurrent = _isCurrentSession(session);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Time column ──
              SizedBox(
                width: 58,
                child: Text(
                  _formatTime(session.startTime),
                  style: TextStyle(
                    color: isCurrent
                        ? ALUColors.textWhite
                        : ALUColors.textGrey,
                    fontSize: 12,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),

              // ── Timeline connector ──
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? _getTypeColor(session.sessionType)
                          : Colors.transparent,
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
                        color: ALUColors.divider.withOpacity(0.4),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),

              // ── Session Card ──
              Expanded(
                child: _buildSessionCard(session, isCurrent),
              ),
            ],
          ),
        );
      }),
    );
  }

  // SESSION CARD

  Widget _buildSessionCard(AcademicSession session, bool isCurrent) {
    final typeColor = _getTypeColor(session.sessionType);
    final typeIcon = _getTypeIcon(session.sessionType);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ALUColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: isCurrent
            ? Border.all(color: typeColor.withOpacity(0.6), width: 1.5)
            : Border.all(color: ALUColors.divider.withOpacity(0.3)),
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
          // Card body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: type badge + live indicator
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: ALUColors.successGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: ALUColors.successGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              "LIVE",
                              style: TextStyle(
                                color: ALUColors.successGreen,
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

                // Title
                Text(
                  session.title,
                  style: const TextStyle(
                    color: ALUColors.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // Time & Location row
                Row(
                  children: [
                    Icon(Icons.access_time,
                        color: ALUColors.textGrey, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      "${_formatTime(session.startTime)} – ${_formatTime(session.endTime)}",
                      style:
                          TextStyle(color: ALUColors.textGrey, fontSize: 13),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.location_on_outlined,
                        color: ALUColors.textGrey, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        session.location ?? 'TBD',
                        style:
                            TextStyle(color: ALUColors.textGrey, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom action bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: ALUColors.cardLight.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Attendance toggle
                GestureDetector(
                  onTap: () {
                    setState(() {
                      session.isPresent = !session.isPresent;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        session.isPresent
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: session.isPresent
                            ? ALUColors.successGreen
                            : ALUColors.textGrey,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        session.isPresent ? "Present" : "Mark present",
                        style: TextStyle(
                          color: session.isPresent
                              ? ALUColors.successGreen
                              : ALUColors.textGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Icon(Icons.more_horiz, color: ALUColors.textGrey, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
