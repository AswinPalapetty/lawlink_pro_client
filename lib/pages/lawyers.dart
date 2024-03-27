import 'package:flutter/material.dart';
import 'package:data_filters/data_filters.dart';
import 'package:lawlink_client/widgets/client_home_scaffold.dart';
import 'package:lawlink_client/widgets/lawyers_card.dart';

class Lawyers extends StatefulWidget {
  const Lawyers({super.key});

  @override
  State<Lawyers> createState() => _LawyersState();
}

class _LawyersState extends State<Lawyers> {
  Color? iconColor = Colors.black;
  IconData? icon = Icons.thumb_up_alt_outlined;
  List<int>? filterIndex;

  @override
  Widget build(BuildContext context) {
    List<List> data = [
      ['pizza', 'italian', 'vegetarian', 'tomato', 'main course'],
      ['burger', 'american', 'non-vegetarian', 'beef', 'main course'],
      ['sushi', 'japanese', 'vegetarian', 'rice', 'appetizer'],
      ['pasta', 'italian', 'vegetarian', 'cream', 'main course'],
      ['taco', 'mexican', 'non-vegetarian', 'chicken', 'main course'],
      ['samosa', 'indian', 'vegetarian', 'potato', 'snack'],
      ['sushi', 'japanese', 'non-vegetarian', 'fish', 'appetizer'],
      ['noodles', 'chinese', 'vegetarian', 'soy sauce', 'main course'],
      ['samosa', 'indian', 'vegetarian', 'vegetables', 'snack'],
      ['burrito', 'mexican', 'non-vegetarian', 'pork', 'main course'],
      ['croissant', 'french', 'vegetarian', 'butter', 'breakfast'],
      ['gyro', 'greek', 'non-vegetarian', 'lamb', 'main course'],
      ['pasta', 'italian', 'vegetarian', 'tomato', 'main course'],
      ['sushi', 'japanese', 'vegetarian', 'avocado', 'appetizer'],
      ['burger', 'american', 'non-vegetarian', 'beef', 'main course'],
      ['taco', 'mexican', 'vegetarian', 'beans', 'main course'],
      ['pad thai', 'thai', 'vegetarian', 'peanuts', 'main course'],
      ['croissant', 'french', 'vegetarian', 'chocolate', 'breakfast'],
      ['samosa', 'indian', 'vegetarian', 'spices', 'snack'],
      ['pasta', 'italian', 'non-vegetarian', 'seafood', 'main course']
    ];
    List<String> titles = [
      'Food',
      'Cuisine',
      'Vegetarian',
      'Primary Ingredient',
      'Food Type'
    ];

    return ClientHomeScaffold(
      child: Column(
        children: [
          DataFilters(
            data: data,

            /// pass your filter title here
            filterTitle: titles,

            /// enable animation
            showAnimation: true,

            /// get list of index of selected filter
            recent_selected_data_index: (List<int>? index) {
              setState(() {
                filterIndex = index;
              });
            },

            /// styling
            style: FilterStyle(
              buttonColor: Colors.green,
              buttonColorText: Colors.white,
              filterBorderColor: Colors.grey,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (ctx, i) {
                if (filterIndex == null || filterIndex!.contains(i)) {
                  return LawyersCard(
                      icon: icon,
                      iconColor: iconColor,
                      lawyerName: data[i][0],
                      aboutLawyer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
                      courts: "Chavakkad munciff court",
                      education: "BA LLB, MA LLB",
                      experience: "15",
                      rating: "4.5",
                      callCharge: "300",
                      courtCharge: "10000",
                      city: "Thrissur",
                      state: "Kerala",
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
                      });
                  //return Text(data[i][0]);
                }
                return const SizedBox();
              },
            ),
          )
        ],
      ),
    );
  }
}
