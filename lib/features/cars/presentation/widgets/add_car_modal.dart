import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vroo_test/shared/widgets/gradient_button.dart';
import '../../../../core/theme/color/color_theme.dart';
import '../../domain/entity/car.dart';
import '../bloc/bloc/car_bloc.dart';

class AddCarModal extends StatefulWidget {
  final Function(CarEntity) onCarAdded;
  final CarBloc carBloc;

  const AddCarModal({
    super.key,
    required this.onCarAdded,
    required this.carBloc,
  });

  @override
  _AddCarModalState createState() => _AddCarModalState();
}

class _AddCarModalState extends State<AddCarModal> {
  final _formKey = GlobalKey<FormState>();
  
  // Define car companies for Pakistan
  final List<String> _carCompanies = [
    'Honda', 'Toyota', 'Suzuki', 'Kia', 'Hyundai', 'Changan', 'Daihatsu', 'Nissan', 'MG', 'Proton', 'Peugeot', 'Chevrolet', 'Other'
  ];
  
  // Maps for car models by company
  final Map<String, List<String>> _carModelsByCompany = {
    'Honda': ['Civic', 'City', 'Accord', 'BR-V', 'HR-V', 'CR-V', 'Fit', 'Vezel', 'Insight', 'Grace', 'Other'],
    'Toyota': ['Corolla', 'Yaris', 'Vitz', 'Prius', 'Prado', 'Fortuner', 'Land Cruiser', 'Aqua', 'Camry', 'Hiace', 'Hilux', 'Other'],
    'Suzuki': ['Mehran', 'Alto', 'Cultus', 'Wagon R', 'Swift', 'Ciaz', 'Vitara', 'Bolan', 'Carry', 'Liana', 'Other'],
    'Kia': ['Sportage', 'Picanto', 'Sorento', 'Stonic', 'Grand Carnival', 'Carens', 'Forte', 'Seltos', 'Other'],
    'Hyundai': ['Tucson', 'Elantra', 'Sonata', 'Santa Fe', 'Porter', 'Starex', 'Creta', 'Other'],
    'Changan': ['Alsvin', 'Karvaan', 'Oshan X7', 'Shepa Pickup','M8', 'M9', 'Carrier', 'Other'],
    'Daihatsu': ['Mira','Cuore', 'Charade', 'Terios', 'Rocky', 'Other'],
    'Nissan': ['Sunny', 'Patrol', 'X-Trail', 'Navara', 'Teana', 'Leaf', 'Qashqai', 'Other'],
    'MG': ['ZS', 'HS', 'MG3', 'MG6', 'Other'],
    'Proton': ['Saga', 'X70', 'X50', 'Other'],
    'Peugeot': ['208', '3008', '5008', 'Other'],
    'Chevrolet': ['Sail', 'Tracker', 'Other'],
    'Other': ['Other'],
  };
  
  // Define popular car colors
  final List<String> _carColors = [
    // popular colors in Pakistan
    'White', 'Black', 'Grey', 'Silver', 'Red', 'Blue', 'Beige', 'Brown', 'Green', 'Cyan', 'Maroon', 'Turquoise', 'Teal', 'Lavender', 'Peach', 'Coral', 'Navy Blue', 'Olive', 'Mint Green', 'Mustard', 'Cream', 'Burgundy', 'Tan', 'Charcoal', 'Magenta', 'Indigo', 'Copper', 'Bronze', 'Yellow', 'Orange', 'Purple', 'Pink', 'Gold', 'Violet',    // other colors
    'Other',

  ];
  
  String _selectedCompany = 'Honda';
  String? _selectedModel;
  String _selectedColor = 'White';
  
  // Controllers for number plate - 3 characters, separator, 3 numbers
  List<TextEditingController> _plateControllers = List.generate(6, (_) => TextEditingController());
  final TextEditingController _mileageController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _selectedModel = _carModelsByCompany[_selectedCompany]?.first;
  }

  @override
  void dispose() {
    for (var controller in _plateControllers) {
      controller.dispose();
    }
    _mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.w,
        right: 16.w,
        top: 16.w,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add New Car',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: ThemeColors.buttonTextColor,
                  ),
            ),
            SizedBox(height: 24.h),
            
            // Company dropdown
            _buildDropdownField(
              label: 'Company',
              selectedValue: _selectedCompany,
              items: _carCompanies,
              onChanged: (value) {
                setState(() {
                  _selectedCompany = value!;
                  // Reset model when company changes
                  _selectedModel = _carModelsByCompany[_selectedCompany]?.first;
                });
              },
            ),
            
            // Model dropdown (dependent on company)
            _buildDropdownField(
              label: 'Model',
              selectedValue: _selectedModel ?? '',
              items: _carModelsByCompany[_selectedCompany] ?? ['Other'],
              onChanged: (value) {
                setState(() {
                  _selectedModel = value;
                });
              },
            ),
            
            // Color dropdown
            _buildDropdownField(
              label: 'Color',
              selectedValue: _selectedColor,
              items: _carColors,
              onChanged: (value) {
                setState(() {
                  _selectedColor = value!;
                });
              },
            ),
            
            // Number plate
            _buildNumberPlateField(),
            
            // Mileage field (float)
            _buildMileageField(),
            
            SizedBox(height: 24.h),
            GradientButton(onTap: _handleSubmit, text: "Add New Car"),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
  
