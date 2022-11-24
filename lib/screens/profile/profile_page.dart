import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../../util/db.dart';
import '../dashboard.dart';

class ProfilePage extends StatefulWidget {

  final dynamic ssoUserData;
  //User data in Firebase
  final dynamic fbUserData;

  const ProfilePage({Key? key, required this.ssoUserData, required this.fbUserData})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

final profile = {
  "rank":"",
  "job_title":"",
  "unit":""
};
class _ProfilePageState extends State<ProfilePage> {
  bool _unitHasError = false;
  final DB db = DB();
  final _formKey = GlobalKey<FormState>();
  List<String> rankOptions = [
    "PVT - Private",
    "PV2 - Private Second Class",
    "PFC - Private First Class",
    "SPC - Specialist",
    "CPL - Corporal",
    "SGT - Sergeant",
    "SSG - Staff Sergeant",
    "SFC - Sergeant First Class",
    "MSG - Master Sergeant",
    "1SG - First Sergeant",
    "SGM - Sergeant Major",
    "CSM - Command Sergeant Major",
    "SMA - Sergeant Major of the Army",
    "WO1 - Warrant Officer 1",
    "CW2 - Chief Warrant Officer 2",
    "CW3 - Chief Warrant Officer 3",
    "CW4 - Chief Warrant Officer 4",
    "CW5 - Chief Warrant Officer 5",
    "2LT - Second Lieutenant",
    "1LT - First Lieutenant",
    "CPT - Captain",
    "MAJ - Major",
    "LTC - Lieutenant Colonel",
    "COL - Colonel",
    "BG - Brigadier General",
    "MG - Major General",
    "LTG - Lieutenant General",
    "GEN - General",
    "GA - General of the Army"
  ];
  final  initalRank = "1LT - First Lieutenant";
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {

    dateInput.text = DateFormat("MM/dd/yyyy")
        .format(DateTime.now()); //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return  Padding(padding: EdgeInsets.all(30.0),child:
    FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        skipDisabled: true,
        child: Column(
          children: [
            Text(
                "Please update your profile",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
            ),
            FormBuilderDropdown<String>(
              onChanged: (val){
                setState(() {
                  profile['rank']=val!;
                });
              },
              name: 'rank',
              decoration: InputDecoration(
                labelText: 'Rank',
                suffix: Icon(Icons.check,color: Colors.green),
                hintText: 'Select Rank',
              ),
              items: rankOptions
                  .map((gender) => DropdownMenuItem(
                alignment: AlignmentDirectional.center,
                value: gender,
                child: Text(gender),
              ))
                  .toList(),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(200),
                ])
            ),
            FormBuilderTextField(
              autovalidateMode: AutovalidateMode.disabled,
              name: 'job_title',
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'Job Title',
                hintText: "Eg: Supply Sergeant",
                // helperText: "Describe your current job in the Army",
                errorStyle: TextStyle(color: Colors.black),
                suffixIcon: profile['job_title']!.isEmpty
                    ? const Icon(Icons.error, color: Colors.black)
                    : const Icon(Icons.check, color: Colors.green),
              ),
              onChanged: (val) {
                setState(() {
                  profile['job_title']=val!;
                });
              },
              // valueTransformer: (text) => num.tryParse(text),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.max(200),
              ]),
              // initialValue: '12',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            FormBuilderTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              name: 'Unit',
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Unit Info',
                hintText: "Eg: 360 PSYCHOLOGICAL OPERATIONS COMPANY",
                errorStyle: TextStyle(color: Colors.black),
                // helperText: "Please include Company/Battery/Troop and the Battalion/Brigade/Division info",
                suffixIcon: profile['unit']!.isEmpty
                    ? const Icon(Icons.error, color: Colors.black)
                    : const Icon(Icons.check, color: Colors.green),
              ),
              onChanged: (val) {
                setState(() {
                  profile['unit']=val!;
                });;
              },
              // valueTransformer: (text) => num.tryParse(text),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.max(400),
              ]),
              // initialValue: '12',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              width: double.infinity,
              child:  ElevatedButton(
                child: const Text('Complete my profile!'),
                onPressed: isValid()? () async {
                var email = db.getEmail(widget.ssoUserData);
                final updated = await db.updateUserProfile(email, profile);
                print("Updated user profile for ${email} with ${profile.toString()}");
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => Dashboard(ssoUserData:widget.ssoUserData)), (r) => false);
                }:null,
              ),
            ),
          ],

        )
    )
    );
  }

  _submit() {

  }
}

isValid() {
return (!profile['rank']!.isEmpty && !profile['job_title']!.isEmpty && !profile['unit']!.isEmpty);
}
