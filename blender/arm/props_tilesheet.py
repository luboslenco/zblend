import bpy
from bpy.props import *

class ArmTilesheetActionListItem(bpy.types.PropertyGroup):
    name: StringProperty(
        name="Name",
        description="A name for this action",
        default="Untitled")

    # GRID action properties

    start_prop: IntProperty(
        name="Start",
        description="The start frame index for this action",
        default=0)

    end_prop: IntProperty(
        name="End",
        description="The end frame index for this action",
        default=0)

    loop_prop: BoolProperty(
        name="Loop",
        description="Whether this action loops or not",
        default=True)

    # SPARROW action properties

    prefix_prop: StringProperty(
        name="Prefix",
        description="An animation prefix for this action")

class ARM_UL_TilesheetActionList(bpy.types.UIList):
    def draw_item(self, context, layout, data, item, icon, active_data, active_propname, index):
        # We could write some code to decide which icon to use here...
        custom_icon = 'OBJECT_DATAMODE'

        # Make sure your code supports all 3 layout types
        if self.layout_type in {'DEFAULT', 'COMPACT'}:
            layout.prop(item, "name", text="", emboss=False, icon=custom_icon)

        elif self.layout_type in {'GRID'}:
            layout.alignment = 'CENTER'
            layout.label(text="", icon = custom_icon)

class ArmTilesheetActionListNewItem(bpy.types.Operator):
    # Add a new item to the list
    bl_idname = "arm_tilesheetactionlist.new_item"
    bl_label = "Add a new item"

    def execute(self, context):
        wrd = bpy.data.worlds['Arm']
        trait = wrd.arm_tilesheetlist[wrd.arm_tilesheetlist_index]
        trait.arm_tilesheetactionlist.add()
        trait.arm_tilesheetactionlist_index = len(trait.arm_tilesheetactionlist) - 1
        return{'FINISHED'}

class ArmTilesheetActionListDeleteItem(bpy.types.Operator):
    """Delete the selected item from the list"""
    bl_idname = "arm_tilesheetactionlist.delete_item"
    bl_label = "Deletes an item"

    @classmethod
    def poll(self, context):
        """Enable if there's something in the list"""
        wrd = bpy.data.worlds['Arm']
        if len(wrd.arm_tilesheetlist) == 0:
            return False
        trait = wrd.arm_tilesheetlist[wrd.arm_tilesheetlist_index]
        return len(trait.arm_tilesheetactionlist) > 0

    def execute(self, context):
        wrd = bpy.data.worlds['Arm']
        trait = wrd.arm_tilesheetlist[wrd.arm_tilesheetlist_index]
        list = trait.arm_tilesheetactionlist
        index = trait.arm_tilesheetactionlist_index

        list.remove(index)

        if index > 0:
            index = index - 1

        trait.arm_tilesheetactionlist_index = index
        return{'FINISHED'}

class ArmTilesheetActionListMoveItem(bpy.types.Operator):
    """Move an item in the list"""
    bl_idname = "arm_tilesheetactionlist.move_item"
    bl_label = "Move an item in the list"
    bl_options = {'INTERNAL'}

    direction: EnumProperty(
        items=(
            ('UP', 'Up', ""),
            ('DOWN', 'Down', "")
        ))

    @classmethod
    def poll(self, context):
        """Enable if there's something in the list"""
        wrd = bpy.data.worlds['Arm']
        if len(wrd.arm_tilesheetlist) == 0:
            return False
        trait = wrd.arm_tilesheetlist[wrd.arm_tilesheetlist_index]
        return len(trait.arm_tilesheetactionlist) > 0

    def move_index(self):
        # Move index of an item render queue while clamping it
        wrd = bpy.data.worlds['Arm']
        trait = wrd.arm_tilesheetlist[wrd.arm_tilesheetlist_index]
        index = trait.arm_tilesheetactionlist_index
        list_length = len(trait.arm_tilesheetactionlist) - 1
        new_index = 0

        if self.direction == 'UP':
            new_index = index - 1
        elif self.direction == 'DOWN':
            new_index = index + 1

        new_index = max(0, min(new_index, list_length))
        trait.arm_tilesheetactionlist.move(index, new_index)
        trait.arm_tilesheetactionlist_index = new_index

    def execute(self, context):
        wrd = bpy.data.worlds['Arm']
        trait = wrd.arm_tilesheetlist[wrd.arm_tilesheetlist_index]
        list = trait.arm_tilesheetactionlist
        index = trait.arm_tilesheetactionlist_index

        if self.direction == 'DOWN':
            neighbor = index + 1
            self.move_index()

        elif self.direction == 'UP':
            neighbor = index - 1
            self.move_index()
        else:
            return{'CANCELLED'}
        return{'FINISHED'}

