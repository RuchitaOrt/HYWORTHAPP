import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hyworth_land_survey/Provider/app_provider.dart';
import 'package:hyworth_land_survey/Screens/SurveyForm/AddConsentForm.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/Utils/ShowDialog.dart';
import 'package:hyworth_land_survey/main.dart';
import 'package:provider/provider.dart'; // <-- import provider
import 'package:hyworth_land_survey/Screens/ConsentListingScreen.dart';
import 'package:hyworth_land_survey/Screens/DashboardScreen.dart';
import 'package:hyworth_land_survey/Screens/SurveyForm/SurveyDetailForm.dart';
import 'package:hyworth_land_survey/Screens/SurveyListingScreen.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/widgets/createSlideFromLeftRoute.dart';

class Maintabscreen extends StatefulWidget {
  final int selectedIndex;
  static const String route = "/mainTab_screen";
  const Maintabscreen({Key? key, this.selectedIndex = 1}) : super(key: key);

  @override
  State<Maintabscreen> createState() => _MaintabscreenState();
}

class _MaintabscreenState extends State<Maintabscreen> {
  int? _selectedIndex; // 🔹 Default = Dashboard

  final List<Widget> _screens = const [
    SurveyListingScreen(),
    DashboardScreen(),
    ConsentListingScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // 🔹 Call provider refresh based on tab
    Future.microtask(() {
      if (index == 0) {
        context.read<AppProvider>().refreshDashboard();
      } else if (index == 1) {
        context.read<AppProvider>().refreshDashboard();
      } else if (index == 2) {
        context.read<AppProvider>().refreshDashboard();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.selectedIndex;
  Future.microtask(() => getData());
}
void getData() async {
  final provider = context.read<AppProvider>();

  await provider.fetchLandList();
  await provider.loadSPendingurveys();
  await provider.loadCompletedSurveys();
  await provider.loadSurveys();

  setState(() {}); // 🔥 force UI refresh
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showConfirmDialog(
          context, "Exit", "Are You Sure want to Quit the application ? ", () {
        //exit(0);
        //SystemNavigator.pop();
        SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
      }),
      child: Scaffold(
        backgroundColor: CommonColors.white,
        body: _screens[_selectedIndex!],
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          foregroundColor: CommonColors.white,
          activeIcon: Icons.close,
          backgroundColor: CommonColors.blue,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.article, color: Colors.white),
              backgroundColor: Colors.green,
              label: 'Add Consent',
              onTap: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ConsentFormScreen()),
                );

                if (result == true) {
                  // ✅ Refresh provider after upload
                  context.read<AppProvider>().loadSPendingurveys();
                  context.read<AppProvider>().loadSurveys();
                  context.read<AppProvider>().refreshDashboard();
                }
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.landscape, color: Colors.white),
              backgroundColor: Colors.orange,
              label: t(context, "add_land_Survey"),
              onTap: () async {
                final result = await Navigator.of(context).push(
                  createSlideFromBottomRoute(SurveyDetailForm(
                    isEdit: 0,
                  )),
                );
                if (result == true) {
                  context.read<AppProvider>().loadSPendingurveys();
                  context.read<AppProvider>().loadSurveys();
                  context.read<AppProvider>().refreshDashboard();
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 63,
          color: CommonColors.blue,
          shape: const CircularNotchedRectangle(),
          notchMargin: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                  Icons.supervised_user_circle, t(context, "survey"), 0),
              const SizedBox(width: 40),
              _buildNavItem(Icons.home, t(context, "home"), 1),
              const SizedBox(width: 40),
              _buildNavItem(Icons.edit_document, t(context, "consent"), 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? CommonColors.white : Colors.white60;

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 1),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
