#!/bin/bash

if [[ "${BASH_VERSION:0:1}" -lt 4 ]]; then
    echo "Required Bash 4.0 o greater to execute this script."
    exit 1
fi

DATA=$(cat <<EOF
#   SHARE   | AMOUNT | VALUE    | EXTRA BUY TAX
    IB.MC   | 1000   | 7800.10  | 10.00
EOF
)

str=""
resultGross="0"
resultNet="0"

atLeast2decs() {
    awk '{
        if (index($0, ".") > 0) {
            split($0, a, ".")
            if (length(a[2]) >= 2) 
                print $0
            else 
                print $0 "0"
        } else 
             print $0 ".00"
    }' | awk '{
        if (index($0, ".") == 1)
            print "0" $0
        else 
            print $0
    }'
}

colorAmount() { # params: amount, symbol, dontRound
    if [[ -z "$3" ]]; then
        res=$(printf "%.2f" "$1")  # Does not round!!
    else
        res=$1
    fi

    if (( $(echo "$res > 0" | bc) )); then
        echo "%{F#9acd32}+$res$2%{F-}"
    elif (( $(echo "$res < 0" | bc) )); then
        echo "%{F#ff4500}$res$2%{F-}"
    else
        echo "%{F#ffcb30}$res$2%{F-}"
    fi
}

brokerTax() {
    calc=$(echo "$1*0.001 + 3" | bc -l)
    if (( $(echo "$calc < 20" | bc -l) )); then
        echo "20.00"
    else
        echo "$calc"
    fi
}

spainTobinTax() {
    echo "$1*0.002" | bc -l
}

stateTax() {
    if (( $(echo "$1 > 50000" | bc -l) )); then
        echo "6000*0.19 + 44000*0.21 + ($1-50000)*0.23" | bc -l
    elif (( $(echo "$1 > 6000" | bc -l) )); then
        echo "6000*0.19 + ($1-6000)*0.21" | bc -l
    else
        echo "$1*0.19" | bc -l
    fi
}

declare -A stockValues

while IFS='|' read -r share rest; do
    [[ "$share" == \#* ]] && continue # Ignore header
    share=$(echo "$share" | xargs)

    [[ -v stockValues[$share] ]] && continue # Ignore duplications

    response=$(curl -s "https://query1.finance.yahoo.com/v8/finance/chart/$share")

    prevClose=$(echo "$response" | jq '.chart.result[0].meta.previousClose')
    stockValues[$share]=$(echo "$response" | jq '.chart.result[0].meta.regularMarketPrice' | atLeast2decs)

    diff=$(echo "${stockValues[$share]} - $prevClose" | bc -l | atLeast2decs)
    percentage=$(echo "($diff / $prevClose) * 100" | bc -l | atLeast2decs)

    if [[ "$str" != "" ]]; then
        str+=" %{F#777}|%{F-} "
    fi

    str+="$share ${stockValues[$share]}€ $(colorAmount $diff € 1) ($(colorAmount $percentage %))"

done <<< "$DATA"

while IFS='|' read -r share amount value extraTax; do
    [[ "$share" == \#* || -z "$amount" ]] && continue

    share=$(echo "$share" | xargs)
    amount=$(echo "$amount" | xargs)
    value=$(echo "$value" | xargs)
    extraTax=$(echo "$extraTax" | xargs)

    value=$(echo "$value * $amount" | bc -l)
    currentValue=$(echo "${stockValues[$share]} * $amount" | bc -l)

    buyValue=$(echo "$value + $(brokerTax $value) + $(spainTobinTax $value) + $extraTax" | bc -l)
    sellValue=$(echo "$currentValue - $(brokerTax $currentValue)" | bc -l)

    resultGross=$(echo "$resultGross + $currentValue - $buyValue" | bc -l)
    resultNet=$(echo "$resultNet + $sellValue - $buyValue" | bc -l)

done <<< "$DATA"


if [[ "$resultNet" != "0" ]]; then

    if (( $(echo "$resultNet > 0" | bc) )); then
        resultNet=$(echo "$resultNet - $(stateTax $resultNet)" | bc -l)
    fi

    str+=" %{F#777}|%{F-} $(colorAmount "$resultGross" €) ($(colorAmount "$resultNet" €))"
fi

echo "$str" | xargs