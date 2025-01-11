import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/driver_booking/presentation/bloc/location_selection_bloc.dart';
import '../../features/driver_booking/presentation/bloc/location_selection_event.dart';
import '../../features/driver_booking/presentation/bloc/location_selection_state.dart';

class LocationInputField extends StatefulWidget {
  final String label;
  final Function(String placeId, String description) onPlaceSelected;

  const LocationInputField({
    required this.label,
    required this.onPlaceSelected,
  });

  @override
  _LocationInputFieldState createState() => _LocationInputFieldState();
}

class _LocationInputFieldState extends State<LocationInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationSelectionBloc, LocationSelectionState>(
      builder: (context, state) {
        final bloc = context.read<LocationSelectionBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.label,
                prefixIcon: const Icon(Icons.search, color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.orange),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.orange),
                ),
              ),
              onChanged: (value) {
                bloc.add(FetchSuggestions(value));
              },
            ),
            if (state is LocationSelectionLoading)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (state is LocationSelectionLoaded && state.suggestions.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: state.suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = state.suggestions[index];
                  return ListTile(
                    leading: const Icon(Icons.place, color: Colors.orange),
                    title: Text(suggestion.description?? ''),
                    onTap: () {
                      // Update the TextField with the selected location description
                      _controller.text = suggestion.description?? '';

                      // Save the selected location
                      widget.onPlaceSelected(
                        suggestion.placeId ?? '',
                        suggestion.description?? '',
                      );

                      // Clear suggestions
                      bloc.add(FetchSuggestions(''));
                    },
                  );
                },
              ),
          ],
        );
      },
    );
  }
}


// class LocationInputField extends StatefulWidget {
//   final String label;
//   final Function(String placeId, String description) onPlaceSelected;

//   const LocationInputField({
//     required this.label,
//     required this.onPlaceSelected,
//   });

//   @override
//   _LocationInputFieldState createState() => _LocationInputFieldState();
// }

// class _LocationInputFieldState extends State<LocationInputField> {
//   late TextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LocationSelectionBloc, LocationSelectionState>(
//       builder: (context, state) {
//         final bloc = context.read<LocationSelectionBloc>();

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(labelText: widget.label),
//               onChanged: (value) {
//                 bloc.add(FetchSuggestions(value));
//               },
//             ),
//             if (state is LocationSelectionLoading) ...[
//               const LinearProgressIndicator(),
//             ] else if (state is LocationSelectionLoaded) ...[
//               ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: state.suggestions.length,
//                 itemBuilder: (context, index) {
//                   final suggestion = state.suggestions[index];
//                   return ListTile(
//                     title: Text(suggestion.description ?? ''),
//                     onTap: () {
//                       // Update the TextField with the selected location description
//                       _controller.text = suggestion.description?? '';

//                       // Save the selected location
//                       widget.onPlaceSelected(
//                         suggestion.placeId?? '',
//                         suggestion.description?? '',
//                       );

//                       // Clear suggestions
//                       bloc.add(FetchSuggestions(''));
//                     },
//                   );
//                 },
//               ),
//             ],
//           ],
//         );
//       },
//     );
//   }
// }

