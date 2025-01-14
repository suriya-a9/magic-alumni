import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:magic_alumni/ui/views/profile/profile_viewmodel.dart';
import 'package:magic_alumni/widgets/common/text_field.dart';
import 'package:stacked/stacked.dart';

import '../../../constants/app_constants.dart';
import '../../../model/colleges_model.dart';
import '../../../widgets/common/dot_indicator.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ProfileViewmodel(),
      onDispose: (viewModel) => viewModel.disposeProfile(),
      onViewModelReady: (viewModel) async => await viewModel.init(),
      builder: (ctx, model, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Profile card
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: kToolbarHeight  - 16),
                    child: SizedBox(
                      height: kToolbarHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(left: 55),
                            child: Text(
                              "Profile", 
                              style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            tooltip: "Log out",
                            onPressed: () async {
                              await model.confirmLogout();
                            }, 
                              icon: SizedBox(
                                height: 24, 
                                width: 24, 
                                child: Image.asset("assets/icon/out.png", color: Colors.white,),
                              )
                            )
                        ],
                      )
                    ),
                  ),
                ),
              ),
              // Body of the screen
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                top: size.height * 0.23,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Space padding for the tabs from above (below) card in stack
                          SizedBox(height: size.height * 0.1,),
                           Column(
                          spacing: 10,
                          children: [
                            Container(),
                            // Name textfield
                            TextFieldWidget(
                              controller: model.userNameController,
                              hintText: "Full Name",
                              textInputAction: TextInputAction.next,
                              onChanged: (value) => model.isEditing = true,
                            ),
                            // LinkedIn profile URL text field
                            TextFieldWidget(
                              controller: model.linkedUrlController,
                              hintText: "LinkedIn Profile URL",
                              textInputAction: TextInputAction.next,
                              onChanged: (value) => model.isEditing = true
                            ),
                            // college name field
                            TextFieldWidget(
                              controller: model.collegeNameController,
                              hintText: "College Name",
                              readOnly: true,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) => model.isEditing = true
                            ),
                            // Department name field
                            TextFieldWidget(
                              controller: model.depNameController,
                              hintText: "Department Name",
                              readOnly: true,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) => model.isEditing = true
                            ),
                            // current year or passed out year text field
                            TextFieldWidget(
                              controller: model.currentOrCcyController,
                              hintText: "Current year/ Passed Out Year",
                              readOnly: true,
                              keyboardType: model.isCurrentYearStudent ? null: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) => model.isEditing = true
                            ),
                            // Email text field
                            TextFieldWidget(
                              controller: model.emailController,
                              hintText: "Email",
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) => model.isEditing = true
                            ),
                            // Mobile text field
                            TextFieldWidget(
                              controller: model.mobileController,
                              hintText: "Mobile number",
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) => model.isEditing = true
                            ),
                            // Designation text field
                            model.alumni != null && model.alumni!.alumniProfileDetail.role == "Student"
                            ? Container()
                            : TextFieldWidget(
                              controller: model.designationController,
                              hintText: "Desgination",
                              textInputAction: TextInputAction.next,
                              onChanged: (value) => model.isEditing = true
                            ),
                            // Add new college Section if the user need to add new college
                            model.alumni != null && model.alumni!.alumniProfileDetail.role == "Student"
                            ? Container()
                            : ExpansionTile(
                              collapsedBackgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.circular(8)
                              ),
                              collapsedShape: RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius: BorderRadius.circular(8)
                              ),
                              onExpansionChanged: (value) async{
                                model.checkExpanded(value);
                                model.collegesList.isEmpty ? await model.getColleges() : null;
                              },
                              title: Text("Add College", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                              children: [
                                const SizedBox(height: 10,),
                                // New college Name text Field
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: DropdownButton<CollegesModel>(
                                    isExpanded: true,
                                    hint: Row(
                                      spacing: 15,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Image.asset(
                                            "assets/icon/college.png", color: Theme.of(context).primaryColor,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Text(
                                          model.selectedCollege != null ? model.selectedCollege!.collegeName : "Colleges", 
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400, 
                                            fontSize: model.selectedCollege != null ? 14 :12, 
                                            color: model.selectedCollege != null ? Colors.black : Colors.black45
                                          ),
                                        ),
                                      ],
                                    ),
                                    // value: model.selectedCollege!,
                                    underline: Container(),
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    items: model.auth.collegesList.map((value) {
                                      return DropdownMenuItem<CollegesModel>(
                                        value: value,
                                        child: Text(value.collegeName, style: TextStyle(fontSize: 14),)
                                      );
                                    },).toList(), 
                                    onChanged: (value) {
                                      if(value != null){
                                        model.setCollege(value);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                // Department Drop down button 
                                Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: DropdownButton(
                                isExpanded: true,
                                hint: Row(
                                  spacing: 15,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Image.asset(
                                        "assets/icon/department.png", color: Theme.of(context).primaryColor,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Text(
                                      model.selectedDepartment != null ? model.selectedDepartment! : "Select Department", 
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400, 
                                        fontSize: model.selectedDepartment != null ? 14 : 12, 
                                        color: model.selectedDepartment != null ? Colors.black : Colors.black45
                                      ),
                                    ),
                                  ],
                                ),
                                // value: model.selectedCollege!,
                                underline: Container(),
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                items:  model.selectedCollege?.departments.map((value) {
                                  return DropdownMenuItem<DepartmentModel>(
                                    value: value,
                                    child: Text(value.departmentName, style: TextStyle(fontSize: 14),)
                                  );
                                },).toList(), 
                                onChanged: (value) {
                                  if(value != null){
                                    model.setDepartment(value);
                                  }
                                },
                              ),
                            ),
                                const SizedBox(height: 10,),
                                // Current year or passed out year text field
                                TextFieldWidget(
                                  controller: model.newCurrentYearOrAlumniController,
                                  hintText: "Passed out Year",
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 10,),
                                // check box for current year students
                                CheckboxListTile(
                                  dense: true,
                                  checkboxScaleFactor: 0.8,
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: VisualDensity(horizontal: -4,),
                                  value: model.isCurrentYearStudent,
                                  controlAffinity: ListTileControlAffinity.leading, 
                                  title: Text("Current Year Student", 
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                  ),
                                  onChanged: (value) {
                                    model.changeStudentStatus(value!);
                                  },
                                ),
                                // Send to permission to the admin
                                ElevatedButton(
                                  onPressed: () async {
                                    await model.addCollege();
                                  },
                                  child: Text(
                                    'Send Request to Admin',
                                    style: textStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                            model.isExpanded
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 50.0,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: model.isEdited ? null : Theme.of(context).primaryColor.withValues(alpha: 0.4)
                                        ),
                                        onPressed: () async { 
                                          model.isEdited
                                          ? await model.update()
                                          : null;
                                        },
                                        child: Text(
                                          'Save',
                                          style: textStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 50.0,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: model.isEdited ? null : Theme.of(context).primaryColor.withValues(alpha: 0.4)
                                        ),
                                        onPressed: () {
                                          model.isEditing = false;
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: textStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // // Profile card and status card
              Positioned(
                top: 100,
                left: 16,
                right: 16,
                child: SizedBox(
                  height: size.height * 0.18,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:  model.alumni != null ? model.alumni!.colleges.length : 2,
                        onPageChanged: (value) {
                          // model.selectOtherCollege(value);
                        },
                        itemBuilder: (context, index) {
                          return Card(
                            color: Color(0xFFFCFCFF),
                            child: Padding(
                              padding: const EdgeInsets.all(commonPadding),
                              child: Row(
                                children: [
                                  Column(
                                    spacing: 5,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        model.alumni !=  null ? model.alumni!.alumniProfileDetail.name : "",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      Text(
                                        model.alumni != null && model.alumni!.colleges.isEmpty 
                                          ? "Not approved" 
                                          : "${model.alumni!.colleges[index].departments[index].departmentName}, ${model.alumni!.colleges[index].collegeName}",
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: Row(
                                          spacing: 10,
                                          children: [
                                            Icon(
                                             model.alumni != null && model.alumni!.colleges[index].status == "approved" 
                                              ? CupertinoIcons.check_mark_circled_solid
                                              : CupertinoIcons.info_circle, 
                                              size: model.alumni != null && model.alumni!.colleges[index].status == "approved" ? 14 : 18, 
                                              color: model.alumni != null && model.alumni!.colleges[index].status == "approved" ? Colors.green : Colors.red,
                                            ),
                                            Text(
                                              model.alumni !=  null && model.alumni!.colleges.isEmpty
                                                ? "nothing" 
                                                : model.alumni!.colleges[index].status == "approved" ? "You are approved Alumni now" : "You are not approved by your college",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      model.alumni != null && model.alumni!.colleges.isEmpty
                      ? Container()
                      : Positioned(
                        bottom: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 5,
                          children: List.generate( model.alumni != null ? model.alumni!.colleges.length : 1, 
                          (index) {
                            return DotIndicator(isActive: index == model.selectedIndex,);
                          },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}