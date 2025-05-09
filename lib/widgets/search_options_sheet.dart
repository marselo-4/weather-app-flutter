import 'package:flutter/material.dart';

class SearchOptionsSheet extends StatelessWidget {
  final VoidCallback onCurrentLocationSelected;
  final VoidCallback onCountryCitySelected;
  final VoidCallback onCitySearchSelected;
  final VoidCallback onCoordinateSearchSelected;

  const SearchOptionsSheet({
    super.key,
    required this.onCurrentLocationSelected,
    required this.onCountryCitySelected,
    required this.onCitySearchSelected,
    required this.onCoordinateSearchSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.my_location),
            title: const Text('Current Location'),
            onTap: () {
              Navigator.pop(context);
              onCurrentLocationSelected();
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Select Country & City'),
            onTap: () {
              Navigator.pop(context);
              onCountryCitySelected();
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search by Name'),
            onTap: () {
              Navigator.pop(context);
              onCitySearchSelected();
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Search by Coordinates'),
            onTap: () {
              Navigator.pop(context);
              onCoordinateSearchSelected();
            },
          ),
        ],
      ),
    );
  }
}
