var roleBuilder = {
    run: function(screep)
    {
        var Coop = screep.memory.companion;
        var target = screep.pos.findClosestByRange(FIND_CONSTRUCTION_SITES);
        var hubs = screep.room.find(FIND_STRUCTURES,
        {
            filter: (structure) =>
            {
                return (structure.structureType == STRUCTURE_CONTAINER) && structure.energy > 0;
            }
        });
        
        if (!(screep.memory.building) && (screep.carry.energy > 0) && (target))
        {
            screep.memory.building = true;
        }
        
        if (screep.pos.isNearTo(Game.creeps[Coop]))
        {
            screep.pickup(screep.pos.findClosestByRange(FIND_DROPPED_RESOURCES));
        }
        if (screep.memory.building)
        {
            if (screep.build(target) == ERR_NOT_IN_RANGE)
            {
                screep.moveTo(target);
            }
            if (screep.carry.energy == 0)
            {
                screep.memory.building = false;
            }
        }
    }
}

module.exports = roleBuilder;
