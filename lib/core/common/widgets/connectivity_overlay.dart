import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import '../../network/connectivity/connectivity_bloc.dart';
import '../../network/connectivity/connectivity_state.dart';
import '../../network/connectivity/connectivity_event.dart';

class ConnectivityOverlay extends StatelessWidget {
  final Widget child;

  const ConnectivityOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        child,
        BlocBuilder<ConnectivityBloc, ConnectivityState>(
          builder: (context, state) {
            if (state is ConnectivityDisconnected) {
              return _buildNoConnectionOverlay(context);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildNoConnectionOverlay(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off,
                size: 70,
                color: AppColor.critical,
              ),
              const SizedBox(height: 20),
              Text(
                'Không có kết nối mạng',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Vui lòng kiểm tra kết nối mạng của bạn và thử lại.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<ConnectivityBloc>().add(CheckConnectivity());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.yellow,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Thử lại',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
