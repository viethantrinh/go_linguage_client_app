import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/route/app_route_path.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_linguage/features/main/presentation/bloc/main_bloc.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        final mainState = state as MainInitial;
        return Scaffold(
          body: widget.navigationShell,
          bottomNavigationBar: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColor.line)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(0, Icons.lightbulb_outline, 'Học'),
                    _buildNavItem(1, Icons.menu_book_outlined, 'Kiểm tra'),
                    _buildNavItem(2, Icons.chat_outlined, 'Hội thoại'),
                    if (mainState.showProTab)
                      _buildNavItem(3, Icons.diamond_outlined, 'Pro'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final theme = Theme.of(context);
    final isSelected = widget.navigationShell.currentIndex == index;
    final color = isSelected ? AppColor.primary500 : AppColor.secondary;

    return InkWell(
      onTap: () {
        if (index == 3) {
          context.push(AppRoutePath.subscription);
          return;
        }
        widget.navigationShell.goBranch(
          index,
          initialLocation: index == widget.navigationShell.currentIndex,
        );
        // Cập nhật state trong MainBloc
        context.read<MainBloc>().add(UpdateMainState(index));
      },
      child: SizedBox(
        width: 95,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.labelLarge!.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
