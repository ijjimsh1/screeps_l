//console.log('1');
//creep.moveTo(target, {visualizePathStyle: {stroke: '#FFD700'}});

var AutoSpawn = require('AutoSpawn');
var roleHarvester = require('role.harvester');
var roleKSM = require('role.KSM');
var roleBuilder = require('role.builder');

if (Game.time == 0)
{
    Memory.rooms.FreeUnit = 'None';
    var SourcesCopy = Game.spawns['Spawn1'].room.find(FIND_SOURCES);
    var kar = SourcesCopy.length;
    Memory.rooms.Sources = [];
    for (let i = 0; i < kar; i++)
    {
        var Chtoto = Game.spawns['Spawn1'].pos.findClosestByPath(SourcesCopy);
        Memory.rooms.Sources.push(Chtoto);
        Memory.rooms.Sources[i].outpoot = Math.floor(Memory.rooms.Sources[i].energy / 300);
        SourcesCopy.splice(SourcesCopy.indexOf(Chtoto), 1);
        Memory.rooms.Sources[i].freeSpace = 5;                           // Потом необходимо будем автоматизировать к-ство доступных для длбычи клеток  !!!
    }
}

module.exports.loop = function () 
{
    for (let i = 0; i < Memory.rooms.Sources.length; i++)
    {
        Memory.rooms.Sources[i].outpoot = Math.floor(Memory.rooms.Sources[i].energy / 300);
        Memory.rooms.Sources[i].space = 0;
    }
    
    var harvesters = _.filter(Game.creeps, (creep) => creep.memory.role == 'harvester');
    var KSMs = _.filter(Game.creeps, (creep) => creep.memory.role == 'KSM');
    var builders = _.filter(Game.creeps, (creep) => creep.memory.role == 'builder');
    
    
    
    for(var name in Memory.creeps)          // Удалем из Memory мертвых крепышей    и   Подключаем модули с шаблонами поведения для каждой роли
    {
        if(!Game.creeps[name])
        {
             delete Memory.creeps[name];
        }
        else
        {
            if (Game.creeps[name].memory.companion == 'None')
            {
                Memory.rooms.FreeUnit = name;
            }
            if (Game.creeps[name].memory.role == 'harvester')
            {
                roleHarvester.run(Game.creeps[name]);
                for (let i = 0; i < Memory.rooms.Sources.length; i++)
                {
                    if (Memory.rooms.Sources[i].id == Game.creeps[name].memory.job)
                    {
                        Memory.rooms.Sources[i].space += 1;
                        Memory.rooms.Sources[i].outpoot -= 2*Game.creeps[name].getActiveBodyparts('work');
                        break;
                    }
                }
            }
            if (Game.creeps[name].memory.role == 'KSM')
            {
                if (Game.creeps[name].memory.goal == 'None')
                {
                    Memory.rooms.FreeUnit = name;
                }
                roleKSM.run(Game.creeps[name]);
            }
            if (Game.creeps[name].memory.role == 'builder')
            {
                roleBuilder.run(Game.creeps[name]);
            }
        }
    }
    
    
    
    if ((Memory.rooms.FreeUnit != 'None') && (Game.creeps[Memory.rooms.FreeUnit].memory.role != 'KSM')) && (Game.spawns['Spawn1'].room.energyAvailable == Memory.spawns.KSMBODYenergy))
    {
        AutoSpawn.run('KSM');
    }
    else
    {
        if ((Memory.rooms.FreeUnit != 'None' ) && (Game.creeps[Memory.rooms.FreeUnit].memory.role == 'KSM') && (Game.spawns['Spawn1'].room.energyAvailable == Memory.spawns.builderBODYenergy)) 
        {
            AutoSpawn.run('builder');
        }
        for (let i = 0; i < Memory.rooms.Sources.length; i++)
        {
            if ((Memory.rooms.Sources[i].outpoot != 0) && (Game.spawns['Spawn1'].room.energyAvailable >= Memory.spawns.harvestBODYenergy) && (Memory.rooms.Sources[i].freeSpace > Memory.rooms.Sources[i].space)) 
            {
                AutoSpawn.run('harvester', i);
                break;
            }
        }
    }
}

