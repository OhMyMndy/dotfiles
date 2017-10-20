#!/usr/bin/env node

var containers = process.argv.slice(2)

if (!containers) {
    throw new Error("No containers provided")
}

var blessed = require('blessed')
var contrib = require('blessed-contrib')

var screen = blessed.screen({
  smartCSR: true,
  fullUnicode: true,
  dockBorders: true,
  ignoreDockContrast: true
})

screen.key(['escape', 'q', 'C-c'], function(ch, key) {
	return process.exit(0)
});

function getMethods(obj)
{
    var res = [];
    for(var m in obj) {
        if(typeof obj[m] == "function") {
            res.push(m)
        }
    }
    return res;
}

var grid = new contrib.grid({rows: 12, cols: 12, screen: screen})

//grid.set(row, col, rowSpan, colSpan, obj, opts)
//  args: ["docker logs web56_php_1 --tail 20 -f"],
var terminals = {}
var i = 0
rowSpan = Math.round(containers.length / 2)
for (container in containers) {
    container = containers[container]
    var row, col, rowSpan, colSpan;
//    rowSpan = 4
    colSpan = 6
    if (i == 0) {
        row = 0
        col = 0
    } else if (i % 1 == 0 ) {
        row = rowSpan * (2 *  Math.floor(Math.round((i - 1) / 2)))
        col = colSpan * (2 *  Math.floor(Math.round((i - 0) / 2)))
    } else if (i % 2 == 0) {
        row = rowSpan * (i - 0)
        col = colSpan * (i - 0)
    }


    terminals[container] = grid.set(row, col, rowSpan, colSpan, blessed.terminal, {label: "Log for " + i + container, parent: screen, shell: '/bin/bash', args: ['-c', [ 'docker logs ' + container + ' --tail 20 -f'] ]})
    i++
}
//term1.term.reset()
//term1.term.open('docker logs web56_php_1 --tail 20 -f')
//console.log(getMethods(term1.term));
//process.exit(1)

//term1.term.write("docker logs web56_php_1 --tail 20 -f\n")
// var box = grid.set(4, 4, 4, 4, contrib.terminal, {label: "Php", args: "docker logs web56_mysql_1 --tail 20 -f"})

screen.render()