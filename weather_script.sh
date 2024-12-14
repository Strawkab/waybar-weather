#!/usr/bin/env bash
for i in {1..5}; do
    input=$(curl -s "wttr.in/$1?format=j2")
    if [[ $? == 0 ]]; then
        alt=$(curl -s "wttr.in/$1?format=%x\n")
        if [[ $? == 0 ]]; then
            text=$(echo $input | jq '.current_condition | .[].temp_C')
            tooltip=$(echo $input | jq '.current_condition | .[].weatherDesc | .[].value')
            sunrise=$(echo $input | jq ".weather.[0].astronomy.[].sunrise" | tr -d '"')
            sunrise=$(date -d "$sunrise" +'%k%M')
            sunset=$(echo $input | jq ".weather.[0].astronomy.[].sunset" | tr -d '"')
            sunset=$(date -d "$sunset" +'%k%M')
            current_time=$(date +'%k%M')
            if [ "${current_time}" -ge "${sunrise}" -a "${current_time}" -lt "${sunset}" ]; then
                daytime=100
            else
                daytime=0
            fi
            echo "{\"text\":$text, \"alt\":\"$alt\", \"tooltip\":$tooltip, \"percentage\":$daytime}"
            exit
        fi
    fi
    sleep 2
done
echo "{\"text\":\"error\", \"tooltip\":\"error\"}"
