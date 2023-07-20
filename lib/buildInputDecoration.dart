import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

 buildInputDecoration(IconData icons,String hinttext){
    return InputDecoration(
      fillColor: Colors.transparent,
      filled: true,
      hintText: hinttext,
      isDense: true,
      contentPadding: EdgeInsets.all(1.0.h),
      hintStyle: TextStyle(fontSize: 12.0.sp, color: Colors.grey),
      prefixIcon: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0.w),
        child: Icon(icons,
          size: 16.sp, color: Colors.grey,),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      enabledBorder:OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
  }