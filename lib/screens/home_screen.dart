import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  final List<_HomeTileData> tiles = [
    _HomeTileData(
      'Exercises',
      Icons.fitness_center,
      Colors.blue.shade700,
      '/exercises',
      'exercisesHero',
    ),
    _HomeTileData(
      'Workout Plan',
      Icons.calendar_today,
      Colors.blue.shade400,
      '/workout-plan',
      'planHero',
    ),
    _HomeTileData(
      'Profile',
      Icons.person,
      Colors.lightBlue.shade300,
      '/profile',
      'profileHero',
    ),
    _HomeTileData(
      'Progress',
      Icons.show_chart,
      Colors.blue.shade600,
      '/progress',
      'progressHero',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildTile(BuildContext context, _HomeTileData tile) {
    return ScaleOnTap(
      onTap: () {
        Navigator.pushNamed(context, tile.route);
      },
      child: Hero(
        tag: tile.heroTag,
        child: Container(
          decoration: BoxDecoration(
            color: tile.color,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(tile.icon, size: 50, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                tile.title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout App'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.blue.shade800,
      ),
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Welcome to Workout App!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children:
                      tiles.map((tile) => _buildTile(context, tile)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTileData {
  final String title;
  final IconData icon;
  final Color color;
  final String route;
  final String heroTag;

  _HomeTileData(this.title, this.icon, this.color, this.route, this.heroTag);
}

// Reusable tap animation
class ScaleOnTap extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const ScaleOnTap({super.key, required this.child, required this.onTap});

  @override
  State<ScaleOnTap> createState() => _ScaleOnTapState();
}

class _ScaleOnTapState extends State<ScaleOnTap>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails _) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
