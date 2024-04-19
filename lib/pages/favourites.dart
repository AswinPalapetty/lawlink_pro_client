import 'package:flutter/material.dart';
import 'package:lawlink_client/utils/session.dart';
import 'package:lawlink_client/widgets/client_home_scaffold.dart';
import 'package:lawlink_client/widgets/favourite_lawyer_card.dart';
import 'package:lawlink_client/widgets/progress_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  bool isLoading = true;
  late Map<String, String> user;
  late List<Map<String, dynamic>> favoriteLawyers = [];
  @override
  void initState() {
    super.initState();
    fetchFavourites();
  }

  fetchFavourites() async {
    user = await SessionManagement.getUserData();
    final result = await Supabase.instance.client.from('favourites').select('lawyers').eq('client_id', user['userId']!).order('created_at', ascending: false);
    List<String> userIds = List<String>.from(result[0]['lawyers']);
    for (var userId in userIds) {
      final lawyer = await Supabase.instance.client.from('lawyers').select().eq('user_id', userId).single();
      lawyer['practice_areas'] = lawyer['practice_areas'].join(',');
      favoriteLawyers.add(lawyer);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClientHomeScaffold(
      child: isLoading ? const CustomProgressIndicator()
          : ListView.builder(
              itemCount: favoriteLawyers.length,
              itemBuilder: (context, index) {
                final data = favoriteLawyers[index];
                return FavouriteLawyerCard(
                  imageUrl: data['image'] ?? '', // Replace 'imageUrl' with the actual field name
                  practiceAreas: data['practice_areas'] ?? '', // Replace 'practiceAreas' with the actual field name
                  name: data['name'] ?? '', // Replace 'name' with the actual field name
                  onTap: () {
                    Navigator.pushNamed(context, "/view_lawyer", arguments: data['user_id']);
                  },
                );
              },
            ),
    );
  }
}