import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  static const String _appPackageName = 'com.triviaspree.car_logo';

  static const String _instagramUrl = 'https://www.instagram.com/appgrail/';
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          _buildDrawerHeader(),
          _buildDrawerItem(Icons.share, 'Share this App', ()=>_shareApp(context)),
          _buildDrawerItem(Icons.star, 'Rate this App', () => _rateApp(context)),
          _buildDrawerItem(Icons.info, 'About',  () => _showAboutDialog(context)),
          _buildDrawerItem(Icons.person, 'Follow Us', () => _launchInstagram(context)),
          _buildDrawerItem(Icons.explore, 'More Apps', () => _discoverMoreApps()),
          _buildDrawerItem(Icons.discord, 'Join Our Discord', () => _joinDiscord()),
        ],
      ),
    );
  }

  void _shareApp(BuildContext context){
    Share.share(
        'Check out this awesome app! https://play.google.com/store/apps/details?id=$_appPackageName'
    );
  }

  void _rateApp(BuildContext context) async{
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()){
      inAppReview.requestReview();
    } else {
      _launchUrl(
          Uri.parse('https://play.google.com/store/apps/details?id=$_appPackageName'));
    }
  }

  void _showAboutDialog(BuildContext context){
    showAboutDialog(
      context: context,
      applicationName: 'AppGrail Apps',
      children: [
        const Text('Mobile App Studio 🛠️ Crafting mini tools for stock brokers 📈 and crypto enthusiasts 🪙. Empower your trading experience today!', style: TextStyle(color: Colors.white),),
      ],
    );
  }

  void _launchInstagram(BuildContext context)async{
    _launchUrl(Uri.parse(_instagramUrl));
  }

  void _discoverMoreApps() async{
    _launchUrl(Uri.parse('https://play.google.com/store/apps/dev?id=8056144148458259352&hl=en'));
  }

  void _joinDiscord() async{
    _launchUrl(Uri.parse('https://discord.gg/zFDc8MqXvb'));
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}

Widget _buildDrawerHeader(){
  return const DrawerHeader(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/logo-black.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: null,
  );
}

Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListTile(
      leading: Icon(icon, color: Colors.black,),
      title: Text(title, style: const TextStyle(color: Colors.black),),
      onTap: onTap,
    ),
  );
}