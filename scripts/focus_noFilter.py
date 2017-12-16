#!/bin/python

import i3
from subprocess import check_output
import json

def findWindow(container):
    if container['nodes'] == []:
        if container['focused'] == True:
            return container
        else: return None
    for con in container['nodes']:
        win = findWindow(con)
        if win != None: return win
    for con in container['floating_nodes']:
        win = findWindow(con)
        if win != None: return win

def find_tmp(container):
    if container['nodes'] == []:
        if container['window'] == None and container['name'] == None:
            return container['id']
        else: return None
    for con in container['nodes']:
        tmp = find_tmp(con)
        if tmp != None: return tmp

def create_tmp(current_id):
    i3.focus(con_id=current_id)
    i3.split('vertical')
    i3.open()

def destroy_tmp(tmp_id):
    i3.kill(con_id=tmp_id)

def make_float(current_id):
    i3.focus(con_id=current_id)
    i3.floating('enable')
    i3.resize('set 1000 1000')
    i3.move('position center')

def make_unfloat(current_id):
    i3.focus(con_id=current_id)
    i3.floating('disable')

def main():
    tree = check_output(['i3-msg', '-t', 'get_tree']).decode('UTF-8').strip()
    root = json.loads(tree)
    current = findWindow(root)
    current_id = current['id']
    if "on" in current['floating']:
        tmp_id = find_tmp(root)
        if tmp_id != None:
            i3.focus(con_id=tmp_id)
            make_unfloat(current_id)
            destroy_tmp(tmp_id)
        else:
            make_unfloat()
    else:
        if find_tmp(root) == None:
            create_tmp(current_id)
            make_float(current_id)


main()
