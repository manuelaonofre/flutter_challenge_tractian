import 'package:flutter/material.dart';
import 'package:flutter_challenge_tractian/models/tree_node.dart';
import 'package:flutter_challenge_tractian/screens/AssetScreen/components/node_widget.dart';

class TreeView extends StatelessWidget {
  final List<TreeNode> nodes;
  final String statusFilter;

  TreeView({
    required this.nodes,
    required this.statusFilter,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        return NodeWidget(node: nodes[index]);
      },
    );
  }
}
