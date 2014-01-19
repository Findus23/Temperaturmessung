a=0
while true
do
	a=$(($a + $((RANDOM % 10)) - 5)) # a um eine zufällige Zahl zwischen -5 und 5 ändern
	#a=a+[Zufallszahl von 0-32767] modulo 10 (um eine Zahl von 0-10 zu bekommen) -5 (-> -5 bis 5)
	echo -ne "${a}\r" #keine neue Zeile und Steuerzeichen beachten
sleep 0.5
done
