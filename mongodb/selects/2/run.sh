#!/bin/bash

echo -n "" > "time.txt"
echo -n "" > "result.txt"

COUNTERVAR=1
while [ $COUNTERVAR -lt 4 ]; do
	COUNTERTEST=1
	SUM=0
	echo "CONSULTA $COUNTERVAR" >> "time.txt"
	echo "__________________________________________________________________________" >> "time.txt"
	while [ $COUNTERTEST -lt 30 ]; do
		START=$(date +%s.%N)
		mongo < "query_$COUNTERVAR.js" >> "out.txt";
		END=$(date +%s.%N)
		DIFF=$(echo "$END - $START" | bc)
		SUM=$(echo "$SUM + $DIFF" | bc)
		echo $DIFF >> "time.txt"
		let COUNTERTEST=COUNTERTEST+1
	done
	echo "*************************************************************************" >> "time.txt"
	let COUNTERTEST=COUNTERTEST-1
	PROM=$(echo "scale=2; $SUM/$COUNTERTEST" | bc)
	echo "NÚMERO DE PRUEBAS: $COUNTERTEST | TIEMPO TOTAL: $SUM | PROMEDIO: $PROM" >> "time.txt"
	echo "*************************************************************************" >> "time.txt"
    let COUNTERVAR=COUNTERVAR+1 
done
