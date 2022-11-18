import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../../util/db.dart';

class ProfilePage extends StatefulWidget {

  final dynamic user;
  //User data in Firebase
  final dynamic userData;

  const ProfilePage({Key? key, required this.user, required this.userData})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

var selectedVersion;

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

    bool isInteger(num value) => (value % 1) == 0;
print(widget.user);
print("userData:");
print(widget.userData);

    List<dynamic> list = [];

    return  Padding(padding: EdgeInsets.all(30.0),child:
    FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        initialValue: const {
          'unit': '13',
        },
        skipDisabled: true,
        child: Column(
          children: [
            Text(
                "Please update your profile",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
            ),
            FormBuilderDropdown<String>(
              name: 'rank',
              decoration: InputDecoration(
                labelText: 'Rank',
                suffix: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {

                  },
                ),
                hintText: 'Select Rank',
              ),
              items: rankOptions
                  .map((gender) => DropdownMenuItem(
                alignment: AlignmentDirectional.center,
                value: gender,
                child: Text(gender),
              ))
                  .toList(),
            ),
            FormBuilderTextField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              name: 'job_title',
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'Job Title',
                hintText: "Eg: Supply Sergeant",
                // helperText: "Describe your current job in the Army",
                errorStyle: TextStyle(color: Colors.black),
                suffixIcon: _unitHasError
                    ? const Icon(Icons.error, color: Colors.red)
                    : const Icon(Icons.check, color: Colors.green),
              ),
              onChanged: (val) {

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
                suffixIcon: _unitHasError
                    ? const Icon(Icons.error, color: Colors.black)
                    : const Icon(Icons.check, color: Colors.green),
              ),
              onChanged: (val) {

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
            SizedBox(
              width: double.infinity,
              child:  ElevatedButton(
                child: const Text('Complete my profile!'),
                onPressed: () async {
                },
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
