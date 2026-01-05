import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String?  _username;
  String _selectedPeriod = 'Week';
  bool _isLoading = true;

  // Sample data - replace with actual API calls
  final Map<String, List<double>> _workoutData = {
    'Week': [3, 5, 4, 6, 5, 7, 6],
    'Month': [15, 18, 22, 20, 25, 23, 28, 26],
    'Year': [60, 75, 85, 90, 100, 110, 115, 120, 125, 130, 140, 145],
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences. getInstance();
    setState(() {
      _username = prefs.getString('username');
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "MY PROGRESS",
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Header
                  Text(
                    _username == null ?  'Welcome, User!' : 'Welcome, $_username!',
                    style:  const TextStyle(
                      color:  Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Track your fitness journey',
                    style: TextStyle(
                      color: Color. fromRGBO(255, 255, 255, 0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.fitness_center,
                          title:  'Workouts',
                          value: '24',
                          subtitle: 'This month',
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons. local_fire_department,
                          title: 'Streak',
                          value: '7',
                          subtitle: 'Days',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.timer_outlined,
                          title: 'Time',
                          value: '18h',
                          subtitle: 'This month',
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.trending_up,
                          title:  'Goal',
                          value: '85%',
                          subtitle: 'Achieved',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Chart Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(13),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withAlpha(31),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'WORKOUT ACTIVITY',
                          style: TextStyle(
                            color: Colors. white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Alegreya SC',
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Period Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildPeriodButton('Week'),
                            const SizedBox(width: 10),
                            _buildPeriodButton('Month'),
                            const SizedBox(width: 10),
                            _buildPeriodButton('Year'),
                          ],
                        ),
                        const SizedBox(height:  25),

                        // Simple Bar Chart
                        SizedBox(
                          height:  200,
                          child:  _buildSimpleBarChart(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Progress Insights
                  const Text(
                    'PROGRESS INSIGHTS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya SC',
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 15),

                  _buildInsightCard(
                    icon: Icons.trending_up,
                    title:  'Great consistency! ',
                    description: 'You\'ve trained 6 out of 7 days this week',
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildInsightCard(
                    icon: Icons.emoji_events,
                    title: 'Personal record',
                    description: 'Most active month so far this year',
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 12),
                  _buildInsightCard(
                    icon:  Icons.lightbulb_outline,
                    title: 'Keep it up',
                    description: '3 more days to reach your monthly goal',
                    color: Colors.red,
                  ),
                  const SizedBox(height: 30),

                  // Recent Achievements
                  const Text(
                    'RECENT ACHIEVEMENTS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alegreya SC',
                      letterSpacing:  1.2,
                    ),
                  ),
                  const SizedBox(height: 15),

                  _buildAchievementCard(
                    icon: Icons.local_fire_department,
                    title: '7-Day Streak',
                    date:  '2 days ago',
                  ),
                  const SizedBox(height:  12),
                  _buildAchievementCard(
                    icon: Icons.fitness_center,
                    title:  '20 Workouts',
                    date: '5 days ago',
                  ),
                  const SizedBox(height: 12),
                  _buildAchievementCard(
                    icon: Icons.star,
                    title: 'First Week Complete',
                    date: '1 week ago',
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withAlpha(31),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.4),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    final isSelected = _selectedPeriod == period;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = period;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ?  Colors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ?  Colors.red : Colors.white. withAlpha(77),
          ),
        ),
        child: Text(
          period,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color. fromRGBO(255, 255, 255, 0.6),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleBarChart() {
    final data = _workoutData[_selectedPeriod] ?? [];
    final maxValue = data.reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(data.length, (index) {
        final value = data[index];
        final heightPercentage = value / maxValue;

        return Expanded(
          child:  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Value label
                Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.7),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                // Bar
                Container(
                  width: double.infinity,
                  height: 150 * heightPercentage,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.red,
                        Colors. red.withAlpha(153),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Index label
                Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius:  BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withAlpha(31),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color. withAlpha(51),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color:  Color.fromRGBO(255, 255, 255, 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard({
    required IconData icon,
    required String title,
    required String date,
  }) {
    return Container(
      padding:  const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withAlpha(31),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withAlpha(51),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.red, size: 24),
          ),
          const SizedBox(width:  15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment. start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors. white,
                    fontSize: 14,
                    fontWeight:  FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle,
            color: Colors.green. withAlpha(179),
            size: 20,
          ),
        ],
      ),
    );
  }
}