#!/bin/bash
g++ -fopenmp blur-effect.c -o blur-effect `pkg-config --cflags --libs opencv` 
kernel=$1
echo "Kernel de valor "  >tiempos.txt
echo "$kernel" >> tiempos.txt
echo "\n\nTiempos imagen 720p \n \n" >> tiempos.txt
echo "\n Tiempo 720 1 hilos \n" >> tiempos.txt
(time ./blur-effect 720.jpg $kernel 1)2>>tiempos.txt
echo "\n Tiempo 720 3 hilos \n" >> tiempos.txt
(time ./blur-effect 720.jpg $kernel 3)2>>tiempos.txt
echo "\n Tiempo 720 5 hilos \n" >> tiempos.txt
(time ./blur-effect 720.jpg $kernel 5)2>>tiempos.txt
echo "\n Tiempo 720 7 hilos \n" >> tiempos.txt
(time ./blur-effect 720.jpg $kernel 7)2>>tiempos.txt
echo "\n Tiempo 720 9 hilos \n" >> tiempos.txt
(time ./blur-effect 720.jpg $kernel 9)2>>tiempos.txt
echo "\n Tiempo 720 11 hilos \n" >> tiempos.txt
(time ./blur-effect 720.jpg $kernel 11)2>>tiempos.txt
echo "\n Tiempo 720 13 hilos \n" >> tiempos.txt
(time ./blur-effect 720.jpg $kernel 13)2>>tiempos.txt

echo "\nTiempos imagen 1080p \n \n" >> tiempos.txt
echo "\n Tiempo 1080p 1 hilos \n" >> tiempos.txt
(time ./blur-effect 1080.jpg $kernel 1)2>>tiempos.txt
echo "\n Tiempo 1080p 3 hilos \n" >> tiempos.txt
(time ./blur-effect 1080.jpg $kernel 3)2>>tiempos.txt
echo "\n Tiempo 1080p 5 hilos \n" >> tiempos.txt
(time ./blur-effect 1080.jpg $kernel 5)2>>tiempos.txt
echo "\n Tiempo 1080p 7 hilos \n" >> tiempos.txt
(time ./blur-effect 1080.jpg $kernel 7)2>>tiempos.txt
echo "\n Tiempo 1080p 9 hilos \n" >> tiempos.txt
(time ./blur-effect 1080.jpg $kernel 9)2>>tiempos.txt
echo "\n Tiempo 1080p 11 hilos \n" >> tiempos.txt
(time ./blur-effect 1080.jpg $kernel 11)2>>tiempos.txt
echo "\n Tiempo 1080p 13 hilos \n" >> tiempos.txt
(time ./blur-effect 1080.jpg $kernel 13)2>>tiempos.txt

echo "\nTiempos imagen 4k \n \n" >> tiempos.txt
echo "\n Tiempo 4k 1 hilos \n" >> tiempos.txt
(time ./blur-effect 4k.jpg $kernel 1)2>>tiempos.txt
echo "\n Tiempo 4k 3 hilos \n" >> tiempos.txt
(time ./blur-effect 4k.jpg $kernel 3)2>>tiempos.txt
echo "\n Tiempo 4k 5 hilos \n" >> tiempos.txt
(time ./blur-effect 4k.jpg $kernel 5)2>>tiempos.txt
echo "\n Tiempo 4k 7 hilos \n" >> tiempos.txt
(time ./blur-effect 4k.jpg $kernel 7)2>>tiempos.txt
echo "\n Tiempo 4k 9 hilos \n" >> tiempos.txt
(time ./blur-effect 4k.jpg $kernel 9)2>>tiempos.txt
echo "\n Tiempo 4k 11 hilos \n" >> tiempos.txt
(time ./blur-effect 4k.jpg $kernel 11)2>>tiempos.txt
echo "\n Tiempo 4k 13 hilos \n" >> tiempos.txt
(time ./blur-effect 4k.jpg $kernel 13)2>>tiempos.txt

