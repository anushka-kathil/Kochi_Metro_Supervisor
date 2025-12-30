import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class WhatIfPage extends StatefulWidget {
  const WhatIfPage({super.key});

  @override
  State<WhatIfPage> createState() => _WhatIfPageState();
}

class _WhatIfPageState extends State<WhatIfPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    Get.put(WhatIfController());
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WhatIfController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Premium AppBar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF00D2A3), Color(0xFF5B73E8)],
                  ),
                ),
                child: Stack(
                  children: [
                    // Animated Background Pattern
                    ...List.generate(6, (index) {
                      return Positioned(
                        left: (index * 60.0) - 30,
                        top: (index * 25.0) - 15,
                        child: TweenAnimationBuilder(
                          duration:
                              Duration(milliseconds: 2000 + (index * 300)),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, double value, child) {
                            return Transform.rotate(
                              angle: value * 2 * math.pi,
                              child: Opacity(
                                opacity: 0.1,
                                child: Icon(
                                  Icons.settings_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: const Text(
                                'Train Allocation Simulator',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: const Text(
                                'Optimize train distribution & generate schedules',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.refresh_rounded, color: Colors.white),
                ),
                onPressed: () => controller.resetToDefaults(),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Card
                      _buildSummaryCard(controller),
                      const SizedBox(height: 24),

                      // Train Allocation Section
                      _buildSectionTitle('Train Allocation'),
                      const SizedBox(height: 16),

                      // Train Category Controls
                      _buildTrainCategoryCard(
                        'Running Trains',
                        Icons.train_rounded,
                        const Color(0xFF667eea),
                        controller.runningTrains,
                        controller.incrementRunning,
                        controller.decrementRunning,
                      ),
                      const SizedBox(height: 12),

                      _buildTrainCategoryCard(
                        'Maintenance Trains',
                        Icons.build_rounded,
                        const Color(0xFFf093fb),
                        controller.maintenanceTrains,
                        controller.incrementMaintenance,
                        controller.decrementMaintenance,
                      ),
                      const SizedBox(height: 12),

                      _buildTrainCategoryCard(
                        'Cleaning Trains',
                        Icons.cleaning_services_rounded,
                        const Color(0xFF00D2A3),
                        controller.cleaningTrains,
                        controller.incrementCleaning,
                        controller.decrementCleaning,
                      ),
                      const SizedBox(height: 12),

                      _buildTrainCategoryCard(
                        'Revenue Operation',
                        Icons.monetization_on_rounded,
                        const Color(0xFFFFAC33),
                        controller.revenueOperationTrains,
                        controller.incrementRevenueOperation,
                        controller.decrementRevenueOperation,
                      ),
                      const SizedBox(height: 12),

                      _buildTrainCategoryCard(
                        'Standby Trains',
                        Icons.pause_circle_rounded,
                        const Color(0xFF9BA3B4),
                        controller.standbyTrains,
                        controller.incrementStandby,
                        controller.decrementStandby,
                      ),

                      const SizedBox(height: 24),

                      // Simulation Button
                      _buildSimulationButton(controller),
                      const SizedBox(height: 24),

                      // Results Section
                      Obx(() {
                        if (controller.hasResults.value) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Generated Schedule'),
                              const SizedBox(height: 16),
                              _buildScheduleResults(controller),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      }),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Color(0xFF2D3142),
      ),
    );
  }

  Widget _buildSummaryCard(WhatIfController controller) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                controller.isValid
                    ? const Color(0xFF00D2A3).withOpacity(0.1)
                    : const Color(0xFFFF6B6B).withOpacity(0.1),
                controller.isValid
                    ? const Color(0xFF5B73E8).withOpacity(0.1)
                    : const Color(0xFFFF6B6B).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: controller.isValid
                  ? const Color(0xFF00D2A3).withOpacity(0.3)
                  : const Color(0xFFFF6B6B).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildEditableSummaryItem(
                    'Total Trains',
                    controller.totalTrains,
                    Icons.train_rounded,
                    const Color(0xFF2D3142),
                    controller.incrementTotal,
                    controller.decrementTotal,
                  ),
                  _buildSummaryItem(
                    'Allocated',
                    controller.allocatedTrains.toString(),
                    Icons.assignment_turned_in_rounded,
                    controller.isValid
                        ? const Color(0xFF00D2A3)
                        : const Color(0xFFFF6B6B),
                  ),
                  _buildSummaryItem(
                    'Remaining',
                    controller.remainingTrains.toString(),
                    Icons.inventory_rounded,
                    controller.remainingTrains >= 0
                        ? const Color(0xFF667eea)
                        : const Color(0xFFFF6B6B),
                  ),
                ],
              ),
              if (!controller.isValid) ...[
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFFFF6B6B).withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_rounded,
                          color: const Color(0xFFFF6B6B), size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Exceeds total trains by ${-controller.remainingTrains}',
                        style: const TextStyle(
                          color: Color(0xFFFF6B6B),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ));
  }

  Widget _buildSummaryItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF7F8C8D),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildEditableSummaryItem(
    String label,
    RxInt valueObx,
    IconData icon,
    Color color,
    VoidCallback onIncrement,
    VoidCallback onDecrement,
  ) {
    return Obx(() => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7F8C8D),
              ),
            ),
            const SizedBox(height: 4),

            // Editable total trains with controls
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: onDecrement,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.remove,
                      size: 14,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  valueObx.value.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onIncrement,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 14,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Tap +/- to adjust',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: color.withOpacity(0.6),
              ),
            ),
          ],
        ));
  }

  Widget _buildTrainCategoryCard(
    String title,
    IconData icon,
    Color color,
    RxInt valueObx,
    VoidCallback onIncrement,
    VoidCallback onDecrement,
  ) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${valueObx.value} trains assigned',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7F8C8D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildControlButton(
                    Icons.remove_rounded,
                    () => onDecrement(),
                    valueObx.value > 0,
                    color,
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        valueObx.value.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildControlButton(
                    Icons.add_rounded,
                    () => onIncrement(),
                    true,
                    color,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildControlButton(
    IconData icon,
    VoidCallback onTap,
    bool enabled,
    Color color,
  ) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: enabled ? color : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : Colors.grey[500],
          size: 20,
        ),
      ),
    );
  }

  Widget _buildSimulationButton(WhatIfController controller) {
    return Obx(() => Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: controller.isValid
                  ? [const Color(0xFF00D2A3), const Color(0xFF5B73E8)]
                  : [Colors.grey[400]!, Colors.grey[500]!],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: controller.isValid
                ? [
                    BoxShadow(
                      color: const Color(0xFF00D2A3).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: controller.isValid && !controller.isSimulating.value
                  ? controller.runSimulation
                  : null,
              child: Center(
                child: controller.isSimulating.value
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            color: controller.isValid
                                ? Colors.white
                                : Colors.grey[600],
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Run Simulation',
                            style: TextStyle(
                              color: controller.isValid
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ));
  }

  Widget _buildScheduleResults(WhatIfController controller) {
    return Obx(() {
      if (controller.scheduleResults.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No schedule data available',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        children: [
          // Results Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00D2A3), Color(0xFF5B73E8)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Simulation Complete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${controller.scheduleResults.length} schedule items generated',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.runningTrains.value} Active',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Schedule Items List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.scheduleResults.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final schedule = controller.scheduleResults[index];
              return _buildScheduleCard(schedule, index);
            },
          ),
        ],
      );
    });
  }

  Widget _buildScheduleCard(ScheduleItem schedule, int index) {
    // Determine colors based on time slot
    Color getTimeSlotColor(String timeSlot) {
      switch (timeSlot.toLowerCase()) {
        case 'morning':
          return const Color(0xFFFFAC33);
        case 'afternoon':
          return const Color(0xFF00D2A3);
        case 'evening':
          return const Color(0xFF667eea);
        case 'night':
          return const Color(0xFF9BA3B4);
        default:
          return const Color(0xFF667eea);
      }
    }

    final color = getTimeSlotColor(schedule.timeSlot);

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Train Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.train_rounded,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Train Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Train ${schedule.trainId}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          schedule.timeSlot.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.route_rounded,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        schedule.route,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${schedule.startTime} - ${schedule.endTime}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Status Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00D2A3).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00D2A3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    schedule.status,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF00D2A3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// What If Controller
class WhatIfController extends GetxController {
  // Observable variables for train counts
  final RxInt totalTrains = 0.obs;
  final RxInt runningTrains = 0.obs;
  final RxInt maintenanceTrains = 0.obs;
  final RxInt cleaningTrains = 0.obs;
  final RxInt revenueOperationTrains = 0.obs;
  final RxInt standbyTrains = 0.obs;

