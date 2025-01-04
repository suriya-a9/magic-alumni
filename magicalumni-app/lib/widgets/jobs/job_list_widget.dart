import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JobListWidget extends StatelessWidget {
  final List<String> jobTitles;
  final List<String> locations;
  final VoidCallback? onReportTap;
  const JobListWidget({
    super.key, 
    required this.jobTitles, 
    required this.locations, 
    this.onReportTap
  });

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: jobTitles.length,
      itemBuilder: (context, index) {
        return Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              // Job List tile 
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black.withValues(alpha: 0.06), width: 1),
                  borderRadius: BorderRadius.circular(8)
                ),
                child:  Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 15,
                          children: [
                            CircleAvatar(
                              child:  Icon(Icons.work_history),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  jobTitles[index], 
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF161719),
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                Text(
                                  locations[index],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black26
                                  ),
                                ),
                                
                              ],
                            ),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Apply within: ",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45
                            ),
                            children: [
                              TextSpan(
                                text: "13 Mar 2025",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black45,
                                )
                              )
                            ]
                          )
                        ),
                        
                      ],
                    ),
                    Material(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 20,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                            radius: 20,
                            onTap: () {
                              
                            }, 
                            child: Icon(CupertinoIcons.link, color: Theme.of(context).primaryColor, size: 20,)
                          ),
                          InkWell(
                            onTap: onReportTap, 
                            child: Icon(Icons.report_outlined, color: Theme.of(context).primaryColor, size: 20,)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: index == jobTitles.length - 1 ? 66: 10,)
            ],
          ),
        );
      },
    );
  }
}