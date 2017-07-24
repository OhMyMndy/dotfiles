#!/usr/bin/env python3

# pylint: disable=invalid-name

# based on https://github.com/bamos/zsh-history-analysis
import argparse
import os
import sys
import time
from itertools import groupby
from collections import Counter, defaultdict
from typing import Dict, Tuple, List
# import statistics

def group_by_key(input_value):
    """
    group dictionary by key
    """
    grouped_m = defaultdict(list)
    for k, value in input_value:
        grouped_m[k].append(value)
    return grouped_m

class Command:
    """
    class Command
    """
    def __init__(self, raw):
        tup = raw.split(";")
        # TODO: Should this be hard-coded?
        self.timestamp_epoch = int(tup[0][2:-2].split(':')[0])
        self.timestamp_struct = time.gmtime(self.timestamp_epoch)
        self.full_command = tup[1].strip()
        self.base_command = tup[1].split()[0]

class HistoryData:
    """
    class HistoryData
    """
    def __init__(self, filenames):
        if isinstance(filenames, str):
            filenames = [filenames]
        commands = []
        for filename in filenames:
            with open(filename, 'rb') as f:
                it = iter(f)
                for line in it:
                    try:
                        full_line = line.decode()
                        while full_line.strip()[-1] == '\\':
                            full_line += next(it).decode()
                        commands.append(Command(full_line))
                    except Exception as ex:
                        # print("Warning: Exception parsing.")i
                        # print(ex)
                        pass

        self.commands = commands

    def get_commands(self) -> List[Command]:
        return self.commands

    def get_full_commands(self) -> List[str]:
        """
        gets all the base commands
        """
        return [cmd.full_command for cmd in self.commands]

    def get_base_commands(self) -> List[str]:
        """
        gets all the base commands
        """
        return [cmd.base_command for cmd in self.commands]

    def get_top_commands(self, amount=10, full=False) -> List[Tuple[str, int]]:
        """
        get all the top commands
        """
        if full:
            cmds = self.get_base_commands()
        else:
            cmds = self.get_full_commands()
        return Counter(cmds).most_common(amount, )




history_file = "/home/mandy/.zhistory"

history_data = HistoryData(history_file)

cmd = history_data.get_commands()[0]


for (command, amount) in history_data.get_top_commands():
    print("command %s amount %s" % (command, amount))

print(history_data.get_top_commands())

print(history_data.get_top_commands(full=True))
