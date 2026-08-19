import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdoom/controllers/user_controller.dart';
import 'package:hdoom/models/aesthetic_model.dart';
import 'package:hdoom/services/redirect_service.dart';
import 'package:hdoom/utils/app_colors.dart';
import 'package:hdoom/utils/app_texts.dart';
import 'package:hdoom/utils/custom_snackbar.dart';
import 'package:hdoom/utils/custom_svg.dart';
import 'package:hdoom/views/widgets/custom_app_bar.dart';
import 'package:hdoom/views/widgets/custom_button.dart';
import 'package:hdoom/views/widgets/custom_drop_down.dart';
import 'package:hdoom/views/widgets/custom_loading.dart';
import 'package:hdoom/views/widgets/custom_networked_image.dart';
import 'package:hdoom/views/widgets/custom_text_field.dart';
import 'package:hdoom/views/widgets/profile_picture.dart';

class EditProfile extends StatefulWidget {
  final bool createAccount;
  const EditProfile({super.key, this.createAccount = false});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final userController = Get.find<UserController>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final countryController = TextEditingController();

  List<int> selectedAesthetics = [];
  File? _pickedImage;

  String? selectedGender;
  String? selectedBodyType;

  final List<String> genderValues = const ['male', 'female', 'other'];
  final List<String> bodyTypeValues = const [
    'slim',
    'athletic',
    'average',
    'curvy',
    'plus_size',
  ];

  List<String> get genderDisplayOptions => [
        "male".tr,
        "female".tr,
      ];

  List<String> get bodyTypeDisplayOptions => [
        "slim".tr,
        "athletic".tr,
        "stocky".tr,
        "curvy".tr,
      ];

  @override
  void initState() {
    super.initState();
    _populateFields();

    if (!widget.createAccount) {
      userController.getAdditionalProfileInfo().then((message) {
        if (message == "success") {
          setState(() {
            _populateFields();
          });
        } else {
          customSnackBar(message);
        }
      });
    }

    if (userController.aesthetics.isEmpty) {
      userController.getAesthetics();
    }
  }

