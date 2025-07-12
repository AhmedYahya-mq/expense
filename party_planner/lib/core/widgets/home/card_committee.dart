
import 'package:flutter/material.dart';

class CardCommittee extends StatelessWidget {
  const CardCommittee({
    super.key,
    required this.name,
    required this.balance,
    required this.icon,
  });
  final String name;
  final int balance;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        shadowColor: Theme.of(context).shadowColor,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          height: 80,
          width: 180, // عرض الكرت
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 55,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
             SizedBox(width: 5,),
              SizedBox(
                height: 50,
                child: Column(
                  children: [
                    Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      "$balance ريال",
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
