#!/bin/bash
# -*- ENCODING: UTF-8 -*-

#Ruta del archivo blur-effect.cpp
cd /home/miguel/Documentos/Computacion\ paralela/Blur\ Cuda/


#Compilacion del archivo
nvcc blur-effect-cuda.cu -o blur-effect-cuda `pkg-config opencv --cflags --libs`

TIMEFORMAT=%R

imagenes=("720p.jpg" "1080.jpg" "4k.jpg") #Nombres de las imagenes a procesar
nhilos=(16 32 64 128 256 512)
for item in ${imagenes[*]}
do
	echo "******************************************************************" >> output50.time.txt
	echo "************************imagen $item *****************************" >> output50.time.txt
	echo "******************************************************************" >> output50.time.txt
	echo "  " >> output50.time.txt
	for((i=3;i<16; i+=2));
	do
		for hilos in ${nhilos[*]}
		do
			echo "Tamaño de kernel $i con $hilos hilos" >> output50.time.txt

			#ejecutar el programa, y almacenar el tiempo en un archivo
			salida="kernel$i$item"

			/usr/bin/time -f "%e real" -a -o output50.time.txt ./blur-effect-cuda $item $salida $i $hilos
		 	cat output50.time.txt

			echo "  " >> output50.time.txt

		done


		echo "--------------------------------------------------" >> output50.time.txt

	done



done
