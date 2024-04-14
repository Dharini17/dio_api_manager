
import 'package:flutter/material.dart';

class Utility{

  static Widget funcLoaderFuture() {
    return Center(
        child: Container(
          height: 35,
          width: 35,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.transparent,
          ),
          child: const Center(
              child: SizedBox(
                height: 35,
                width: 35,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  strokeWidth: 3.0,
                ),
              )),
        ));
  }

  static Widget funcFutureBuilderError({required onTryAgain, required bool isInternetCheck}) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isInternetCheck
              ? 'No Internet Connected'
              : 'Something went wrong, please try after sometime.',textAlign: TextAlign.center,),
          const SizedBox(height: 10,),
          InkWell(
              onTap: ()=>onTryAgain(),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2)),
                padding: const EdgeInsets.all(5.0),
                child: Text('Try again'),
              ))
        ],
      ),
    );
  }

}