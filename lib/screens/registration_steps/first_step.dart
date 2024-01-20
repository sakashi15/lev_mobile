import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:iconly/iconly.dart';
import 'package:lev_mobile/models/company_model.dart';
import 'package:lev_mobile/network/my_http_client.dart';
import 'package:lev_mobile/services/company_service.dart';
import 'package:lev_mobile/styling/colors.dart';
import 'package:lev_mobile/styling/theme.dart';
import 'package:lev_mobile/widgets/form_field.dart';
import 'package:lev_mobile/widgets/my_network_image.dart';

class InformationStep extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  int? selectedValue;
  String? selectedValueString;
  List<Company> companies;
  dynamic onCompanySelected;

  InformationStep({
    Key? key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.selectedValue,
    required this.selectedValueString,
    required this.companies,
    required this.onCompanySelected,
  }) : super(key: key);

  @override
  State<InformationStep> createState() => _InformationStepState();
}

class _InformationStepState extends State<InformationStep> {

  bool throwError = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CustomFormField(
                  hintText: "Nom",
                  icon: IconlyLight.profile,
                  controller: widget.firstNameController,
                  type: CustomFormFieldTypes.text,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: CustomFormField(
                  hintText: "Prénom",
                  icon: IconlyLight.profile,
                  controller: widget.lastNameController,
                  type: CustomFormFieldTypes.text,
                ),
              ),
            ],
          ),
          CustomFormField(
            hintText: "Téléphone",
            icon: IconlyLight.call,
            controller: widget.phoneController,
            type: CustomFormFieldTypes.text,
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              iconStyleData: IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Color(0xffB3B3B3),
                ),
              ),
              value: widget.selectedValueString,
              hint: Padding(
                padding:
                const EdgeInsets.only(left: 12.0),
                child: Row(
                  children: [
                    Icon(IconlyLight.home, color: AppColors.darkBlue.withOpacity(0.3),),
                    SizedBox(width: 18),
                    Text(
                      "Entreprise",
                      style: TextStyle(
                          fontFamily: fontName,
                          fontSize: 15,
                          color: AppColors.darkBlue.withOpacity(0.3)
                      ),
                    ),
                  ],
                ),
              ),
              selectedItemBuilder: (context) {
                return widget.companies.map((item) {
                    return Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          if(item.logo != null && item.logo!.isNotEmpty)
                            ClipRRect(
                                child: MyNetworkImage(
                                  url: MyHttpClient.root + item.logo!,
                                  height: 20,
                                  width: 20,
                                ),
                              borderRadius: BorderRadius.circular(12),
                            )
                          else
                            Icon(IconlyLight.home, color: AppColors.darkBlue.withOpacity(0.3),),
                          SizedBox(width: 18),
                          Text(
                            item.name!,
                            style: TextStyle(
                              fontFamily: fontName,
                              fontSize: 14,
                            )
                          ),
                        ],
                      ),
                    );
                  },
                ).toList();
              },
              items: widget.companies
                  .map(
                    (item) => DropdownMenuItem<String>(
                  value: item.name,
                  child: Row(
                    children: [
                      Row(
                        children: [
                          if(item.logo != null && item.logo!.isNotEmpty)
                            ClipRRect(
                              child: MyNetworkImage(
                                url: MyHttpClient.root + item.logo!,
                                height: 20,
                                width: 20,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          if(item.logo != null && item.logo!.isNotEmpty)
                          SizedBox(width: 18),
                          Text(
                            item.name!,
                            style: TextStyle(
                              color: widget.selectedValue == item.id ? Colors.black : Color(0xFF8A8A8A),
                              fontFamily: fontName,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      (widget.selectedValue == item.id)
                          ? Icon(
                          Icons.verified_rounded, color: AppColors.darkBlue.withOpacity(0.3))
                          : SizedBox.shrink()
                    ],
                  ),
                ),
              ).toList(),
              onChanged: widget.onCompanySelected,
              buttonStyleData: ButtonStyleData(
                height: 50,
                elevation: 0,
                padding: EdgeInsets.only(right: 12, left: 6),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(12)),
                  border: Border.all(
                      color: Color(0xFFEDEDF3),
                      width: 1.0,
                      style: BorderStyle.solid),
                  color: Color(0xFFF8F7F7),
                ),
              ),
              isDense: true,
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(12)),
                ),
              ),
              dropdownSearchData: DropdownSearchData(
                searchController: textEditingController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Container(
                  height: 50,
                  padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    controller: textEditingController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                      const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8),
                      hintText: "Chercher...",
                      hintStyle:
                      const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return item.value
                      .toString()
                      .contains(searchValue);
                },
              ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  textEditingController.clear();
                }
              },
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }


}
