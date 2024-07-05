import 'package:flutter/material.dart';
import 'package:flutter_challenge_tractian/models/tree_node.dart';

const locationIcon =
    Image(image: AssetImage('assets/images/location_icon.png'));
const assetIcon = Image(image: AssetImage('assets/images/asset_icon.png'));
const componentIcon =
    Image(image: AssetImage('assets/images/component_icon.png'));

class NodeWidget extends StatefulWidget {
  final TreeNode node;

  const NodeWidget({required this.node, super.key});

  @override
  State<NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  bool get hasChildren => widget.node.children != null;
  bool showChildren = true;

  @override
  Widget build(BuildContext context) {
    final alertIcon = Container(
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(50),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: hasChildren
                ? () {
                    setState(() {
                      showChildren = !showChildren;
                    });
                  }
                : null,
            child: Row(
              children: [
                if (hasChildren) ...[
                  const Icon(
                    Icons.arrow_downward,
                    size: 18,
                  ),
                ] else ...[
                  const SizedBox(width: 18)
                ],
                if (widget.node.nodeType == NodeType.location.name) ...[
                  locationIcon,
                ] else if (widget.node.nodeType == NodeType.asset.name) ...[
                  assetIcon,
                ] else if (widget.node.nodeType == NodeType.component.name) ...[
                  componentIcon,
                ],
                Text(
                  widget.node.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (widget.node.sensorType == SensorType.energy.name) ...[
                  const Icon(Icons.bolt, color: Colors.green)
                ],
                if (widget.node.status == ComponentStatus.alert.name) ...[
                  alertIcon,
                ]
              ],
            ),
          ),
          if (widget.node.children != null) ...[
            Visibility(
              visible: showChildren,
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: widget.node.children!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return NodeWidget(
                        node: widget.node.children![index],
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ],
      ),
    );
  }
}
