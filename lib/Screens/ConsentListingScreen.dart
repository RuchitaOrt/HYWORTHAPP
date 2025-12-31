import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hyworth_land_survey/Provider/app_provider.dart';
import 'package:hyworth_land_survey/Screens/SurveyCard.dart';
import 'package:hyworth_land_survey/Utils/CommonStyles.dart';
import 'package:hyworth_land_survey/Utils/HelperClass.dart';
import 'package:hyworth_land_survey/Utils/commoncolors.dart';
import 'package:hyworth_land_survey/Utils/commonimages.dart';
import 'package:hyworth_land_survey/model/SurveyModel.dart';
import 'package:hyworth_land_survey/widgets/CommonAppBar.dart';
import 'package:provider/provider.dart';
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class ConsentListingScreen extends StatefulWidget {
  static const String route = "/consentListingScreen";
  const ConsentListingScreen({Key? key}) : super(key: key);

  @override
  State<ConsentListingScreen> createState() => _SurveyListingScreenState();
}

class _SurveyListingScreenState extends State<ConsentListingScreen>
    with SingleTickerProviderStateMixin,  RouteAware {
  TextEditingController _searchController = TextEditingController();

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
  // late TabController _tabController;

  // final List<SurveyModel> suveryListing = [
  //   SurveyModel(
  //       surveyId: "202509001",
  //       landState: "Maharashtra",
  //       landDistrict: "Mumbai",
  //       landVillage: "Goa",
  //       subStationCapacity: "10",
  //       landAreaInAcres: "20",
  //       subStationName: "Mame",
  //       landType: "Soil",
  //       landRateCommercialEscalation: "20"),
  //   SurveyModel(
  //       surveyId: "202509002",
  //       landState: "Maharashtra",
  //       landDistrict: "Mumbai",
  //       landVillage: "Goa",
  //       subStationCapacity: "10",
  //       landAreaInAcres: "20",
  //       subStationName: "Mame",
  //       landType: "Soil",
  //       landRateCommercialEscalation: "20"),
  // ];

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 2, vsync: this);
    getConsentSurveyData();
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

  Future<void> getConsentSurveyData() async {
    final surveyProvider = Provider.of<AppProvider>(context, listen: false);
  await surveyProvider.loadConsentSurveys();
   
  }
   @override
  void didPopNext() {
    context.read<AppProvider>().loadConsentSurveys();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.white,
      appBar: CommonAppBar(
        title: t(context, "consent_listing"),
        isbackVisible: false,
        islogout: true,
      ),
      body: 
       Consumer<AppProvider>(
          builder: (context, provider, child) {
    return provider.consentSurveys.length==0?
     Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        'assets/images/noland.svg',
        width: 150,
        height: 150,
      ),
      SizedBox(height: 20),
      Text(
        'No Consent Form Uploaded Yet',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      Text(
        'Start your first land survey by tapping the button below. Capture survey details, add files, and manage your land records easily.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      SizedBox(height: 20),
     
    ],
  ),
):
      Column(
        children: [
         
          // 🔹 Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(width: 8),
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
                // const SizedBox(width: 8),
                // GestureDetector(
                //   onTap: () {},
                //   child: SvgPicture.asset(
                //     CommonImagePath.filter,
                //     width: 30,
                //     height: 30,
                //     color: CommonColors.blue,
                //   ),
                // ),
              ],
            ),
          ),

          // 🔹 Tab content
          Expanded(
            child: 
             Consumer<AppProvider>(
              builder: (context, provider, _) {
                final filtered = _getFilteredConsentSurveys(provider.surveys);
             return 
             ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _getFilteredConsentSurveys(provider.consentSurveys).length,
      itemBuilder: (context, index) {
        final filtered = _getFilteredConsentSurveys(provider.consentSurveys);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildCard(index, filtered[index].surveyStatus!, filtered),
        );
      },
             );
            //  ListView.builder(
            //       padding: const EdgeInsets.all(12),
            //       itemCount: provider.consentSurveys.length,
            //       itemBuilder: (context, index) {
            //         return Padding(
            //           padding: const EdgeInsets.only(bottom: 12),
            //           child: _buildCard(index, provider.consentSurveys[index].surveyStatus!,provider.consentSurveys),
            //         );
            //       },
            //     );
              })
          
          ),
        ],
      );
    
  })
    );
  }
List<SurveyModel> _getFilteredConsentSurveys(List<SurveyModel> surveys) {
  final searchText = _searchController.text.trim().toLowerCase();

  if (searchText.isEmpty) return surveys;

  return surveys.where((s) {
    final surveyIdMatch = s.surveyId?.toLowerCase().contains(searchText) ?? false;
    final districtMatch = s.landDistrict?.toLowerCase().contains(searchText) ?? false;
    final villageMatch = s.landVillage?.toLowerCase().contains(searchText) ?? false;

    return surveyIdMatch || districtMatch || villageMatch;
  }).toList();
}

  Widget _buildCard(int index, String status,List<SurveyModel> consentSurveys) {
    print("calling survey card 1");
    return SurveyCard(
      surveyListing: consentSurveys,
      index: index,
      status: status,
      uploadconsent: consentSurveys[index].consentAvailable==1 ? true : false,
       selectedIndex: 2,
    );
  }
}
