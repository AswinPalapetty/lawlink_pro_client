import 'package:flutter/material.dart';
import 'package:data_filters/data_filters.dart';
import 'package:lawlink_client/widgets/client_home_scaffold.dart';
import 'package:lawlink_client/widgets/lawyers_card.dart';
import 'package:lawlink_client/widgets/progress_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Lawyers extends StatefulWidget {
  const Lawyers({Key? key}) : super(key: key);

  @override
  State<Lawyers> createState() => _LawyersState();
}

class _LawyersState extends State<Lawyers> {
  Color? iconColor = Colors.black;
  IconData? icon = Icons.thumb_up_alt_outlined;
  List<int>? filterIndex;
  late PostgrestList lawyers;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLawyers();
  }

  fetchLawyers() async {
    final fetchedLawyers = await Supabase.instance.client.from('lawyers').select();
    setState(() {
      lawyers = fetchedLawyers;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> titles = [
      'Education',
      'Practice Areas',
      'Name'
    ];

    return ClientHomeScaffold(
      child: Column(
        children: [
          DataFilters(
            data: lawyers.map((lawyer) {
              final education = lawyer['education'] is List
                  ? lawyer['education'][0].toString()
                  : lawyer['education'].toString();
              final practiceAreas = lawyer['practice_areas'] is List
                  ? lawyer['practice_areas'][0].toString()
                  : lawyer['practice_areas'].toString();
              return [education, practiceAreas, lawyer['name']];
            }).toList(),
            filterTitle: titles,
            showAnimation: true,
            recent_selected_data_index: (List<int>? index) {
              setState(() {
                filterIndex = index;
              });
            },
            style: FilterStyle(
              buttonColor: Colors.green,
              buttonColorText: Colors.white,
              filterBorderColor: Colors.grey,
            ),
          ),
          Expanded(
            child: isLoading
                ? const CustomProgressIndicator() // Show loading indicator while fetching lawyers
                : ListView.builder(
                    itemCount: lawyers.length,
                    itemBuilder: (ctx, i) {
                      if (filterIndex == null || filterIndex!.contains(i)) {
                        String aboutLawyer =
                            "Registration No: ${lawyers[i]['registration_no'] ?? ''}\n Education: ";
                        if (lawyers[i]['education'] != null) {
                          for (var education in lawyers[i]['education']) {
                            aboutLawyer += "$education\n";
                          }
                        }
                        return LawyersCard(
                          icon: icon,
                          iconColor: iconColor,
                          lawyerId: lawyers[i]['user_id'] ?? '',
                          lawyerName: lawyers[i]['name'] ?? '',
                          description: lawyers[i]['description'] ?? '',
                          courts: lawyers[i]['courts'] ?? '',
                          education: aboutLawyer,
                          experience: lawyers[i]['experience'] ?? '',
                          rating: lawyers[i]['rating'] != null ? lawyers[i]['rating'].toString() : '0',
                          callCharge: lawyers[i]['call_charge'] ?? '0',
                          courtCharge: lawyers[i]['sitting_charge'] ?? '0',
                          location: lawyers[i]['location'] ?? '',
                          onTap: () {
                            setState(() {
                              iconColor = iconColor == Colors.black
                                  ? const Color.fromARGB(255, 2, 130, 6)
                                  : Colors.black;
                              // ignore: unrelated_type_equality_checks
                              icon = icon == Icons.thumb_up_alt_outlined
                                  ? Icons.thumb_up_alt
                                  : Icons.thumb_up_alt_outlined;
                            });
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
