import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/theme/font/font_theme.dart';
import '../../domain/entity/prediction.dart';
import '../bloc/bloc/location_selection_bloc.dart';
import '../bloc/event/location_selection_event.dart';
import '../bloc/state/location_selection_state.dart';

class LocationInputField extends StatefulWidget {
  final String label;
  final String? initialValue;
  final Function(String, String, LatLng) onPlaceSelected;
  final TextEditingController? controller; // Add controller parameter
  final FocusNode? focusNode; // Add focus node parameter

  const LocationInputField({
    super.key,
    required this.label,
    this.initialValue,
    required this.onPlaceSelected,
    this.controller, // Make optional
    this.focusNode, // Make optional
  });

  @override
  State<LocationInputField> createState() => _LocationInputFieldState();
}

class _LocationInputFieldState extends State<LocationInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    // Use provided controller or create a new one
    _controller = widget.controller ?? TextEditingController();
    // Use provided focus node or create a new one
    _focusNode = widget.focusNode ?? FocusNode();

    // Set initial value if provided and controller doesn't already have text
    if (widget.initialValue != null && _controller.text.isEmpty) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void didUpdateWidget(LocationInputField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controller if external one is provided and different
    if (widget.controller != null && widget.controller != _controller) {
      _controller.dispose();
      _controller = widget.controller!;
    }

    // Update focus node if external one is provided and different
    if (widget.focusNode != null && widget.focusNode != _focusNode) {
      _focusNode.dispose();
      _focusNode = widget.focusNode!;
    }

    // Update text if initialValue changed and we're not using an external controller
    if (widget.initialValue != oldWidget.initialValue &&
        widget.controller == null &&
        widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    // Only dispose controller and focus node if we created them
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationSelectionBloc, LocationSelectionState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              cursorColor: theme.primaryColor,
              style: AppFonts.bodyTextStyle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: AppFonts.body2TextSize,
              ),
              decoration: InputDecoration(
                hintText: widget.label,
                prefixIcon: Icon(Icons.search, color: theme.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: theme.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: theme.primaryColor),
                ),
              ),
              onChanged: (value) {
                setState(() => _showSuggestions = value.isNotEmpty);
                context
                    .read<LocationSelectionBloc>()
                    .add(FetchSuggestionsEvent(value));
              },
            ),
            if (_showSuggestions) _buildSuggestionsList(state, theme),
          ],
        );
      },
    );
  }

  Widget _buildSuggestionsList(LocationSelectionState state, ThemeData theme) {
    if (state is LocationSelectionLoading) {
      return _buildLoadingIndicator(theme);
    } else if (state is LocationSelectionLoaded) {
      return _buildSuggestionsListItems(state);
    } else if (state is LocationSelectionError) {
      return _buildErrorWidget(state);
    }
    return const SizedBox.shrink();
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CircularProgressIndicator(color: theme.primaryColor),
      ),
    );
  }

  Widget _buildSuggestionsListItems(LocationSelectionLoaded state) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: state.predictions.length,
      itemBuilder: (context, index) {
        final suggestion = state.predictions[index];
        return ListTile(
          leading: Icon(Icons.place, color: Theme.of(context).primaryColor),
          title: Text(suggestion.description),
          onTap: () => _handleSuggestionTap(suggestion),
        );
      },
    );
  }

  Widget _buildErrorWidget(LocationSelectionError state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(state.message, style: const TextStyle(color: Colors.red)),
    );
  }

  Future<void> _handleSuggestionTap(Prediction suggestion) async {
    _controller.text = suggestion.description;

    // Get the position for the selected place
    final position = await _getPlacePosition(suggestion.placeId);

    widget.onPlaceSelected(
        suggestion.placeId, suggestion.description, position);
    setState(() => _showSuggestions = false);
    context.read<LocationSelectionBloc>().add(const FetchSuggestionsEvent(''));
  }

  Future<LatLng> _getPlacePosition(String placeId) async {
    // Implement your logic to get LatLng from placeId
    // This might involve calling Google Places API or your backend
    // For now returning a default position
    return const LatLng(0, 0);
  }
}
