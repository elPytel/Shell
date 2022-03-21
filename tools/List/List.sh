#!/bin/bash
# By Pytel

declare -A List

List=(
    ["start_index"]='0'
    ["stop_index"]='0'
    # return lenght of list
    ["length"]='
    local len=$(( $(get $this.stop_index) - $(get $this.start_index) ));
    echo -e "$len";
        '
    # push item in list on position: 0/-1
    ["push"]='
    local position=-1;
    local item;
    local index;
    if [ "$#" -eq 0 ]; then return 1;
    elif [ "$#" -eq 2 ]; then
        position=$2;
    fi;
    item=$1;

    if [ "$position" -eq 0 ]; then
        index=$(get $this.start_index);
        $DEBUG && echo -e "$this.$index = $item";
        sat $this.$index = $item;
        sat $this.start_index = $(( index - 1 ));
    elif [ "$position" -eq -1 ]; then
        index=$(get $this.stop_index);
        $DEBUG && echo -e "$this.$index = $item";
        sat $this.$index = $item;
        sat $this.stop_index = $(( index + 1 ));
    fi;
    return 0;
        '
    ["pop"]='
    local position=-1;
    declare -n item;
    local index;
    if [ "$#" -eq 0 ]; then return 1;
    elif [ "$#" -eq 2 ]; then
        position=$2;
    fi;
    item=$1;

    if [ "$position" -eq 0 ]; then
        index=$(get $this.start_index);
        sat $this.start_index = $(( index + 1 ));
        item=$(get $this.$index);
        $DEBUG && echo -e "$this.$index = $item";
    elif [ "$position" -eq -1 ]; then
        index=$(get $this.stop_index);
        sat $this.stop_index = $(( index - 1 ));
        item=$(get $this.$index);
        $DEBUG && echo -e "$this.$index = $item";
    fi;
    $DEBUG && echo -e "Start: $(get $this.start_index), top: $(get $this.stop_index)";
    return 0;
    '
    [old]='
    echo -e "qrgv: $#";
    echo -e "args: $@";
    $DEBUG && echo -e "Position: $position";
    '
)

# END