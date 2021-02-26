led_OFF="gpio"
led_ON="default-on"
led_state=${led_OFF}
log="/var/log/althea_jailed.log"
validator_key_name=""
validator_cosmovaloper="cosmosvaloper....."
validator=""
althea="/usr/bin/althea-arm"
unjailme="/home/ubuntu/bin/unjailme.exp"
password=""


function  check0 {
    "${althea}" query staking validator "${validator_cosmovaloper}"|egrep '^jail'|cut -d' ' -f2
}

state=0
unjailing_attempted=0

## unjailed should be `false`
## when check0 is not false, set state to 1, signifying error.
[[ $(check0) == "false" ]] || state=1;

## log the jailing time, if state = 1
[[ "${state}" -eq 1 ]] && echo "`date`: jailed" >> "${log}"
[[ "${state}" -eq 1 ]] || echo "`date`: active" >> "${log}"

## try to unjail me with `expect` script
[[ "${state}" -eq 1 ]] && echo "    -- Attempting to unjail" >> "${log}"
[[ "${state}" -eq 1 ]] && ${unjailme} ${validator_key_name} althea-testnet1v2 ${password}
[[ "${state}" -eq 1 ]] && unjailing_attempted=1
[[ "${state}" -eq 1 ]] && sleep 60
[[ "${state}" -eq 1 ]] && ([[ $(check0) == "true" ]] || state=0)
[[ "${state}" -eq 1 ]] && echo "    -- still jailed" >> "${log}"
[[ "${state}" -eq 0 ]] && [[ "${unjailing_attempted}" -eq 1 ]] && echo "    -- successfully unjailed" >> "${log}"


## maybe set the LED 
## [[ "${state}" -eq 1 ]] && led_state=${led_ON}
##echo "${led_state}" > /sys/class/leds/led1/trigger
