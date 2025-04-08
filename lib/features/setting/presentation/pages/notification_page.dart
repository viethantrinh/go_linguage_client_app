import 'package:flutter/material.dart';
import 'package:go_linguage/core/common/widgets/back_button.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/core/services/notification_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isDailyReminderEnabled = true;
  TimeOfDay selectedTime = const TimeOfDay(hour: 20, minute: 30); // 8:30 PM
  List<bool> selectedDays = [true, true, true, true, true, true, true]; // T2-CN
  List<String> dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  final NotificationService _notificationService = NotificationService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    // Initialize notification service
    await _notificationService.init();

    // Load saved settings
    final settings = await _notificationService.getNotificationSettings();

    if (settings != null) {
      setState(() {
        isDailyReminderEnabled = settings['isEnabled'] as bool;
        selectedDays = List<bool>.from(settings['selectedDays']);

        final timeMap = settings['selectedTime'] as Map<String, dynamic>;
        selectedTime = TimeOfDay(
          hour: timeMap['hour'] as int,
          minute: timeMap['minute'] as int,
        );

        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1.5, color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 10,
                children: [
                  const CustomBackButton(),
                  Text(
                    "Thông báo",
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildReminderCard(),
                  const SizedBox(height: 24),
                  //_buildTestNotificationButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildTestNotificationButton() {
    return ElevatedButton(
      onPressed: () async {
        await _notificationService.showTestNotification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Đã gửi thông báo kiểm tra. Kiểm tra thanh thông báo của bạn.'),
            duration: Duration(seconds: 3),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.yellow,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Kiểm tra thông báo ngay',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildReminderCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_none_outlined,
                color: Colors.black54,
                size: 28,
              ),
              const SizedBox(width: 16),
              const Text(
                'Nhắc nhở hàng ngày',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Switch(
                value: isDailyReminderEnabled,
                onChanged: (value) {
                  setState(() {
                    isDailyReminderEnabled = value;
                  });

                  if (value) {
                    _notificationService.scheduleStudyReminder(
                      selectedDays: selectedDays,
                      selectedTime: selectedTime,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã bật thông báo nhắc nhở học tập'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    _notificationService.disableNotifications();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã tắt thông báo nhắc nhở học tập'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                activeColor: AppColor.primary500,
                //activeTrackColor: AppColor.yellow.withOpacity(0.5),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              if (isDailyReminderEnabled) {
                _showReminderBottomSheet();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hàng ngày',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    _formatTimeOfDay(selectedTime),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'am' : 'pm';
    return '$hour:$minute $period';
  }

  void _showReminderBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Nhắc nhở',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ngày nào bạn muốn được nhắc nhở học?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDaySelector(setState),
                  const SizedBox(height: 30),
                  const Text(
                    'Khi nào trong ngày?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTimeSelector(setState),
                  const Spacer(),
                  _buildBottomButtons(),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      // Update the main UI when the bottom sheet is closed
      setState(() {});
    });
  }

  Widget _buildDaySelector(StateSetter bottomSheetSetState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        7,
        (index) => GestureDetector(
          onTap: () {
            bottomSheetSetState(() {
              selectedDays[index] = !selectedDays[index];
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: selectedDays[index]
                  ? AppColor.primary500
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: selectedDays[index]
                  ? null
                  : Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Text(
                dayLabels[index],
                style: TextStyle(
                  color: selectedDays[index] ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelector(StateSetter bottomSheetSetState) {
    // Simplified time selector with hours, minutes, and AM/PM
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeColumn(
          bottomSheetSetState,
          List.generate(12, (index) => (index + 1).toString()),
          selectedTime.hourOfPeriod == 0 ? 11 : selectedTime.hourOfPeriod - 1,
          (index) {
            final newHour = index + 1;
            final hour = selectedTime.period == DayPeriod.am
                ? (newHour == 12 ? 0 : newHour)
                : (newHour == 12 ? 12 : newHour + 12);
            bottomSheetSetState(() {
              selectedTime = TimeOfDay(hour: hour, minute: selectedTime.minute);
            });
          },
        ),
        const SizedBox(width: 20),
        _buildTimeColumn(
          bottomSheetSetState,
          List.generate(60, (index) => index.toString().padLeft(2, '0')),
          selectedTime.minute,
          (index) {
            bottomSheetSetState(() {
              selectedTime = TimeOfDay(hour: selectedTime.hour, minute: index);
            });
          },
        ),
        const SizedBox(width: 20),
        _buildTimeColumn(
          bottomSheetSetState,
          ['SA', 'CH'],
          selectedTime.period == DayPeriod.am ? 0 : 1,
          (index) {
            final newHour = selectedTime.hourOfPeriod +
                (index == 0 ? 0 : 12) -
                (selectedTime.period == DayPeriod.pm ? 12 : 0);
            bottomSheetSetState(() {
              selectedTime =
                  TimeOfDay(hour: newHour, minute: selectedTime.minute);
            });
          },
        ),
      ],
    );
  }

  Widget _buildTimeColumn(
    StateSetter bottomSheetSetState,
    List<String> items,
    int selectedIndex,
    Function(int) onChanged,
  ) {
    return SizedBox(
      height: 150,
      width: 60,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 40,
        perspective: 0.005,
        diameterRatio: 1.5,
        physics: const FixedExtentScrollPhysics(),
        controller: FixedExtentScrollController(initialItem: selectedIndex),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: items.length,
          builder: (context, index) {
            return Center(
              child: Text(
                items[index],
                style: TextStyle(
                  fontSize: index == selectedIndex ? 20 : 16,
                  fontWeight: index == selectedIndex
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: index == selectedIndex
                      ? Colors.black
                      : Colors.grey.shade500,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Huỷ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (isDailyReminderEnabled) {
                _notificationService.scheduleStudyReminder(
                  selectedDays: selectedDays,
                  selectedTime: selectedTime,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã cập nhật lịch nhắc nhở học tập'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Cứu',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
