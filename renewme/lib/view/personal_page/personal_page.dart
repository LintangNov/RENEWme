import 'package:flutter/material.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(title: Text('Personal')),
      body: SafeArea(
        bottom: true,
        child: ListView.builder(
          itemCount: 3, // Misal ada 3 kelompok menu
          itemBuilder: (context, index) {
            if (index == 0) {
              // Kelompok 1:
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 2, // Seberapa luas bayangan menyebar
                      blurRadius: 5, // Seberapa buram bayangannya
                      offset: Offset(0, 3), // Posisi bayangan (x, y)
                    ), // Warna bayangan, diatur transparansinya
                  ],
                ),
                margin: EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.star),
                      title: Text('ShopeeFood Deals'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(color: Colors.grey), // Ini dia divider-nya!
                    ListTile(
                      leading: Icon(Icons.card_giftcard),
                      title: Text('Voucher Saya'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(color: Colors.grey),
                    ListTile(
                      leading: Icon(Icons.monetization_on),
                      title: Text('Koin Shopee Saya'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              );
            }
            // Kelompok lainnya...
            return Container();
          },
        ),
      ),
    );
  }
}
