import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Database/DatabaseHelper.dart';
import 'package:hyworth_land_survey/Provider/app_provider.dart';
import 'package:hyworth_land_survey/Screens/MainTabScreen.dart';
import 'package:hyworth_land_survey/Screens/SurveyCard.dart';
import 'package:hyworth_land_survey/Utils/GlobalLists.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/widgets/CommonAppBar.dart';
import 'package:hyworth_land_survey/widgets/Piechart.dart';
import 'package:hyworth_land_survey/widgets/SurveyStatsRow.dart';
import 'package:hyworth_land_survey/widgets/createSlideFromLeftRoute.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  static const String route = "/dashboard_screen";
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController(viewportFraction: 1);
  int _currentPage = 0;
  final int currentYear = DateTime.now().year;

  Map<String, dynamic> surveyCounts = {
    "surveys": 0,
    "approvedCount": 0,
    "consentCount": 0,
    "pendingCount": 0,
  };
  late String selectedMonth;
  late List<String> months;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedMonth = "All $currentYear";
    months = [
      "All $currentYear",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    _loadSurveyData();
  }

  Future<void> _loadSurveyData() async {
    final data = await DatabaseHelper.instance
        .getAllSurveysWithCounts(); // no month filter
    setState(() {
      surveyCounts = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.white,
      appBar: CommonAppBar(
        title: t(context, "dashboard"), // You could translate this too
        isbackVisible: false,
        islogout: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Consumer<AppProvider>(
          builder: (context, provider, child) {
            return provider.surveys.length == 0
                ? _buildEmptyState(context)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Survey Overview Header
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t(context, 'survey_Stats'),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            DropdownButton<String>(
                              value: selectedMonth,
                              underline: const SizedBox(),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                              items: months.map((month) {
                                return DropdownMenuItem(
                                  value: month,
                                  child: Text(month),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                setState(() {
                                  selectedMonth = value!;
                                });

                                // ✅ Get month index
                                int? monthIndex;
                                if (selectedMonth != "All") {
                                  monthIndex = months.indexOf(
                                      selectedMonth); // e.g. September -> 9
                                }

                                // ✅ Fetch filtered counts
                                final data = await DatabaseHelper.instance
                                    .getAllSurveysWithCounts(
                                  month: monthIndex,
                                  year: DateTime.now().year,
                                );

                                // ✅ Update state with new data
                                setState(() {
                                  surveyCounts = data;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Survey Stats Row
                      SurveyStatsRow(
                        totalSurveys: int.parse(GlobalLists.totalSurvey),
                        approvedLands: int.parse(GlobalLists.approvedSurvey),
                        consentForms: int.parse(GlobalLists.consentSurvey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Survey Stats Section
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t(context, 'survey_overview'),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      // Survey Progress Chart
                      SurveyProgressChart(
                        totalSurveys: int.parse(GlobalLists.totalSurvey),
                        approvedLands: int.parse(GlobalLists.approvedSurvey),
                        consentForms: int.parse(GlobalLists.consentSurvey),
                        pendingSurvey: int.parse(GlobalLists.pendingSurvey),
                      ),

                      const SizedBox(height: 2),

                      // Pending Survey Section
                      provider.pendingsurveys.length == 0
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    t(context, 'pending_survey'),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        createSlideFromBottomRoute(
                                          Maintabscreen(
                                            selectedIndex: 0,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      t(context, 'view_all'),
                                      style: TextStyle(
                                          color: CommonColors.blue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                      // Pending Survey Cards
                      Column(
                        children: [
                          SizedBox(
                            height: 280,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: provider.pendingsurveys.length > 6
                                  ? 6
                                  : provider.pendingsurveys.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: _buildCard(index, provider),
                                );
                              },
                            ),
                          ),
                          // const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                provider.pendingsurveys.length > 6
                                    ? 6
                                    : provider.pendingsurveys.length, (index) {
                              bool isSelected = _currentPage == index;
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: isSelected ? 32 : 8,
                                height: isSelected ? 16 : 8,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? CommonColors.blue
                                      : Colors.grey,
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  border: Border.all(
                                    color: isSelected
                                        ? CommonColors.blue
                                        : Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                                child: isSelected
                                    ? Center(
                                        child: Text(
                                          provider.pendingsurveys.length > 6
                                              ? "${index + 1}/6"
                                              : "${index + 1}/${provider.pendingsurveys.length}",
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Widget _buildCard(int index, AppProvider provider) {
    return SurveyCard(
      status: t(context, 'pending'), // dynamic translation for status
      index: index,
      surveyListing: provider.pendingsurveys,
      uploadconsent: false,
      selectedIndex: 1,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 You can use any Lottie animation or image
            SizedBox(
                height: 300,
                child: Image.asset(
                  'assets/images/landscreen.gif',
                  height: 200,
                  fit: BoxFit.contain,
                )),
            const SizedBox(height: 24),
            const Text(
              "No surveys found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Start by adding your first land survey.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
