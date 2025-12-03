import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyworth_land_survey/Utils/CommonStyles.dart';
import 'package:provider/provider.dart';
import 'package:hyworth_land_survey/Provider/app_provider.dart';
import 'package:hyworth_land_survey/model/SurveyModel.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/widgets/CommonAppBar.dart';
import 'package:hyworth_land_survey/widgets/Filter.dart';
import 'package:hyworth_land_survey/Screens/SurveyCard.dart';
import 'package:hyworth_land_survey/Utils/commonimages.dart';

enum SurveyFilter {
  all,
  thisWeek,
  thisMonth,
  thisYear,
  pending,
  awaitConfirmation,
  requiredConsent
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class SurveyListingScreen extends StatefulWidget {
  static const String route = "/surveyListingScreen";

  const SurveyListingScreen({Key? key}) : super(key: key);

  @override
  State<SurveyListingScreen> createState() => _SurveyListingScreenState();
}

class _SurveyListingScreenState extends State<SurveyListingScreen>
    with RouteAware {
  TextEditingController _searchController = TextEditingController();
  Set<TimeFilter> _currentFilters = {TimeFilter.all};
  final FocusNode _focusNode = FocusNode();
  SurveyFilter _currentFilter = SurveyFilter.all;

  final BorderSide enableBorder = BorderSide(
    color: CommonColors.background,
    // color: CraftColors.neutral20Color,
    width: 1.0,
  );
  final BorderRadius borderRadius = const BorderRadius.all(
    Radius.circular(8),
  );
  final BorderSide focusedBorder = const BorderSide(
    color: CommonColors.blue,
    width: 1.0,
  );
  @override
  void initState() {
    super.initState();
    context.read<AppProvider>().loadSurveys(); // initial load
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _searchController.dispose();
    super.dispose();
  }

  // 👇 This is called when you come back from another screen
  @override
  void didPopNext() {
    context.read<AppProvider>().loadSurveys();
  }

  List<SurveyModel> _getFilteredSurveys(List<SurveyModel> surveys) {
    final now = DateTime.now();
    DateTime startDate = DateTime(1970);

    // 🕒 Handle time filters
    switch (_currentFilter) {
      case SurveyFilter.thisWeek:
        startDate = now.subtract(Duration(days: now.weekday - 1));
        break;
      case SurveyFilter.thisMonth:
        startDate = DateTime(now.year, now.month, 1);
        break;
      case SurveyFilter.thisYear:
        startDate = DateTime(now.year, 1, 1);
        break;
      default:
        break;
    }

    final searchText = _searchController.text.trim().toLowerCase();

    return surveys.where((s) {
      if (s.surveyDate == null) return false;

      final date = DateTime.fromMillisecondsSinceEpoch(s.surveyDate!);
      final matchesDate = (_currentFilter == SurveyFilter.all ||
              _currentFilter == SurveyFilter.thisWeek ||
              _currentFilter == SurveyFilter.thisMonth ||
              _currentFilter == SurveyFilter.thisYear)
          ? date.isAfter(startDate)
          : true;

      final matchesSearch = searchText.isEmpty ||
          s.surveyId!.toLowerCase().contains(searchText) ||
          (s.landDistrict?.toLowerCase().contains(searchText) ?? false) ||
          (s.landVillage?.toLowerCase().contains(searchText) ?? false);

      // 🧠 Handle status filters
     // 🧠 Handle status filters
bool matchesStatus = true;
final status = s.surveyStatus?.toLowerCase().trim();

switch (_currentFilter) {
  case SurveyFilter.pending:
    matchesStatus = status == 'pending';
    break;
  case SurveyFilter.awaitConfirmation:
    matchesStatus = status == 'await confirmation';
    break;
  case SurveyFilter.requiredConsent:
    matchesStatus = status == 'required consent';
    break;
  default:
    break;
}


      return matchesDate && matchesSearch && matchesStatus;
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
          title: t(context, "survey_listing"),
          isbackVisible: false,
          islogout: true),
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 41,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintStyle: CommonStyles.textFieldHint,
                        errorStyle: CommonStyles.textFieldHint,
                        hintText: t(context, "search"),
                        prefixIcon:
                            Icon(Icons.search, color: CommonColors.hintGrey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: borderRadius,
                            borderSide: enableBorder),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: borderRadius,
                            borderSide: focusedBorder),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: borderRadius,
                            borderSide: enableBorder),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: borderRadius,
                            borderSide: enableBorder),
                        errorBorder: OutlineInputBorder(
                            borderRadius: borderRadius,
                            borderSide: enableBorder),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: borderRadius,
                            borderSide: focusedBorder),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    // final result = await showTimeFilterDialogSingle(
                    //   context,
                    //   initialSelection: _currentFilters.first,
                    // );
                    // if (result != null) setState(() => _currentFilters = {result});
                    final result =
                        await showSurveyFilterDialog(context, _currentFilter);
                    if (result != null) setState(() => _currentFilter = result);
                  },
                  child: SvgPicture.asset(CommonImagePath.filter,
                      width: 30, height: 30, color: CommonColors.blue),
                ),
              ],
            ),
          ),

          // 📋 Survey List
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, provider, _) {
                final filtered = _getFilteredSurveys(provider.surveys);

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/images/noland.svg',
                            width: 150),
                        SizedBox(height: 20),
                        Text('No Land Surveys Yet',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text(
                          'Start your first land survey by tapping the button below.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final survey = filtered[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SurveyCard(
                        surveyListing: filtered,
                        index: index,
                        status: survey.surveyStatus ?? "",
                        uploadconsent: false,
                        selectedIndex: 0,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<SurveyFilter?> showSurveyFilterDialog(
      BuildContext context, SurveyFilter selected) {
    return showDialog<SurveyFilter>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Filter"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: SurveyFilter.values.map((filter) {
                String label;
                switch (filter) {
                  case SurveyFilter.all:
                    label = "All";
                    break;
                  case SurveyFilter.thisWeek:
                    label = "This Week";
                    break;
                  case SurveyFilter.thisMonth:
                    label = "This Month";
                    break;
                  case SurveyFilter.thisYear:
                    label = "This Year";
                    break;
                  case SurveyFilter.pending:
                    label = "Pending";
                    break;
                 case SurveyFilter.awaitConfirmation:
  label = "Await Confirmation";
  break;
case SurveyFilter.requiredConsent:
  label = "Required Consent";
  break;

                }

                return RadioListTile<SurveyFilter>(
                  title: Text(label),
                  value: filter,
                  groupValue: selected,
                  onChanged: (value) => Navigator.pop(context, value),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
