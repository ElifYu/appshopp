import 'package:appshop/models/customer_detail_model.dart';
import 'package:appshop/pages/address_information.dart';
import 'package:appshop/pages/checkout_base.dart';
import 'package:appshop/pages/order_address.dart';
import 'package:appshop/provider/cart_provider.dart';
import 'package:appshop/utils/ProgressHUD.dart';
import 'package:appshop/utils/colors.dart';
import 'package:appshop/utils/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';

class VerifyAddress extends CheckOutBasePage {
  var moneyAmount;
  VerifyAddress({this.moneyAmount});
  @override
  _VerifyAddressState createState() => _VerifyAddressState();
}

class _VerifyAddressState extends CheckOutBasePageState<VerifyAddress> {

  TextEditingController controllerFirstName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();
  TextEditingController controllerPhoneNumber = TextEditingController();
  TextEditingController controllerCountry = TextEditingController();
  TextEditingController controllerCity = TextEditingController();
  TextEditingController controllerState = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerAddressTitle = TextEditingController();

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

@override
  void initState() {
    super.initState();
    currentPage = 0;
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.fetchShippingDetails();
  }

  @override
  Widget pageUI() {
    return Consumer<CartProvider>(
      builder: (context, customerModel, child){
        if(customerModel.customerDetailModel.id != null) {
          return _formUI(customerModel.customerDetailModel);
        }
        return circularProgress();
      }
    );
  }

