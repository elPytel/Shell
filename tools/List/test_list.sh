#!/bin/bash
# By Pytel

source ../class/class.sh
source ./List.sh

DEBUG=true
#DEBUG=false

function test_create_and_delete () {
    $DEBUG && echo -e "\nDelete:"
	
	new instance = List
    delete instance
	
	if [ -z ${instance+x} ]; then 
		$DEBUG && echo "var is unset"
	else 
		echo "ERROR: var is set!"
		return 1
	fi
	return 0
}

function test_create_empty () {
    new list = List
    $DEBUG && echo -e "Func: $(get list.length)"
    $DEBUG && echo -e "Lenght: $(rof list.length)"
    if [ -z "$(rof list.length)" ]; then
        echo -e "ERROR: no lenght!"
        return 1
    fi
    if [ "$(rof list.length)" -ne 0 ]; then
        echo -e "ERROR: invalid lenght!"
        return 2
    fi
    delete list
    return 0
}

function test_push_empty () {
    new list = List
    rof list.push
    ret=$?
    delete list
    if [ $ret -ne 1 ]; then 
        echo -e "ERROR: invalid return value: $ret !"
        return 1; 
    fi;
    return 0
}

function test_push_with_position () {
    new list = List
    rof list.push 42 0
    $DEBUG && echo -e "Lenght: $(rof list.length)"
    if [ "$(rof list.length)" -ne 1 ]; then
        echo -e "ERROR: invalid lenght!"
        return 1
    fi
    delete list
    return 0
}

function test_push () {
    new list = List
    rof list.push "42"
    $DEBUG && echo -e "Lenght: $(rof list.length)"
    if [ "$(rof list.length)" -ne 1 ]; then
        echo -e "ERROR: invalid lenght!"
        return 1
    fi
    delete list
    return 0
}

function test_pop_with_position () {
    new list = List
    value="42"
    rof list.push $value
    rof list.pop item 0
    $DEBUG && echo -e "Lenght: $(rof list.length)"
    if [ "$(rof list.length)" -ne 0 ]; then
        echo -e "ERROR: invalid lenght: $lenght !"
        return 1
    fi
    if [ $item -ne $value ]; then
        echo -e "ERROR: invalid value: $item !"
        return 2
    fi
    delete list
    return 0
}

function test_pop () {
    new list = List
    value="42"
    rof list.push $value
    rof list.pop item 0
    $DEBUG && echo -e "Lenght: $(rof list.length)"
    if [ "$(rof list.length)" -ne 0 ]; then
        echo -e "ERROR: invalid lenght: $lenght !"
        return 1
    fi
    if [ $item -ne $value ]; then
        echo -e "ERROR: invalid value: $item !"
        return 2
    fi
    delete list
    return 0
}

function test_push_pop_push_pop () {
    new list = List
    value="42"
    rof list.push $value
    rof list.pop item 0
    $DEBUG && echo -e "Lenght: $(rof list.length)"
    if [ "$(rof list.length)" -ne 0 ]; then
        echo -e "ERROR: invalid lenght: $lenght !"
        return 1
    fi
    if [ $item -ne $value ]; then
        echo -e "ERROR: invalid value: $item !"
        return 2
    fi

    value="14"
    rof list.push $value
    rof list.pop item 0
    $DEBUG && echo -e "Lenght: $(rof list.length)"
    if [ "$(rof list.length)" -ne 0 ]; then
        echo -e "ERROR: invalid lenght: $lenght !"
        return 1
    fi
    if [ $item -ne $value ]; then
        echo -e "ERROR: invalid value: $item !"
        return 2
    fi
    delete list
    return 0
}

function test_pushs_pops () {
    new list = List
    values=("42" "123" "-10")
    $DEBUG && echo -e "Values: ${values[@]}"
    for value in ${values[@]}; do
        $DEBUG && echo -e "Value: $value"
        rof list.push $value
    done
    $DEBUG && echo -e "Lenght: $(rof list.length)"
    if [ "$(rof list.length)" -ne "${#values[@]}" ]; then
        echo -e "ERROR: invalid full lenght: $lenght !"
        return 1
    fi
    for value in ${values[@]}; do
        rof list.pop item 0
        if [ $item -ne $value ]; then
            echo -e "ERROR: invalid value: $item !"
            return 2
        fi
    done
    if [ "$(rof list.length)" -ne 0 ]; then
        echo -e "ERROR: invalid empty lenght: $lenght !"
        return 3
    fi
    delete list
    return 0
}

# END