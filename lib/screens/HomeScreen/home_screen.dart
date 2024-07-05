import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_challenge_tractian/models/asset.dart';
import 'package:flutter_challenge_tractian/models/location.dart';
import 'package:flutter_challenge_tractian/models/tree_node.dart';
import 'package:flutter_challenge_tractian/screens/AssetScreen/asset_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            if (isLoading) ...[
              CircularProgressIndicator(),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: () async {
                        String locationsJson = await rootBundle
                            .loadString('assets/jaguar/locations.json');
                        List<dynamic> jsonDataLocation =
                            jsonDecode(locationsJson);
                        List<Location> treeNodesLocations = jsonDataLocation
                            .map((json) => Location.fromJson(json))
                            .toList();

                        String assetsJson = await rootBundle
                            .loadString('assets/jaguar/assets.json');
                        List<dynamic> jsonDataAssets = jsonDecode(assetsJson);
                        List<Asset> treeNodesAssets = jsonDataAssets
                            .map((json) => Asset.fromJson(json))
                            .toList();

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AssetScreen(
                              locations: treeNodesLocations,
                              assets: treeNodesAssets,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            'Jaguar Unit',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    color: Colors.blue,
                    child: InkWell(
                      onTap: () async {
                        String locationsJson = await rootBundle
                            .loadString('assets/tobias/locations.json');
                        List<dynamic> jsonDataLocation =
                            jsonDecode(locationsJson);
                        List<Location> treeNodesLocations = jsonDataLocation
                            .map((json) => Location.fromJson(json))
                            .toList();

                        String assetsJson = await rootBundle
                            .loadString('assets/tobias/assets.json');
                        List<dynamic> jsonDataAssets = jsonDecode(assetsJson);
                        List<Asset> treeNodesAssets = jsonDataAssets
                            .map((json) => Asset.fromJson(json))
                            .toList();

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AssetScreen(
                              locations: treeNodesLocations,
                              assets: treeNodesAssets,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'Tobias Unit',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                Container(
                    color: Colors.blue,
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        String locationsJson = await rootBundle
                            .loadString('assets/apex/locations.json');
                        List<dynamic> jsonDataLocation =
                            jsonDecode(locationsJson);
                        List<Location> treeNodesLocations = jsonDataLocation
                            .map((json) => Location.fromJson(json))
                            .toList();

                        String assetsJson = await rootBundle
                            .loadString('assets/apex/assets.json');
                        List<dynamic> jsonDataAssets = jsonDecode(assetsJson);
                        List<Asset> treeNodesAssets = jsonDataAssets
                            .map((json) => Asset.fromJson(json))
                            .toList();

                        setState(() {
                          isLoading = false;
                        });

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AssetScreen(
                              locations: treeNodesLocations,
                              assets: treeNodesAssets,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'Apex Unit',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
