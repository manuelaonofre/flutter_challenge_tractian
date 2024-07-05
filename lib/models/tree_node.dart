enum NodeType { asset, location, component }

enum SensorType { vibration, energy }

enum ComponentStatus { alert, operating }

class TreeNode {
  final String name;
  final String id;
  final String? nodeType;
  final String? parentId;
  final String? locationId;
  final String? sensorType;
  final String? status;
  final List<TreeNode>? children;

  TreeNode({
    required this.name,
    required this.id,
    this.nodeType,
    this.parentId,
    this.locationId,
    this.sensorType,
    this.status,
    this.children,
  });

  factory TreeNode.fromJson(Map<String, dynamic> json) {
    var childrenList = <TreeNode>[];
    var nodeTypeString = '';
    // List<TreeNode> childrenList =
    //     childrenJson.map((childJson) => TreeNode.fromJson(childJson)).toList();

    return TreeNode(
      name: json['name'],
      id: json['id'],
      parentId: json['parentId'],
      locationId: json['locationId'],
      sensorType: json['sensorType'],
      status: json['status'],
      nodeType: nodeTypeString,
      children: childrenList,
    );
  }
}