Widget _buildDropdownField({
  required String label,
  required String selectedValue,
  required List<String> items,
  required void Function(String?) onChanged,
}) {
  // Check if "Other" is selected to show the text input field
  final bool isOtherSelected = !items.contains(selectedValue) || 
                             selectedValue == 'Other';
  
  // Controller for the "Other" text field
  final TextEditingController otherController = TextEditingController(
    text: isOtherSelected && selectedValue != 'Other' ? selectedValue : ''
  );
  
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ThemeColors.cardColor,
              ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: ThemeColors.dividerColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Material(
              color: Colors.transparent,
              child: PopupMenuButton<String>(
                initialValue: items.contains(selectedValue) ? selectedValue : 'Other',
                onSelected: (value) {
                  if (value == 'Other') {
                    // Just set to "Other" and let the text field handle the actual value
                    onChanged('Other');
                  } else {
                    // For regular selections
                    onChanged(value);
                  }
                },
                itemBuilder: (context) => items.map((item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                offset: Offset(0, 40.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: ThemeColors.cardColor,
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 32.w,
                  maxWidth: MediaQuery.of(context).size.width - 32.w,
                  maxHeight: 250.h,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        items.contains(selectedValue) ? selectedValue : 'Other',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: ThemeColors.backgroundColor,
                            ),
                      ),
                      Row(
                        children: [
                          if (items.length > 5)
                            Icon(
                              Icons.more_vert,
                              color: ThemeColors.buttonTextColor.withOpacity(0.5),
                              size: 16,
                            ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.arrow_drop_down,
                            color: ThemeColors.buttonTextColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        
        // Show text field only when "Other" is selected
        if (isOtherSelected)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: TextFormField(
              controller: otherController,
              onChanged: (value) {
                // Pass the custom value back up
                if (value.isNotEmpty) {
                  onChanged(value);
                }
              },
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ThemeColors.buttonTextColor,
                  ),
              decoration: InputDecoration(
                hintText: 'Enter custom ${label.toLowerCase()}',
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: ThemeColors.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: ThemeColors.primaryColor,
                    width: 2.0,
                  ),
                ),
              ),
              validator: (value) {
                if (isOtherSelected && (value == null || value.isEmpty)) {
                  return 'Please enter a custom ${label.toLowerCase()}';
                }
                return null;
              },
            ),
          ),
      ],
    ),
  );
}
  Widget _buildNumberPlateField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'License Plate',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.cardColor,
                ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              // First 3 characters
              ...List.generate(3, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: TextFormField(
                      controller: _plateControllers[index],
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 2) {
                          // Move to next field when filled
                          FocusScope.of(context).nextFocus();
                        } else if (value.isNotEmpty && index == 2) {
                          // Skip the hyphen field and move to the next input field
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                        UpperCaseTextFormatter(),
                      ],
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: ThemeColors.buttonTextColor,
                          ),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: ThemeColors.dividerColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: ThemeColors.primaryColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              
              // Separator
              Container(
                width: 24.w,
                height: 48.h,
                alignment: Alignment.center,
                child: Text(
                  '-',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.buttonTextColor,
                  ),
                ),
              ),
              
              // Last 3 characters
              ...List.generate(3, (index) {
                final actualIndex = index + 3;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: TextFormField(
                      controller: _plateControllers[actualIndex],
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.isNotEmpty && actualIndex < 5) {
                          // Move to next field when filled
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                        UpperCaseTextFormatter(),
                      ],
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: ThemeColors.buttonTextColor,
                          ),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: ThemeColors.dividerColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                            color: ThemeColors.primaryColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMileageField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mileage (km/l)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.cardColor,
                ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _mileageController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ThemeColors.buttonTextColor,
                ),
            decoration: InputDecoration(
              hintText: '0.00',
              hintStyle: TextStyle(color: ThemeColors.buttonTextColor.withOpacity(0.5)),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: ThemeColors.dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: ThemeColors.primaryColor,
                  width: 2.0,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter mileage';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Combine plate controllers into a single string with hyphen
      final firstPart = _plateControllers.sublist(0, 3).map((controller) => controller.text).join('');
      final secondPart = _plateControllers.sublist(3, 6).map((controller) => controller.text).join('');
      final numberPlate = "$firstPart-$secondPart";
      
      final newCar = CarEntity(
        carId: '', // Assuming carId is generated by the backend or database
        company: _selectedCompany,
        model: _selectedModel ?? 'Other',
        color: _selectedColor,
        numberPlate: numberPlate,
        mileage: double.tryParse(_mileageController.text) ?? 0.0,
        isVerified: false,
      );

      widget.onCarAdded(newCar);
      Navigator.pop(context);
    }
  }
}

// Custom formatter to convert text to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