  // Simulation state
  final RxBool isSimulating = false.obs;
  final RxBool hasResults = false.obs;
  final RxString errorMessage = ''.obs;

  // Results
  final RxList<ScheduleItem> scheduleResults = <ScheduleItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFromDashboard();
  }

  void _initializeFromDashboard() {
    try {
      // Initialize with realistic values
      totalTrains.value = 25; // Total fleet size
      runningTrains.value = 19; // Active trains
      maintenanceTrains.value = 3; // In maintenance
      cleaningTrains.value = 1; // Being cleaned
      revenueOperationTrains.value = 1; // Revenue operations
      standbyTrains.value = 1; // On standby
    } catch (e) {
      // Fallback values
      totalTrains.value = 31;
      runningTrains.value = 22;
      maintenanceTrains.value = 6;
      cleaningTrains.value = 1;
      revenueOperationTrains.value = 1;
      standbyTrains.value = 1;
    }
  }

  // Computed properties
  int get allocatedTrains =>
      runningTrains.value +
      maintenanceTrains.value +
      cleaningTrains.value +
      revenueOperationTrains.value +
      standbyTrains.value;

  int get remainingTrains => totalTrains.value - allocatedTrains;
  bool get isValid => allocatedTrains <= totalTrains.value;

  // Increment/Decrement methods for total trains
  void incrementTotal() {
    if (totalTrains.value < 50) {
      // Max limit of 50 trains
      totalTrains.value++;
    } else {
      Get.snackbar(
        'Maximum Limit',
        'Total trains cannot exceed 50',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void decrementTotal() {
    // Don't allow total to go below current allocated trains
    if (totalTrains.value > allocatedTrains) {
      totalTrains.value--;
    } else if (totalTrains.value == allocatedTrains && allocatedTrains > 0) {
      Get.snackbar(
        'Cannot Reduce Total',
        'Total trains cannot be less than currently allocated trains (${allocatedTrains})',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    } else if (totalTrains.value > 1) {
      // Minimum 1 train
      totalTrains.value--;
    }
  }

  void incrementRunning() {
    if (allocatedTrains < totalTrains.value) {
      runningTrains.value++;
    } else {
      _showValidationError();
    }
  }

  void decrementRunning() {
    if (runningTrains.value > 0) {
      runningTrains.value--;
    }
  }

  void incrementMaintenance() {
    if (allocatedTrains < totalTrains.value) {
      maintenanceTrains.value++;
    } else {
      _showValidationError();
    }
  }

  void decrementMaintenance() {
    if (maintenanceTrains.value > 0) {
      maintenanceTrains.value--;
    }
  }

  void incrementCleaning() {
    if (allocatedTrains < totalTrains.value) {
      cleaningTrains.value++;
    } else {
      _showValidationError();
    }
  }

  void decrementCleaning() {
    if (cleaningTrains.value > 0) {
      cleaningTrains.value--;
    }
  }

  void incrementRevenueOperation() {
    if (allocatedTrains < totalTrains.value) {
      revenueOperationTrains.value++;
    } else {
      _showValidationError();
    }
  }

  void decrementRevenueOperation() {
    if (revenueOperationTrains.value > 0) {
      revenueOperationTrains.value--;
    }
  }

  void incrementStandby() {
    if (allocatedTrains < totalTrains.value) {
      standbyTrains.value++;
    } else {
      _showValidationError();
    }
  }

  void decrementStandby() {
    if (standbyTrains.value > 0) {
      standbyTrains.value--;
    }
  }

  void _showValidationError() {
    Get.snackbar(
      'Cannot Exceed Total',
      'The sum of all categories cannot exceed total trains (${totalTrains.value})',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  void resetToDefaults() {
    _initializeFromDashboard();
    hasResults.value = false;
    errorMessage.value = '';
    scheduleResults.clear();

    Get.snackbar(
      'Reset Complete',
      'All values have been reset to defaults',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF667eea),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 1),
    );
  }

  // Simulate API call
  Future<void> runSimulation() async {
    if (!isValid) {
      _showValidationError();
      return;
    }

    try {
      isSimulating.value = true;
      errorMessage.value = '';
      hasResults.value = false;

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Generate mock schedule data
      _generateMockSchedule();

      hasResults.value = true;

      Get.snackbar(
        'Simulation Complete',
        'Schedule generated successfully with ${scheduleResults.length} items',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF00D2A3),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      errorMessage.value = 'Failed to generate schedule: ${e.toString()}';
      Get.snackbar(
        'Simulation Failed',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isSimulating.value = false;
    }
  }

  void _generateMockSchedule() {
    scheduleResults.clear();

    final timeSlots = ['Morning', 'Afternoon', 'Evening'];
    final routes = ['Route A', 'Route B', 'Route C'];

    // Generate schedules for running trains
    for (int i = 1; i <= runningTrains.value; i++) {
      final timeSlot = timeSlots[i % timeSlots.length];
      final route = routes[i % routes.length];

      scheduleResults.add(ScheduleItem(
        trainId: 'K-${(100 + i).toString().padLeft(3, '0')}',
        timeSlot: timeSlot,
        status: 'Scheduled',
        route: route,
        startTime: _getStartTime(timeSlot),
        endTime: _getEndTime(timeSlot),
      ));
    }

    // Sort by time slot
    scheduleResults.sort((a, b) {
      final order = {'Morning': 0, 'Afternoon': 1, 'Evening': 2};
      return order[a.timeSlot]!.compareTo(order[b.timeSlot]!);
    });
  }

  String _getStartTime(String timeSlot) {
    switch (timeSlot) {
      case 'Morning':
        return '06:00';
      case 'Afternoon':
        return '12:00';
      case 'Evening':
        return '18:00';
      default:
        return '06:00';
    }
  }

  String _getEndTime(String timeSlot) {
    switch (timeSlot) {
      case 'Morning':
        return '12:00';
      case 'Afternoon':
        return '18:00';
      case 'Evening':
        return '23:00';
      default:
        return '18:00';
    }
  }
}

// Schedule Item Model
class ScheduleItem {
  final String trainId;
  final String timeSlot;
  final String status;
  final String route;
  final String startTime;
  final String endTime;

  ScheduleItem({
    required this.trainId,
    required this.timeSlot,
    required this.status,
    required this.route,
    required this.startTime,
    required this.endTime,
  });
}
