import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/font/font_theme.dart';
import '../../features/driver_booking/presentation/bloc/bloc/location_selection_bloc.dart';
import '../../features/driver_booking/presentation/bloc/event/location_selection_event.dart';
import '../../features/driver_booking/presentation/bloc/state/location_selection_state.dart';

class LocationInputField extends StatefulWidget {
  final String label;
  final Function(String placeId, String description) onPlaceSelected;

  const LocationInputField(
      {super.key, required this.label, required this.onPlaceSelected});

  @override
  _LocationInputFieldState createState() => _LocationInputFieldState();
}

class _LocationInputFieldState extends State<LocationInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    // Listen to focus changes
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _showSuggestions = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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
              focusNode: _focusNode,
              style: AppFonts.bodyTextStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: AppFonts.body2TextSize,
              ),
              decoration: InputDecoration(
                hintText: widget.label,
                prefixIcon:
                    Icon(Icons.search, color: Theme.of(context).primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _showSuggestions = value.isNotEmpty;
                });
                bloc.add(FetchSuggestions(value));
              },
            ),
            if (_showSuggestions &&
                state is LocationSelectionLoaded &&
                state.suggestions.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: state.suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = state.suggestions[index];
                  return ListTile(
                    leading: Icon(Icons.place,
                        color: Theme.of(context).primaryColor),
                    title: Text(suggestion.description ?? ''),
                    onTap: () {
                      _controller.text = suggestion.description ?? '';
                      widget.onPlaceSelected(suggestion.placeId ?? '',
                          suggestion.description ?? '');
                      setState(() {
                        _showSuggestions = false;
                      });
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