class ArmTilesheetListItem(bpy.types.PropertyGroup):
    name: StringProperty(
        name="Name",
        description="A name for this item",
        default="Untitled")

    format_prop: EnumProperty(
        name="Format",
        description="The format to use for the tilesheet",
        items=(
            ('GRID', 'Grid', ""),
            ('SPARROW', 'Sparrow', "")
        ),
        default="GRID")

    # GRID format

    tilesx_prop: IntProperty(
        name="Tiles X",
        description="The grid width of the tilesheet in tiles",
        default=0)

    tilesy_prop: IntProperty(
        name="Tiles Y",
        description="The grid height of the tilesheet in tiles",
        default=0)

    framerate_prop: FloatProperty(
        name="Frame Rate",
        description="The framerate of the tilesheet",
        default=4.0)

    # SPARROW format

    atlas_file_prop: StringProperty(
        name = "Atlas File",
        description = "A path to an XML file describing the Sparrow spritesheet",
        subtype = "FILE_PATH")

    arm_tilesheetactionlist: CollectionProperty(type=ArmTilesheetActionListItem)
    arm_tilesheetactionlist_index: IntProperty(name="Index for arm_tilesheetactionlist", default=0)

class ARM_UL_TilesheetList(bpy.types.UIList):
    def draw_item(self, context, layout, data, item, icon, active_data, active_propname, index):
        # We could write some code to decide which icon to use here...
        custom_icon = 'OBJECT_DATAMODE'

        # Make sure your code supports all 3 layout types
        if self.layout_type in {'DEFAULT', 'COMPACT'}:
            layout.prop(item, "name", text="", emboss=False, icon=custom_icon)

        elif self.layout_type in {'GRID'}:
            layout.alignment = 'CENTER'
            layout.label(text="", icon=custom_icon)

class ArmTilesheetListNewItem(bpy.types.Operator):
    """Add a new item to the list"""
    bl_idname = "arm_tilesheetlist.new_item"
    bl_label = "Add a new item"

    def execute(self, context):
        wrd = bpy.data.worlds['Arm']
        wrd.arm_tilesheetlist.add()
        wrd.arm_tilesheetlist_index = len(wrd.arm_tilesheetlist) - 1
        return{'FINISHED'}

class ArmTilesheetListDeleteItem(bpy.types.Operator):
    """Delete the selected item from the list"""
    bl_idname = "arm_tilesheetlist.delete_item"
    bl_label = "Deletes an item"

    @classmethod
    def poll(self, context):
        """ Enable if there's something in the list """
        wrd = bpy.data.worlds['Arm']
        return len(wrd.arm_tilesheetlist) > 0

    def execute(self, context):
        wrd = bpy.data.worlds['Arm']
        list = wrd.arm_tilesheetlist
        index = wrd.arm_tilesheetlist_index

        list.remove(index)

        if index > 0:
            index = index - 1

        wrd.arm_tilesheetlist_index = index
        return{'FINISHED'}

class ArmTilesheetListMoveItem(bpy.types.Operator):
    """Move an item in the list"""
    bl_idname = "arm_tilesheetlist.move_item"
    bl_label = "Move an item in the list"
    bl_options = {'INTERNAL'}

    direction: EnumProperty(
        items=(
            ('UP', 'Up', ""),
            ('DOWN', 'Down', "")
        ))

    @classmethod
    def poll(self, context):
        """ Enable if there's something in the list. """
        wrd = bpy.data.worlds['Arm']
        return len(wrd.arm_tilesheetlist) > 0

    def move_index(self):
        # Move index of an item render queue while clamping it
        wrd = bpy.data.worlds['Arm']
        index = wrd.arm_tilesheetlist_index
        list_length = len(wrd.arm_tilesheetlist) - 1
        new_index = 0

        if self.direction == 'UP':
            new_index = index - 1
        elif self.direction == 'DOWN':
            new_index = index + 1

        new_index = max(0, min(new_index, list_length))
        wrd.arm_tilesheetlist.move(index, new_index)
        wrd.arm_tilesheetlist_index = new_index

    def execute(self, context):
        wrd = bpy.data.worlds['Arm']
        list = wrd.arm_tilesheetlist
        index = wrd.arm_tilesheetlist_index

        if self.direction == 'DOWN':
            neighbor = index + 1
            self.move_index()

        elif self.direction == 'UP':
            neighbor = index - 1
            self.move_index()
        else:
            return{'CANCELLED'}
        return{'FINISHED'}


__REG_CLASSES = (
    ArmTilesheetActionListItem,
    ARM_UL_TilesheetActionList,
    ArmTilesheetActionListNewItem,
    ArmTilesheetActionListDeleteItem,
    ArmTilesheetActionListMoveItem,

    ArmTilesheetListItem,
    ARM_UL_TilesheetList,
    ArmTilesheetListNewItem,
    ArmTilesheetListDeleteItem,
    ArmTilesheetListMoveItem,
)
__reg_classes, unregister = bpy.utils.register_classes_factory(__REG_CLASSES)


def register():
    __reg_classes()

    bpy.types.World.arm_tilesheetlist = CollectionProperty(type=ArmTilesheetListItem)
    bpy.types.World.arm_tilesheetlist_index = IntProperty(name="Index for arm_tilesheetlist", default=0)
