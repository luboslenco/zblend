from arm.logicnode.arm_nodes import *


class CanvasGetRotationNode(ArmLogicTreeNode):
    """Returns the rotation of the given UI element."""
    bl_idname = 'LNCanvasGetRotationNode'
    bl_label = 'Get Canvas Rotation'
    arm_section = 'elements_general'
    arm_version = 1

    def arm_init(self, context):
        self.add_input('ArmNodeSocketAction', 'In')
        self.add_input('ArmStringSocket', 'Element')

        self.add_output('ArmNodeSocketAction', 'Out')
        self.add_output('ArmFloatSocket', 'Rad')
