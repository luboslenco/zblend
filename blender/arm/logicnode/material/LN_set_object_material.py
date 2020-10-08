from arm.logicnode.arm_nodes import *

class SetMaterialSlotNode(ArmLogicTreeNode):
    """Sets the material of the given object."""
    bl_idname = 'LNSetMaterialSlotNode'
    bl_label = 'Set Object Material'
    arm_version = 1

    def init(self, context):
        super(SetMaterialSlotNode, self).init(context)
        self.add_input('ArmNodeSocketAction', 'In')
        self.add_input('ArmNodeSocketObject', 'Object')
        self.add_input('NodeSocketShader', 'Material')
        self.add_input('NodeSocketInt', 'Slot')
        self.add_output('ArmNodeSocketAction', 'Out')

add_node(SetMaterialSlotNode, category=PKG_AS_CATEGORY)
