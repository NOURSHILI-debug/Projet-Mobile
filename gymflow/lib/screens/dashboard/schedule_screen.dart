import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String?  _username;
  bool _isLoading = true;
  int _selectedDayIndex = DateTime.now().weekday - 1; // 0 = Monday

  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  
  final List<String> _fullDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  // Sample schedule data - replace with actual API calls
  final Map<String, List<GymClass>> _schedule = {
    'Monday': [
      GymClass(
        name: 'HIIT Training',
        coach: 'Alex',
        time: '06:00 AM',
        duration: '45 min',
        spots: 12,
        maxSpots: 15,
        category: 'Cardio',
        isBooked: false,
      ),
      GymClass(
        name: 'Yoga Flow',
        coach: 'Sara',
        time: '09:00 AM',
        duration: '60 min',
        spots: 8,
        maxSpots: 20,
        category: 'Flexibility',
        isBooked:  true,
      ),
      GymClass(
        name: 'Strength Training',
        coach:  'Alex',
        time: '05:00 PM',
        duration: '60 min',
        spots: 5,
        maxSpots: 12,
        category: 'Strength',
        isBooked: false,
      ),
      GymClass(
        name:  'Spin Class',
        coach: 'Mike',
        time: '07:00 PM',
        duration: '45 min',
        spots: 15,
        maxSpots: 20,
        category: 'Cardio',
        isBooked: false,
      ),
    ],
    'Tuesday': [
      GymClass(
        name: 'Boxing Bootcamp',
        coach: 'John',
        time: '06:30 AM',
        duration: '50 min',
        spots: 10,
        maxSpots:  15,
        category: 'Cardio',
        isBooked: false,
      ),
      GymClass(
        name: 'Pilates',
        coach: 'Sara',
        time: '10:00 AM',
        duration: '55 min',
        spots: 6,
        maxSpots: 15,
        category: 'Flexibility',
        isBooked:  false,
      ),
      GymClass(
        name: 'CrossFit',
        coach: 'Alex',
        time: '06:00 PM',
        duration: '60 min',
        spots: 8,
        maxSpots:  12,
        category: 'Strength',
        isBooked: true,
      ),
    ],
    'Wednesday': [
      GymClass(
        name: 'Zumba Dance',
        coach: 'Lisa',
        time: '07:00 AM',
        duration: '45 min',
        spots: 18,
        maxSpots: 25,
        category: 'Cardio',
        isBooked: false,
      ),
      GymClass(
        name:  'Power Lifting',
        coach: 'Mike',
        time: '12:00 PM',
        duration: '60 min',
        spots: 4,
        maxSpots: 10,
        category: 'Strength',
        isBooked: false,
      ),
      GymClass(
        name:  'Yoga Flow',
        coach: 'Sara',
        time: '06:30 PM',
        duration: '60 min',
        spots:  10,
        maxSpots: 20,
        category: 'Flexibility',
        isBooked: false,
      ),
    ],
    'Thursday': [
      GymClass(
        name: 'HIIT Training',
        coach:  'Alex',
        time:  '06:00 AM',
        duration: '45 min',
        spots: 14,
        maxSpots: 15,
        category: 'Cardio',
        isBooked: false,
      ),
      GymClass(
        name:  'Stretch & Relax',
        coach: 'Sara',
        time: '11:00 AM',
        duration: '45 min',
        spots: 12,
        maxSpots: 15,
        category: 'Flexibility',
        isBooked:  false,
      ),
      GymClass(
        name: 'Boxing Bootcamp',
        coach: 'John',
        time: '07:00 PM',
        duration: '50 min',
        spots:  9,
        maxSpots: 15,
        category: 'Cardio',
        isBooked: true,
      ),
    ],
    'Friday': [
      GymClass(
        name: 'Spin Class',
        coach: 'Mike',
        time: '06:30 AM',
        duration: '45 min',
        spots: 16,
        maxSpots: 20,
        category: 'Cardio',
        isBooked: false,
      ),
      GymClass(
        name: 'CrossFit',
        coach: 'Alex',
        time: '05:00 PM',
        duration: '60 min',
        spots: 7,
        maxSpots: 12,
        category: 'Strength',
        isBooked: false,
      ),
      GymClass(
        name: 'Yoga & Meditation',
        coach: 'Sara',
        time: '07:30 PM',
        duration: '60 min',
        spots:  11,
        maxSpots: 20,
        category: 'Flexibility',
        isBooked: false,
      ),
    ],
    'Saturday': [
      GymClass(
        name: 'Warrior Workout',
        coach: 'John',
        time: '08:00 AM',
        duration: '60 min',
        spots: 13,
        maxSpots: 15,
        category: 'Strength',
        isBooked: true,
      ),
      GymClass(
        name: 'Zumba Dance',
        coach:  'Lisa',
        time:  '10:00 AM',
        duration: '45 min',
        spots: 20,
        maxSpots: 25,
        category: 'Cardio',
        isBooked: false,
      ),
      GymClass(
        name: 'Power Yoga',
        coach: 'Sara',
        time: '04:00 PM',
        duration: '60 min',
        spots: 15,
        maxSpots: 20,
        category: 'Flexibility',
        isBooked: false,
      ),
    ],
    'Sunday': [
      GymClass(
        name: 'Gentle Yoga',
        coach: 'Sara',
        time: '09:00 AM',
        duration: '60 min',
        spots: 17,
        maxSpots: 20,
        category: 'Flexibility',
        isBooked: false,
      ),
      GymClass(
        name:  'Family Fitness',
        coach: 'Lisa',
        time: '11:00 AM',
        duration: '45 min',
        spots: 22,
        maxSpots: 30,
        category: 'Cardio',
        isBooked:  false,
      ),
      GymClass(
        name: 'Recovery Session',
        coach: 'Mike',
        time: '05:00 PM',
        duration: '45 min',
        spots:  8,
        maxSpots: 15,
        category:  'Flexibility',
        isBooked: false,
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
      _isLoading = false;
    });
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Cardio': 
        return Colors.orange;
      case 'Strength':
        return Colors.red;
      case 'Flexibility':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Cardio': 
        return Icons.favorite;
      case 'Strength':
        return Icons.fitness_center;
      case 'Flexibility':
        return Icons. self_improvement;
      default:
        return Icons.sports_gymnastics;
    }
  }

  void _bookClass(GymClass gymClass) {
    setState(() {
      gymClass.isBooked = ! gymClass.isBooked;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          gymClass.isBooked 
            ? '✓ Booked:  ${gymClass.name}' 
            : '✗ Cancelled: ${gymClass.name}',
        ),
        backgroundColor: gymClass.isBooked ? Colors. green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors. black,
        title: const Text(
          "CLASS SCHEDULE",
          style: TextStyle(
            fontFamily: 'Alegreya SC',
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children: [
                      Text(
                        _username == null ?  'Hey, User!' : 'Hey, $_username!',
                        style:  const TextStyle(
                          color:  Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Find your perfect class',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Day Selector
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: _days.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedDayIndex == index;
                      final isToday = index == DateTime.now().weekday - 1;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDayIndex = index;
                          });
                        },
                        child: Container(
                          width: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: isSelected 
                              ? Colors.red 
                              : Colors.white.withAlpha(13),
                            borderRadius: BorderRadius.circular(15),
                            border: Border. all(
                              color: isToday && ! isSelected
                                ?  Colors.red. withAlpha(128)
                                : Colors.white.withAlpha(31),
                              width: isToday && !isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment:  MainAxisAlignment.center,
                            children: [
                              Text(
                                _days[index],
                                style: TextStyle(
                                  color:  isSelected 
                                    ? Colors.white 
                                    : const Color.fromRGBO(255, 255, 255, 0.6),
                                  fontSize: 14,
                                  fontWeight: isSelected 
                                    ? FontWeight. bold 
                                    : FontWeight.normal,
                                ),
                              ),
                              if (isToday) ...[
                                const SizedBox(height: 4),
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration:  BoxDecoration(
                                    color: isSelected 
                                      ? Colors.white 
                                      : Colors. red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Classes List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _fullDays[_selectedDayIndex]. toUpperCase(),
                        style:  const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Alegreya SC',
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        '${_schedule[_fullDays[_selectedDayIndex]]?.length ?? 0} Classes',
                        style: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _schedule[_fullDays[_selectedDayIndex]]?.length ?? 0,
                    itemBuilder: (context, index) {
                      final gymClass = _schedule[_fullDays[_selectedDayIndex]]![index];
                      return _buildClassCard(gymClass);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildClassCard(GymClass gymClass) {
    final spotsLeft = gymClass.maxSpots - gymClass.spots;
    final isAlmostFull = spotsLeft <= 3;
    final categoryColor = _getCategoryColor(gymClass.category);
    final categoryIcon = _getCategoryIcon(gymClass.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors. white.withAlpha(13),
        borderRadius: BorderRadius. circular(15),
        border: Border.all(
          color: gymClass.isBooked 
            ? Colors.red. withAlpha(128)
            : Colors.white.withAlpha(31),
          width: gymClass.isBooked ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Category Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: categoryColor. withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:  Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: 24,
                ),
              ),

              const SizedBox(width: 15),

              // Class Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            gymClass.name,
                            style: const TextStyle(
                              color:  Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (gymClass.isBooked)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration:  BoxDecoration(
                              color: Colors.green.withAlpha(51),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'BOOKED',
                              style:  TextStyle(
                                color:  Colors.green,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: Colors. white. withAlpha(128),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Coach ${gymClass.coach}',
                          style: const TextStyle(
                            color:  Color.fromRGBO(255, 255, 255, 0.6),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: categoryColor.withAlpha(51),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            gymClass.category,
                            style: TextStyle(
                              color: categoryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Divider
          Container(
            height: 1,
            color:  Colors.white.withAlpha(31),
          ),

          const SizedBox(height: 15),

          // Time and Action Row
          Row(
            children:  [
              // Time
              Icon(
                Icons.access_time,
                size: 16,
                color:  Colors.white.withAlpha(128),
              ),
              const SizedBox(width: 6),
              Text(
                gymClass.time,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(width: 15),

              // Duration
              Icon(
                Icons. timer_outlined,
                size: 16,
                color: Colors.white. withAlpha(128),
              ),
              const SizedBox(width: 6),
              Text(
                gymClass.duration,
                style: const TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.6),
                  fontSize: 13,
                ),
              ),

              const Spacer(),

              // Spots Available
              if (isAlmostFull)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(51),
                    borderRadius: BorderRadius. circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 12,
                        color: Colors. orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$spotsLeft left',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  '$spotsLeft spots left',
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                    fontSize: 12,
                  ),
                ),

              const SizedBox(width:  12),

              // Book Button
              GestureDetector(
                onTap: () => _bookClass(gymClass),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: gymClass.isBooked 
                      ? Colors.white.withAlpha(31)
                      : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: gymClass.isBooked 
                        ? Colors. red 
                        : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    gymClass.isBooked ?  'Cancel' : 'Book',
                    style: TextStyle(
                      color: gymClass.isBooked 
                        ? Colors.red 
                        : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// GymClass Model
class GymClass {
  final String name;
  final String coach;
  final String time;
  final String duration;
  final int spots;
  final int maxSpots;
  final String category;
  bool isBooked;

  GymClass({
    required this.name,
    required this.coach,
    required this.time,
    required this.duration,
    required this.spots,
    required this.maxSpots,
    required this.category,
    this.isBooked = false,
  });
}