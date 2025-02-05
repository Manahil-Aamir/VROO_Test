import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class D1Screen extends StatelessWidget {
  final String toPlaceID;
  final String fromPlaceID;
  final String toDescription;
  final String fromDescription;
  final List<dynamic> selectedRouteCoords;

  D1Screen({
    super.key,
    required this.toPlaceID,
    required this.fromPlaceID,
    required this.toDescription,
    required this.fromDescription,
    required this.selectedRouteCoords,
  })  : sourceCoord = LatLng(selectedRouteCoords.first[0], selectedRouteCoords.first[1]),
        destinationCoord = LatLng(selectedRouteCoords.last[0], selectedRouteCoords.last[1]);

  final LatLng sourceCoord;
  final LatLng destinationCoord;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('D1 Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To Place ID: $toPlaceID',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'From Place ID: $fromPlaceID',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'To Description: $toDescription',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'From Description: $fromDescription',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Source Coordinate: $sourceCoord',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Destination Coordinate: $destinationCoord',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}


  
  // Widget _buildCarSelection() {
  //   return Card(
  //     color: ThemeColors.backgroundColor,
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(16.w),
  //     ),
  //     child: Padding(
  //       padding: EdgeInsets.all(16.w),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(Icons.directions_car, color: ThemeColors.primaryColor, size: 24.w),
  //               SizedBox(width: 8.w),
  //               Text(
  //                 'Select Vehicle',
  //                 style: AppFonts.bodyTextStyle.copyWith(
  //                   fontSize: AppFonts.body1TextSize,
  //                   color: ThemeColors.headlinesTextColor,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 16.h),
  //           BlocBuilder<CarBloc, CarState>(
  //             builder: (context, carState) {
  //               return BlocBuilder<CarPreferencesBloc, CarPreferencesState>(
  //                 builder: (context, prefState) {
  //                   if (carState is CarInitial || carState is CarLoading || prefState is CarPreferencesInitial || prefState is CarPreferencesLoading) {
  //                     return Center(
  //                       child: CircularProgressIndicator(
  //                         color: ThemeColors.progressIndicatorColor,
  //                       ),
  //                     );
  //                   }
  //                   if (carState is CarError) {
  //                     print('Error loading cars: ${carState.message}');
  //                     return Text(
  //                       'Please try again later',
  //                       style: AppFonts.bodyTextStyle.copyWith(
  //                         color: ThemeColors.accentColor,
  //                         fontSize: AppFonts.body2TextSize,
  //                       ),
  //                     );
  //                   }
  //                   if (carState is CarLoaded) {
  //                     return Row(
  //                       children: [
  //                         Expanded(
  //                           child: Container(
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(12.w),
  //                               border: Border.all(
  //                                 color: ThemeColors.primaryColorLight.withOpacity(0.3),
  //                                 width: 1.5,
  //                               ),
  //                             ),
  //                             child: DropdownButtonFormField<String>(
  //                               isExpanded: true,
  //                               value: _selectedCarId,
  //                               dropdownColor: ThemeColors.canvasColor,
  //                               menuMaxHeight: 300.h,
  //                               style: AppFonts.bodyTextStyle.copyWith(
  //                                 fontSize: AppFonts.body1TextSize,
  //                                 color: ThemeColors.headlinesTextColor,
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                               borderRadius: BorderRadius.circular(12.w),
  //                               elevation: 6,
  //                               decoration: InputDecoration(
  //                                 filled: true,
  //                                 fillColor: Colors.transparent,
  //                                 border: InputBorder.none,
  //                                 contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
  //                                 hintText: 'Choose your vehicle',
  //                                 hintStyle: AppFonts.bodyTextStyle.copyWith(
  //                                   color: ThemeColors.hintTextColor,
  //                                 ),
  //                               ),
  //                               selectedItemBuilder: (BuildContext context) {
  //                                 return carState.cars.map<Widget>((CarEntity car) {
  //                                   return Text('${car.company} ${car.model}');
  //                                 }).toList();
  //                               },
  //                               items: carState.cars.map((car) {
  //                                 return DropdownMenuItem<String>(
  //                                   value: car.numberPlate,
  //                                   child: Row(
  //                                     children: [
  //                                       Icon(Icons.directions_car, color: ThemeColors.primaryColor),
  //                                       SizedBox(width: 12.w),
  //                                       Text('${car.company} ${car.model}'),
  //                                     ],
  //                                   ),
  //                                 );
  //                               }).toList(),
  //                               onChanged: (value) => _updateCarPreference(value),
  //                               icon: Icon(Icons.arrow_drop_down, color: ThemeColors.primaryColor),
  //                             ),    
  //                           ),
  //                         ),
  //                         SizedBox(width: 12.w),
  //                         _buildAddCarButton(),
  //                       ],
  //                     );
  //                   }
  //                   return const SizedBox.shrink();
  //                 },
  //               );
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildAddCarButton() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [
  //           ThemeColors.primaryColor.withOpacity(0.7),
  //           // ThemeColors.primaryColor,
  //           ThemeColors.primaryColor.withOpacity(0.7),
  //         ],
  //       ),
  //       borderRadius: BorderRadius.circular(12.w),
  //       boxShadow: [
  //         BoxShadow(
  //           color: ThemeColors.primaryColor.withOpacity(0.2),
  //           blurRadius: 8,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Material(
  //       color: Colors.transparent,
  //       child: InkWell(
  //         borderRadius: BorderRadius.circular(12.w),
  //         onTap: _showAddCarModal,
  //         child: Container(
  //           width: 48.w,
  //           height: 48.w,
  //           padding: EdgeInsets.all(12.w),
  //           child: Icon(Icons.add, color: Colors.white, size: 24.w),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildPaymentMethod() {
  //   return Card(
  //     color: ThemeColors.backgroundColor,
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(16.w),
  //     ),
  //     child: Padding(
  //       padding: EdgeInsets.all(16.w),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(Icons.payment, color: ThemeColors.primaryColor, size: 24.w),
  //               SizedBox(width: 8.w),
  //               Text(
  //                 'Payment Method',
  //                 style: AppFonts.bodyTextStyle.copyWith(
  //                   fontSize: AppFonts.body1TextSize,
  //                   color: ThemeColors.headlinesTextColor,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 16.h),
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: _buildPaymentOption(
  //                   title: 'Cash',
  //                   isSelected: _selectedPaymentMethod == 'cash',
  //                   onTap: () => _updatePayment('cash'),
  //                 ),
  //               ),
  //               SizedBox(width: 16.w),
  //               Expanded(
  //                 child: _buildPaymentOption(
  //                   title: 'Free',
  //                   isSelected: _selectedPaymentMethod == 'free',
  //                   onTap: () => _updatePayment('free'),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildPaymentOption({
  //   required String title,
  //   required bool isSelected,
  //   required VoidCallback onTap,
  // }) {
  //   return InkWell(
  //     onTap: onTap,
  //     borderRadius: BorderRadius.circular(12.w),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
  //       decoration: BoxDecoration(
  //         color: isSelected ? ThemeColors.primaryColor.withOpacity(0.1) : Colors.transparent,
  //         borderRadius: BorderRadius.circular(12.w),
  //         border: Border.all(
  //           color: isSelected ? ThemeColors.primaryColor : ThemeColors.primaryColorLight.withOpacity(0.3),
  //           width: 1.5,
  //         ),
  //       ),
  //       child: Center(
  //         child: Text(
  //           title,
  //           style: AppFonts.bodyTextStyle.copyWith(
  //             color: ThemeColors.headlinesTextColor,
  //             // color: isSelected ? ThemeColors.primaryColor : ThemeColors.headlinesTextColor,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }




  // _showAddCarModal() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: const Color(0xFF2C2C2C),
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
  //     ),
  //     builder: (context) {
  //       final TextEditingController carCompanyController = TextEditingController();
  //       final TextEditingController carModelController = TextEditingController();
  //       final TextEditingController carColorController = TextEditingController();
  //       final TextEditingController carNumberPlateController = TextEditingController();
  //       final TextEditingController carMileageController = TextEditingController();
  //       return SingleChildScrollView(
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Text(
  //                 'Add Car',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               _buildCarInputField(carCompanyController, 'Car Company'),
  //               _buildCarInputField(carModelController, 'Car Model'),
  //               _buildCarInputField(carColorController, 'Car Color'),
  //               _buildCarInputField(carNumberPlateController, 'Car Number Plate'),
  //               _buildCarInputField(
  //                 carMileageController,
  //                 'Car Mileage',
  //                 keyboardType: TextInputType.number, 
  //                 inputFormatters: [FilteringTextInputFormatter.digitsOnly], 
  //               ),
  //               const SizedBox(height: 16),
  //               SizedBox(
  //                 height: 50,
  //                 width: double.infinity,
  //                 child: GradientButton(
  //                   onTap: () {
  //                     final car = CarEntity(
  //                       company: carCompanyController.text,
  //                       model: carModelController.text,
  //                       color: carColorController.text,
  //                       numberPlate: carNumberPlateController.text,
  //                       mileage: double.tryParse(carMileageController.text) ?? 0.0,
  //                       isVerified: false,
  //                     );
  //                     BlocProvider.of<CarBloc>(context).add(AddCar(car));
  //                     Navigator.pop(context);
  //                   },
  //                   text: 'Add Car',
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildCarInputField(
  //   TextEditingController controller, 
  //   String label, {
  //   TextInputType keyboardType = TextInputType.text,
  //   List<TextInputFormatter>? inputFormatters,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: TextFormField(
  //       controller: controller,
  //       keyboardType: keyboardType,
  //       inputFormatters: inputFormatters,
  //       style: const TextStyle(color: Colors.white),
  //       decoration: InputDecoration(
  //         labelText: label,
  //         labelStyle: const TextStyle(color: Colors.white),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(8.0),
  //           borderSide: const BorderSide(
  //             color: Color(0xFFEC8825),
  //             width: 2.0,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

// Widget _buildDetailCard({required String title, required List<Widget> details}) {
  //   return Card(
  //     color: ThemeColors.backgroundColor,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(16.0),
  //     ),
  //     elevation: 4,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             title,
  //             style: const TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.grey,
  //             ),
  //           ),
  //           const SizedBox(height: 8),
  //           Column(children: details),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDetailTile(IconData icon, String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       children: [
  //         Icon(icon, color: const Color(0xFFEC8825)),
  //         const SizedBox(width: 16),
  //         Expanded(
  //           child: Text(
  //             label,
  //             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //         Expanded(
  //           child: Text(
  //             value,
  //             style: const TextStyle(fontSize: 16),
  //             overflow: TextOverflow.ellipsis,
  //             maxLines: 1,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildExpandableDetailTile(
  //   BuildContext context, IconData icon, String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       children: [
  //         Icon(icon, color: const Color(0xFFEC8825)),
  //         const SizedBox(width: 16),
  //         Expanded(
  //           child: Text(
  //             label,
  //             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //         Expanded(
  //           child: GestureDetector(
  //             onTap: () => _showDetailBottomSheet(context, label, value),
  //             child: Text(
  //               value,
  //               style: const TextStyle(fontSize: 16),
  //               overflow: TextOverflow.ellipsis,
  //               maxLines: 1,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
