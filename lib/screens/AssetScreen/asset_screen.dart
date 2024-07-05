import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_challenge_tractian/models/asset.dart';
import 'package:flutter_challenge_tractian/models/location.dart';
import 'package:flutter_challenge_tractian/models/tree_node.dart';
import 'package:flutter_challenge_tractian/screens/AssetScreen/components/tree_view.dart';

class AssetScreen extends StatefulWidget {
  final List<Location> locations;
  final List<Asset> assets;
  const AssetScreen({
    super.key,
    required this.locations,
    required this.assets,
  });

  @override
  State<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends State<AssetScreen> {
  TextEditingController textFieldController = TextEditingController();
  String statusFilter = '';
  String energySensorFilter = '';
  String textFieldSearch = '';
  List<TreeNode> treeView = [];

  List<TreeNode> getNodesFromAssets() {
    final locationNodes = widget.locations
        .map(
          (location) => TreeNode(
            name: location.name,
            id: location.id,
            parentId: location.parentId,
            nodeType: NodeType.location.name,
          ),
        )
        .toList();

    final assetNodes = widget.assets
        .map(
          (asset) => TreeNode(
            name: asset.name,
            id: asset.id,
            parentId: asset.parentId,
            locationId: asset.locationId,
            sensorType: asset.sensorType,
            status: asset.status,
            nodeType: asset.sensorType != null
                ? NodeType.component.name
                : NodeType.asset.name,
          ),
        )
        .toList();

    final nodes = locationNodes + assetNodes;
    return nodes;
  }

  void getNodeChildren(
    List<TreeNode> rootNodes,
    Map<String, TreeNode> nodeMap, {
    String? statusFilter,
  }) {
    for (var node in rootNodes) {
      if (nodeMap[node.id]?.children != null) {
        final index = rootNodes.indexWhere((parent) => parent.id == node.id);
        final children = nodeMap[node.id]?.children;
        rootNodes[index] = TreeNode(
          name: node.name,
          id: node.id,
          nodeType: node.nodeType,
          parentId: node.parentId,
          locationId: node.locationId,
          sensorType: node.sensorType,
          status: node.status,
          children: children,
        );
        final newRootNodes = rootNodes[index].children ?? [];
        getNodeChildren(
          newRootNodes,
          nodeMap,
          statusFilter: statusFilter,
        );
      }
    }
  }

  TreeNode? getFirstParent(
    Map<String, TreeNode> nodeMap,
    TreeNode child,
  ) {
    if (child.parentId == null && child.locationId == null) {
      return child;
    } else {
      final parentId = child.parentId ?? child.locationId;
      final parent = nodeMap.values.firstWhere((node) => node.id == parentId);
      return getFirstParent(nodeMap, parent);
    }

    // return null;
  }

  void addUniqueNode(List<TreeNode> nodeList, TreeNode node) {
    if (nodeList.contains(node)) {
      return;
    }
    nodeList.add(node);
  }

  void getFilteredNodes(
    List<TreeNode> filteredNodes,
    List<TreeNode> rootNodes,
    Map<String, TreeNode> nodeMap,
    List<String> filters,
    String textSearch,
  ) {
    for (TreeNode node in rootNodes) {
      if (node.children == null || node.children!.isEmpty) {
        bool existed = false;
        if (textSearch.isNotEmpty && node.name.contains(textSearch)) {
          existed = true;
        }
        if (filters.contains(node.status) ||
            filters.contains(node.sensorType) ||
            existed) {
          if (node.parentId == null && node.locationId == null) {
            // filteredNodes.add(node);
            addUniqueNode(filteredNodes, node);
          } else {
            final firstParent = getFirstParent(nodeMap, node);
            if (firstParent != null) {
              // filteredNodes.add(firstParent);
              addUniqueNode(filteredNodes, firstParent);
            }
          }
        } else {
          continue;
        }
      } else {
        getFilteredNodes(
          filteredNodes,
          node.children!,
          nodeMap,
          filters,
          textSearch,
        );
      }
    }
  }

  void buildTreeStructure({
    String? statusFilter,
    String? energySensorFilter,
    String? textSearch,
  }) {
    final nodes = getNodesFromAssets();
    Map<String, TreeNode> nodeMap = {for (var node in nodes) node.id: node};
    List<TreeNode> rootNodes = [];

    for (var node in nodes) {
      if (node.parentId == null && node.locationId == null) {
        rootNodes.add(node);
      }

      if (node.parentId != null) {
        if (nodeMap[node.parentId]?.children != null) {
          nodeMap[node.parentId]?.children?.add(node);
        } else {
          final parent = nodeMap[node.parentId!];
          nodeMap[node.parentId!] = TreeNode(
            name: parent!.name,
            id: parent.id,
            nodeType: parent.nodeType,
            parentId: parent.parentId,
            locationId: parent.locationId,
            sensorType: parent.sensorType,
            status: parent.status,
            children: [node],
          );
        }
      }

      if (node.locationId != null) {
        if (nodeMap[node.locationId]?.children != null) {
          nodeMap[node.locationId]?.children?.add(node);
        } else {
          final parent = nodeMap[node.locationId!];
          nodeMap[node.locationId!] = TreeNode(
            name: parent!.name,
            id: parent.id,
            nodeType: parent.nodeType,
            parentId: parent.parentId,
            locationId: parent.locationId,
            sensorType: parent.sensorType,
            status: parent.status,
            children: [node],
          );
        }
      }
    }

    getNodeChildren(
      rootNodes,
      nodeMap,
      statusFilter: statusFilter,
    );

    List<String> filters = [];

    if (statusFilter != null && statusFilter.isNotEmpty) {
      filters.add(statusFilter);
    }

    if (energySensorFilter != null && energySensorFilter.isNotEmpty) {
      filters.add(energySensorFilter);
    }

    if (filters.isNotEmpty || (textSearch != null && textSearch.isNotEmpty)) {
      var filteredNodes = <TreeNode>[];
      getFilteredNodes(
          filteredNodes, rootNodes, nodeMap, filters, textSearch ?? '');
      rootNodes = filteredNodes;
    }

    setState(() {
      treeView = rootNodes;
    });
  }

  void textFieldListener() {
    setState(() {
      textFieldSearch = textFieldController.value.text;
      Future.delayed(const Duration(milliseconds: 500), () {
        buildTreeStructure(
          statusFilter: statusFilter,
          energySensorFilter: energySensorFilter,
          textSearch: textFieldSearch,
        );
      });
    });
  }

  @override
  void initState() {
    buildTreeStructure();
    textFieldController.addListener(textFieldListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: textFieldController,
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (energySensorFilter.isEmpty) {
                          energySensorFilter = SensorType.energy.name;
                        } else {
                          energySensorFilter = '';
                        }
                      });
                      buildTreeStructure(
                        energySensorFilter: energySensorFilter,
                        statusFilter: statusFilter,
                        textSearch: textFieldSearch,
                      );
                    },
                    child: const Row(
                      children: [Text('Sensor de Energia')],
                    )),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (statusFilter.isEmpty) {
                          statusFilter = ComponentStatus.alert.name;
                        } else {
                          statusFilter = '';
                        }
                      });

                      buildTreeStructure(
                        statusFilter: statusFilter,
                        energySensorFilter: energySensorFilter,
                        textSearch: textFieldSearch,
                      );
                    },
                    child: const Row(
                      children: [Text('Crítico')],
                    )),
              ],
            ),
            Expanded(
              child: TreeView(
                nodes: treeView,
                statusFilter: statusFilter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
