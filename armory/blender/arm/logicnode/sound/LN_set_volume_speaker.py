from arm.logicnode.arm_nodes import *

class SetVolumeSoundNode(ArmLogicTreeNode):
    """sets volume of the given speaker object.

    @seeNode Play Speaker
    @seeNode Stop Speaker
    """
    bl_idname = 'LNSetVolumeSoundNode'
    bl_label = 'Set Volume Speaker'
    arm_version = 1

    def arm_init(self, context):
        self.add_input('ArmNodeSocketAction', 'In')
        self.add_input('ArmNodeSocketObject', 'Speaker')
        self.add_input('ArmFloatSocket', 'Volume')

        self.add_output('ArmNodeSocketAction', 'Out')
