DEVICENAME="cu.usbmodemDEADC0DE1"
OUTPUT="/dev/${DEVICENAME}"
APIURL="http://unopenedbox.com/develop/omok/api.php"
i=0
tick=0

function Splash(){
	echo "showing splash screen..."
	clearScreen
	setWriteMode
	 
 echo "Success."> ${OUTPUT}
 sleep 1
  echo "Waiting Server..."> ${OUTPUT}
  sleep 1
}

function setWriteMode(){
	echo "set to write mode (value)."
	echo "'1" > ${OUTPUT}

}

function clearScreen(){
	echo "Clearing screen."
   echo "'4" > ${OUTPUT}

	sleep 3
}

function checkServerConnection(){
	setWriteMode
	echo "Checking connection to server ${APIURL}"
	echo "ServerCoreVersion:" > ${OUTPUT}
	sleep 1
  curl ${APIURL}?a=CoreVersion > ${OUTPUT}
}

function prnt(){
	setWriteMode
	echo $1 > ${OUTPUT}
	sleep 0.5
}

function enter(){
	echo "'5" > ${OUTPUT}
}

function senddol(){
	echo "senddol : '7$1"
	echo "'7$1" > ${OUTPUT}
	echo "'7$1" > ${OUTPUT}
}

function showMap(){
	echo "'8" > ${OUTPUT}
	sleep 5
}

function startGame(){

	echo "Starting Game..."
echo "'9" > ${OUTPUT}
sleep 5
	setWriteMode
prnt "Omok "
curl ${APIURL}?a=CoreVersion > ${OUTPUT}
echo "Asking to server about game status..."
enter
prnt "Waiting... "
findGame
}

function findGame(){
	echo "Trying to find an available game..."
result="$(curl ${APIURL}?a=omok_tick&tick=1)"
echo "${result}"
vStr=$(echo "${result}" | cut -d'/' -f1)
if [ "${vStr}" != "1" ]
then
	prnt "."
	sleep 3
	findGame 
else
	echo "Found a available game."
prnt "Connected."
loadGame

fi
}


function loadGame(){
	showMap
	i=1
}

echo "LPC 1768 Communicator"
echo "(C) 2019 JHRunning"
echo "============================================="

echo "Device Name : ${DEVICENAME}"
echo "API URL : ${APIURL}"
echo "Connecting via USB..."
Splash
checkServerConnection
startGame






while [ $i -eq 1 ]

do
	echo "InGame Progress... Tick : ${tick}"
result=$(curl ${APIURL}?a=omok_tick&tick=${tick}&team=2)
	v1=$(echo $result | cut -d'/' -f1)
	v2=$(echo $result | cut -d'/' -f2)
	v3=$(echo $result | cut -d'/' -f3)
	v4=$(echo $result | cut -d'/' -f4)
	v5=$(echo $result | cut -d'/' -f5)




if [ "${v3}"  ==  "1" ]
	then
prnt "Defeat"
i=0
fi

if [ "${v3}"  ==  "2" ]
	then
prnt "VICTORY"
i=0
fi

 E=$((${v1}%2))
if [ "${E}" == "1" ] && [ "${v1}" != "${tick}" ]
	then
tick="${v1}"
echo "I will call senddol"
senddol "${v4}${v5}"
echo "SENDDOL : ${v4}${v5}"
sleep 3

else
	if [ "${E}" == "1" ]
	then
		echo "Waiting LPC 1768 input..."
input=$(timeout 4s cat ${OUTPUT})
echo "lpc says : ${input}"
	a1=$(echo $input | cut -d'/' -f1)
	a2=$(echo $input | cut -d'/' -f2)
	echo "a1 is ${a1} a2 is ${a2}"
result=$(curl "${APIURL}?a=omok_tick&tick=${tick}&team=2&x=${a1}&y=${a2}")
echo "Server Answer : $result"
sleep 1
fi
fi

	 
sleep 2
done
echo "Game Over - Script terminated."