  void _populateFields() {
    final u = userController.user;
    if (u != null) {
      if (u.name.isNotEmpty) {
        nameController.text = u.name;
      }
      if (u.age != null) {
        ageController.text = u.age.toString();
      }
      if (u.height != null) {
        heightController.text = u.height.toString();
      }
      if (u.country != null) {
        countryController.text = u.country!;
      }
      if (u.gender != null) {
        selectedGender = u.gender;
      }
      if (u.bodyType != null) {
        selectedBodyType = u.bodyType;
      }
      if (u.aesthetics != null && u.aesthetics!.isNotEmpty) {
        selectedAesthetics = List<int>.from(u.aesthetics!);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    heightController.dispose();
    countryController.dispose();
    super.dispose();
  }

  int? get _genderInitialIndex {
    if (selectedGender == null) return null;
    final index = genderValues.indexOf(selectedGender!.toLowerCase());
    if (index >= 0 && index < genderDisplayOptions.length) {
      return index;
    }
    return null;
  }

  int? get _bodyTypeInitialIndex {
    if (selectedBodyType == null) return null;
    final normalized = selectedBodyType!.toLowerCase();
    int index = bodyTypeValues.indexOf(normalized);
    if (index == 2) {
      // Map average to stocky index (2)
      index = 2;
    }
    if (index >= 0 && index < bodyTypeDisplayOptions.length) {
      return index;
    }
    return null;
  }

  void onSubmit() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      customSnackBar("Please enter your name");
      return;
    }

    int? age;
    if (ageController.text.trim().isNotEmpty) {
      age = int.tryParse(ageController.text.trim());
      if (age == null || age < 0) {
        customSnackBar("Please enter a valid age");
        return;
      }
    }

    int? height;
    if (heightController.text.trim().isNotEmpty) {
      height = int.tryParse(heightController.text.trim());
      if (height == null || height < 0) {
        customSnackBar("Please enter a valid height in cm");
        return;
      }
    }

    final country = countryController.text.trim();

    final res = await userController.updateAdditionalProfileInfo(
      name: name,
      age: age,
      gender: selectedGender,
      height: height,
      bodyType: selectedBodyType,
      country: country.isNotEmpty ? country : null,
      selectedAesthetic: selectedAesthetics,
      image: _pickedImage,
    );

    if (res == "success") {
      if (widget.createAccount) {
        RedirectService.gotoApp();
      } else {
        Get.back();
      }
      customSnackBar(
        widget.createAccount
            ? "Profile completed successfully!"
            : "Profile updated successfully!",
        isError: false,
      );
    } else {
      customSnackBar(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.createAccount ? "complete_profile".tr : "edit_profile".tr,
      ),
      body: Obx(
        () => userController.isLoading.value
            ? Center(child: CustomLoading())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      ProfilePicture(
                        imageFile: _pickedImage,
                        image: userController.user?.profileImage,
                        isEditable: true,
                        imagePickerCallback: (val) {
                          setState(() {
                            _pickedImage = val;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      Text("upload_photo".tr, style: AppTexts.tmdm),
                      const SizedBox(height: 24),
                      Column(
                        spacing: 16,
                        children: [
                          CustomTextField(
                            controller: nameController,
                            // leading: "assets/icons/name.svg",
                            hintText: "name".tr,
                          ),
                          Row(
                            spacing: 16,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: ageController,
                                  hintText: "age".tr,
                                  textInputType: TextInputType.number,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomDropDown(
                                  key: ValueKey(selectedGender),
                                  hintText: "gender".tr,
                                  options: genderDisplayOptions,
                                  initialPick: _genderInitialIndex,
                                  onChanged: (index, value) {
                                    if (index >= 0 && index < genderValues.length) {
                                      selectedGender = genderValues[index];
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CustomTextField(
                                  controller: heightController,
                                  hintText: "height_cm".tr,
                                  textInputType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 16,
                            children: [
                              Expanded(
                                child: CustomDropDown(
                                  key: ValueKey(selectedBodyType),
                                  hintText: "select_body_type".tr,
                                  options: bodyTypeDisplayOptions,
                                  initialPick: _bodyTypeInitialIndex,
                                  onChanged: (index, value) {
                                    if (index == 2) {
                                      selectedBodyType = 'average';
                                    } else if (index >= 0 &&
                                        index < bodyTypeValues.length) {
                                      selectedBodyType = bodyTypeValues[index];
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: CustomTextField(
                                  controller: countryController,
                                  hintText: "country".tr,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "your_aesthetic".tr,
                              style: AppTexts.tlgm,
                            ),
                          ),
                          Text("select_up_to_3".tr, style: AppTexts.tsmr),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => userController.isAestheticLoading.value
                            ? CustomLoading()
                            : GridView(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20,
                                  childAspectRatio: 0.88,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  for (var i in userController.aesthetics)
                                    styleCard(i),
                                ],
                              ),
                      ),
                      const SizedBox(height: 40),
                      Obx(
                        () => CustomButton(
                          isLoading: userController.isUpdatingInfo.value,
                          onTap: onSubmit,
                          text: "continue_btn".tr,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget styleCard(AestheticModel aesthetic) {
    bool isSelected = selectedAesthetics.contains(aesthetic.id);
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          setState(() {
            selectedAesthetics.remove(aesthetic.id);
          });
        } else if (selectedAesthetics.length < 3) {
          setState(() {
            selectedAesthetics.add(aesthetic.id);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(width: 2, color: AppColors.green.shade400)
              : Border.all(width: 2, color: Colors.transparent),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomNetworkedImage(url: aesthetic.image),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0, .5],
                    colors: [
                      Color.fromRGBO(7, 3, 1, 0.81),
                      Color.fromRGBO(202, 183, 175, 0.02),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  if (isSelected)
                    const Align(
                      alignment: Alignment.centerRight,
                      child: CustomSvg(
                        asset: "assets/icons/tick_circle_selected.svg",
                      ),
                    ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      aesthetic.name.isNotEmpty
                          ? aesthetic.name.substring(0, 1).toUpperCase() +
                              aesthetic.name.substring(1)
                          : '',
                      style: AppTexts.tmds.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
