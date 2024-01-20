import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lev_mobile/models/company_model.dart';
import 'package:lev_mobile/network/my_http_client.dart';
import 'package:lev_mobile/styling/theme.dart';
import 'package:lev_mobile/widgets/my_network_image.dart';

class ShowCompany extends StatefulWidget {
  Company company;
  ShowCompany({
    Key? key,
    required this.company
  }) : super(key: key);

  @override
  State<ShowCompany> createState() => _ShowCompanyState();
}

class _ShowCompanyState extends State<ShowCompany> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 18),
          if(widget.company.logo != null && widget.company.logo!.isNotEmpty)
            ClipRRect(
              child: MyNetworkImage(
                url: MyHttpClient.root + widget.company.logo!,
                height: 90,
                width: 90,
              ),
              borderRadius: BorderRadius.circular(80),
            ),
          if(widget.company.logo != null && widget.company.logo!.isNotEmpty)
            SizedBox(height: 18),
          Text(
            widget.company.name ?? "---",
            style: TextStyle(
              color: Color(0xFF8A8A8A),
              fontFamily: fontName,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 18),
          ListTile(
            leading: Icon(IconlyLight.message),
            title:Text(widget.company.email ?? "---"),
          ),
          ListTile(
            leading: Icon(IconlyLight.call),
            title:Text(widget.company.phone ?? "---"),
          ),
          ListTile(
            leading: Icon(IconlyLight.location),
            title:Text(
                (widget.company.address ?? "---") + ", " +
                (widget.company.province ?? "---") + ", " +
                (widget.company.city ?? "---") + ", " +
                (widget.company.country ?? "---") + " - " +
                (widget.company.postcode ?? "---")
            ),
          ),
          ListTile(
            leading: Icon(Icons.directions_walk),
            title:Text(widget.company.stepLevs.toString() ?? ""
            ),
          ),
        ],
      ),
    );
  }
}