  Widget _formUI(CustomerDetailModel model) {
   return Form(
     key: globalKey,
     child: SingleChildScrollView(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           SizedBox(height: 20),
           Padding(
             padding: EdgeInsets.only(left: 10, right: 10),
             child: Row(
               children: [
                 Text('Contact Information', style: TextStyle(
                     fontWeight: FontWeight.w600,
                     fontSize: 16
                 ),),
                 Spacer(),
                 IconButton(
                   icon: LineIcon.pen(color: Colors.blueAccent,),
                   onPressed: (){
                     Get.to(AddressInformation());
                   },
                 )
               ],
             ),
           ),
           Container(
             decoration: BoxDecoration(
                 color: Colors.white,
                 border: Border(
                   bottom: BorderSide(color: Colors.grey.shade300),
                   top: BorderSide(color: Colors.grey.shade300),
                 )
             ),
             child: Padding(
               padding: const EdgeInsets.only(left: 14, right: 14, bottom: 5, top: 5),
               child: Column(
                 children: [
                   Row(
                     children: [
                       Container(
                         width: MediaQuery.of(context).size.width / 3,
                         child: Text("First Name", style: TextStyle(
                           fontWeight: FontWeight.w500,
                           color: Colors.black45,

                         ),),
                       ),
                       Expanded(
                         child: TextFormField(
                            style: TextStyle(
                             color: Colors.black54
                           ),
                           enabled: false,
                           controller: controllerFirstName..text = model.firstName!,
                           validator: (input) => input!.isEmpty
                               ? "Please enter your first name" : null,
                           cursorColor: Colors.grey[800],
                           decoration: InputDecoration(
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.all(10.0),
                               hintText: 'Enter your first name',
                               hintStyle: TextStyle(
                                   fontSize: 14,
                                   fontWeight: FontWeight.w400,
                                   color: Colors.grey[500]
                               )
                           ),
                         ),
                       )
                     ],
                   ),
                   Divider(height: 0,),
                   Row(
                     children: [
                       Container(
                         width: MediaQuery.of(context).size.width / 3,
                         child: Text("Last Name", style: TextStyle(
                           fontWeight: FontWeight.w500,
                           color: Colors.black45,

                         ),),
                       ),
                       Expanded(
                         child: TextFormField(
                            style: TextStyle(
                             color: Colors.black54
                           ),
                           controller: controllerLastName..text = model.lastName!,
                           validator: (input) => input!.isEmpty
                               ? "Please enter your last name" : null,
                           cursorColor: Colors.grey[800],
                              enabled: false,
                           decoration: InputDecoration(
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.all(10.0),
                               hintText: 'Enter your last name',
                               hintStyle: TextStyle(
                                   fontSize: 14,
                                   fontWeight: FontWeight.w400,
                                   color: Colors.grey[500]
                               )
                           ),
                         ),
                       )
                     ],
                   ),
                   Divider(height: 0,),
                   Row(
                     children: [
                       Container(
                         width: MediaQuery.of(context).size.width / 3,
                         child: Text("Phone Number", style: TextStyle(
                           fontWeight: FontWeight.w500,
                           color: Colors.black45,

                         ),),
                       ),
                       Expanded(
                         child: TextFormField(
                            style: TextStyle(
                             color: Colors.black54
                           ),
                           controller: controllerPhoneNumber..text = model.billing!.phone!,
                           validator: (input) => input!.isEmpty
                               ? "Please enter your phone number" : null,
                           cursorColor: Colors.grey[800],
                              enabled: false,
                           decoration: InputDecoration(
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.all(10.0),
                               hintText: 'Enter your phone number',
                               hintStyle: TextStyle(
                                   fontSize: 14,
                                   fontWeight: FontWeight.w400,
                                   color: Colors.grey[500]
                               )
                           ),
                         ),
                       )
                     ],
                   ),
                 ],
               ),
             ),
           ),
           SizedBox(height: 30),
           Padding(
             padding: EdgeInsets.only(left: 10, right: 10),
             child: Row(
               children: [
                 Text('Address Information', style: TextStyle(
                     fontWeight: FontWeight.w600,
                     fontSize: 16
                 ),),
                 Spacer(),
                 IconButton(
                   icon: LineIcon.pen(color: Colors.blueAccent,),
                   onPressed: (){
                     Get.to(AddressInformation());
                   },
                 )
               ],
             ),
           ),
           Container(
             decoration: BoxDecoration(
                 color: Colors.white,
                 border: Border(
                   bottom: BorderSide(color: Colors.grey.shade300),
                   top: BorderSide(color: Colors.grey.shade300),
                 )
             ),
             child: Padding(
               padding: const EdgeInsets.only(left: 14, right: 14, bottom: 5, top: 5),
               child: Column(
                 children: [
                   Row(
                     children: [
                       Container(
                         width: MediaQuery.of(context).size.width / 3,
                         child: Text("Country", style: TextStyle(
                           fontWeight: FontWeight.w500,
                           color: Colors.black45,

                         ),),
                       ),
                       Expanded(
                         child: TextFormField(
                            style: TextStyle(
                             color: Colors.black54
                           ),
                           controller: controllerCountry..text = model.billing!.country!,
                           validator: (input) => input!.isEmpty
                               ? "This field is required to be filled" : null,
                           cursorColor: Colors.grey[800],
                              enabled: false,
                           decoration: InputDecoration(
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.all(10.0),
                               hintText: 'Enter your country',
                               hintStyle: TextStyle(
                                   fontSize: 14,
                                   fontWeight: FontWeight.w400,
                                   color: Colors.grey[500]
                               )
                           ),
                         ),
                       )
                     ],
                   ),
                   Divider(height: 0,),
                   Row(
                     children: [
                       Container(
                         width: MediaQuery.of(context).size.width / 3,
                         child: Text("City", style: TextStyle(
                           fontWeight: FontWeight.w500,
                           color: Colors.black45,

                         ),),
                       ),
                       Expanded(
                         child: TextFormField(
                            style: TextStyle(
                             color: Colors.black54
                           ),
                           controller: controllerCity..text = model.billing!.city!,
                           validator: (input) => input!.isEmpty
                               ? "This field is required to be filled" : null,
                           cursorColor: Colors.grey[800],
                              enabled: false,
                           decoration: InputDecoration(
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.all(10.0),
                               hintText: 'Enter your city',
                               hintStyle: TextStyle(
                                   fontSize: 14,
                                   fontWeight: FontWeight.w400,
                                   color: Colors.grey[500]
                               )
                           ),
                         ),
                       )
                     ],
                   ),
                   Divider(height: 0,),
                   Row(
                     children: [
                       Container(
                         width: MediaQuery.of(context).size.width / 3,
                         child: Text("State", style: TextStyle(
                           fontWeight: FontWeight.w500,
                           color: Colors.black45,

                         ),),
                       ),
                       Expanded(
                         child: TextFormField(
                            style: TextStyle(
                             color: Colors.black54
                           ),
                           controller: controllerState..text = model.billing!.state!,
                           validator: (input) => input!.isEmpty
                               ? "This field is required to be filled" : null,
                           cursorColor: Colors.grey[800],
                              enabled: false,
                           decoration: InputDecoration(
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.all(10.0),
                               hintText: 'Enter your state',
                               hintStyle: TextStyle(
                                   fontSize: 14,
                                   fontWeight: FontWeight.w400,
                                   color: Colors.grey[500]
                               )
                           ),
                         ),
                       )
                     ],
                   ),
                   Divider(height: 0,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(top: 18),
                         child: Container(
                           width: MediaQuery.of(context).size.width / 3,
                           child: Text("Address", style: TextStyle(
                             fontWeight: FontWeight.w500,
                             color: Colors.black45,

                           ),),
                         ),
                       ),
                       Expanded(
                         child: TextFormField(
                            style: TextStyle(
                             color: Colors.black54
                           ),
                           maxLines: 5,
                           controller: controllerAddress..text = model.billing!.address1!,
                           validator: (input) => input!.isEmpty
                               ? "This field is required to be filled" : null,
                           cursorColor: Colors.grey[800],
                              enabled: false,
                           decoration: InputDecoration(
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.all(10.0),
                               hintText: 'Enter your address',
                               hintStyle: TextStyle(
                                   fontSize: 14,
                                   fontWeight: FontWeight.w400,
                                   color: Colors.grey[500]
                               )
                           ),
                         ),
                       )
                     ],
                   ),
                   Divider(height: 0,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(top: 18),
                         child: Container(
                           width: MediaQuery.of(context).size.width / 3,
                           child: Text("Address Title", style: TextStyle(
                             fontWeight: FontWeight.w500,
                             color: Colors.black45,
                           ),),
                         ),
                       ),
                       Expanded(
                         child: TextFormField(
                            style: TextStyle(
                             color: Colors.black54
                           ),
                           controller: controllerAddressTitle..text = model.billing!.address2!,
                           validator: (input) => input!.isEmpty
                               ? "This field is required to be filled" : null,
                           cursorColor: Colors.grey[800],
                              enabled: false,
                           decoration: InputDecoration(
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.all(10.0),
                               hintText: 'Enter your address title',
                               hintStyle: TextStyle(
                                   fontSize: 14,
                                   fontWeight: FontWeight.w400,
                                   color: Colors.grey[500]
                               )
                           ),
                         ),
                       ),
                     ],
                   ),
                 ],
               ),
             ),
           ),
           SizedBox(height: 30),
           Center(
             child: Container(
               width: MediaQuery.of(context).size.width / 1.03,
               child: FlatButton(
                 onPressed: (){
                   if(validateAndSave()){
                     Get.to(PaymentMethodsWidget(
                         moneyAmount: widget.moneyAmount,
                         model: model
                     ));
                   }
                   else{
                     Get.to(AddressInformation(
                       note: '0'
                     ))!.then((value) {
                       var cartProvider = Provider.of<CartProvider>(context, listen: false);
                       cartProvider.fetchShippingDetails();
                     });
                   }
                 },
                 child: Text("Next", style: TextStyle(
                     color: Colors.white,
                     fontSize: 17,
                     fontWeight: FontWeight.w500
                 ),),
                 color: color1,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(5.0),
                 ),
                 padding: EdgeInsets.only(top: 11, bottom: 11),
               ),
             ),
           ),
           SizedBox(height: 30),
         ],
       ),
     ),
   );
  }

  bool validateAndSave(){
    final form = globalKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }
    return false;
  }
}
