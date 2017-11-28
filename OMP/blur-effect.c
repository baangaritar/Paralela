		#include <opencv2/opencv.hpp>
		#include <stdio.h>
		#include <string.h>
		#include <cstdlib> 
		#include <iostream>
		#include <omp.h>


		using namespace std;
		using namespace cv;

		typedef cv::Point3_<uint8_t> Pixel;

		Mat imagenOriginal, imagenCopia;
		int m, kernel;

		struct datosHilo {
		  int idHilo;
		  int posicionXInicio, posicionXFin, posicionYInicio, posicionYFin;
		};


		int verificar_parametros(int numArg, int numHilos, int kernel, char* nombreImg ){
			if (numArg > 4 || numArg < 3)
			{
				cout<<"Para ejecutar este programa debe seguir la siguiente sintaxis: \n\t./blur-effect Nombre_de_la_imagen.png_o_jpge Tamaño_kernel Cantidad_hilos \n\t\t Donde Tamaño_kernel es un numero impar \n\t\t Cantidad_hilos sera un numero entre 1 y 16";
				return -1;
			}
			if (numHilos > 16 || numHilos < 1 )
			{
				cout<<"El numero de hilos debe ser entre 1 y 16";
				return -1;
			}
			if (kernel % 2 != 1 || kernel < 3)
			{
				cout<<"El tamaño del kernel tiene que ser impar mayor o igual a 3";
				return -1;
			}

			imagenOriginal = imread(nombreImg);
			if (imagenOriginal.empty())
			{
				cout<<"Error al abrir la imagen " << nombreImg << endl;
				return -1;
			}else{
				imagenCopia = imagenOriginal.clone();
			}
			return 1;
		}

		void segmento(int columnas, int filas, int numHilos, datosHilo matrizHilos[]){
			int factores[200];    //Formas de dividir una matiz del en n numero de hilos".
			int numFactores = 0;     
			int j= 2;          
			int row = 1;        
			int col = 1;        
			int rowD, colD; //distancia entre col y row
			       
			while(j<=numHilos){
			if((numHilos % j) == 0){ 
			factores[numFactores]=j; 
			numHilos=numHilos/j;  
			numFactores++;      
			continue;
			}
			j++;              
			}

			for(int i=0; i<numFactores; i++){ 
				if(i%2==0)
					row*=factores[i];
				else
					col*=factores[i];
			}
			
			rowD = filas / row;
			colD = columnas / col;
			numHilos = 0;

			for (int i = 0; i < col; i++)
			{
				for (int j = 0; j < row; j++)
				{
					matrizHilos[numHilos].idHilo = numHilos;
					matrizHilos[numHilos].posicionXInicio = i*colD;
					matrizHilos[numHilos].posicionXFin = ( i + 1 )*colD;
					matrizHilos[numHilos].posicionYInicio = j * rowD;
					matrizHilos[numHilos].posicionYFin = ( j + 1 ) * rowD;
					numHilos++;
				}
			}

		}

		Pixel sumaSegmentoImagen(Mat* parteImagen){
			long columnas, filas;
			int x, y ,z;
			int centro = parteImagen -> cols / 2;
			
			Pixel  *aux;
			x = 0;
			y = 0;
			z = 0;
			columnas = parteImagen -> cols;
			filas = parteImagen -> rows;
			for (int i = 0; i < parteImagen -> rows; ++i)
			{
				for (int j = 0; j < parteImagen -> cols; ++j)
				{
					if (i == 0 && j == 0)
					{
						aux = parteImagen -> ptr<Pixel>(i,j);
						x = aux -> x;
						y = aux -> y;
						z = aux -> z;
						continue;
					}
					if (i == centro && j == centro)
						continue;
					aux = parteImagen -> ptr<Pixel>(i,j);
					x += aux -> x;
					y += aux -> y;
					z += aux -> z;
				}
			}

			int totalx = x / (parteImagen -> rows * parteImagen -> rows -1);
			int totaly = y / (parteImagen -> rows * parteImagen -> rows -1);
			int totalz = z / (parteImagen -> rows * parteImagen -> rows -1);

			return Pixel(totalx, totaly, totalz);

		}

		Pixel sumaSegmentoImagenBorde(Mat* parteImagen){
			long columnas, filas;
			int x, y ,z;
			Pixel  *aux;
			x = 0;
			y = 0;
			z = 0;
			columnas = parteImagen -> cols;
			filas = parteImagen -> rows;
			//cout<<"col "<<parteImagen -> cols<<endl;
			//cout<<"fil "<<parteImagen -> rows<<endl;
			for (int i = 0; i < parteImagen -> rows; ++i)
			{
				//cout<<"imgbord i "<<i<<endl;
				for (int j = 0; j < parteImagen -> cols; ++j)
				{
					if (i == 0.0 && j == 0.0)
					{
						aux = parteImagen -> ptr<Pixel>(i,j);
						x = aux -> x;
						y = aux -> y;
						z = aux -> z;
						continue;
					}
					aux = parteImagen -> ptr<Pixel>(i,j);
					x += aux -> x;
					y += aux -> y;
					z += aux -> z;
				}
			}

			int totalx = x / (parteImagen -> rows * parteImagen -> cols );
			int totaly = y / (parteImagen -> rows * parteImagen -> cols );
			int totalz = z / (parteImagen -> rows * parteImagen -> cols );
			return Pixel(totalx, totaly, totalz);
		}

		void* calcularBlur(void* datoHilo){
			struct datosHilo *hilo;
			hilo = (struct datosHilo *) datoHilo;
			int x0, xf, y0, yf;
			x0 = hilo -> posicionXInicio;
			xf = hilo -> posicionXFin;
			y0 = hilo -> posicionYInicio;
			yf = hilo -> posicionYFin;
			// cout<<"x0 "<<x0<<endl;
			// cout<<"xf "<<xf<<endl;
			// cout<<"y0 "<<y0<<endl;
			// cout<<"yf "<<yf<<endl;
			for (int i = y0; i < yf; i++)
			{
				//cout<<"i " << i << endl;
				int inicioFila = i - m;
				int finFila = i + m;
				for (int j = x0; j < xf; j++)
				{
					//cout<<"j " << j << endl;
					if (i >= m &&  j >= m && i < imagenOriginal.rows - m && j < imagenOriginal.cols - m )
					{
						int inicioColumna = j - m;
						Mat pequenaImagen = imagenOriginal.operator()(Range(inicioFila, inicioFila + kernel), Range(inicioColumna, inicioColumna + kernel));
						Pixel pixelCalculado= sumaSegmentoImagen( &pequenaImagen );
						Pixel* ptr =imagenCopia.ptr<Pixel>(i,j);
						pequenaImagen.release();
						ptr -> x = pixelCalculado.x;
						ptr -> y = pixelCalculado.y;
						ptr -> z = pixelCalculado.z;
						
					}
					else
					{
						int inicioColumna = j - m;
						int finColumna = j + m;
						if (inicioFila < 0)
						{
							inicioFila = 0;
						}
						if (inicioColumna < 0)
						{
							inicioColumna = 0;
						}
						if (finColumna >= imagenOriginal.cols)
						{
							finColumna = imagenOriginal.cols - 1;
						}
						if (finFila >= imagenOriginal.rows)
						{
							finFila = imagenOriginal.rows - 1;
						}
						// cout<<inicioFila<<endl;
						// cout<<finFila<<endl;
						// cout<<inicioColumna<<endl;
						// cout<<finColumna<<endl;
						Mat pequenaImagen = imagenOriginal.operator()(Range(inicioFila, finFila), Range(inicioColumna, finColumna));

						Pixel pixelCalculado = sumaSegmentoImagenBorde( &pequenaImagen );

						Pixel* ptr =imagenCopia.ptr<Pixel>(i,j);
						pequenaImagen.release();
						ptr -> x = pixelCalculado.x;
						ptr -> y = pixelCalculado.y;
						ptr -> z = pixelCalculado.z;
						
					}
					
					//cout<<endl;

				}
				
			}
			//cout<<"sale del for";
		}



		int main(int argc, char *argv[])
		{
			int numArg, numHilos;
			char* nombreImg;
			numArg = argc;
			numHilos = atoi(argv[3]);
			kernel = atoi(argv[2]);
			nombreImg = argv[1];
			if (verificar_parametros(numArg, numHilos, kernel, nombreImg) == 1)
			{
				
				struct datosHilo matrizHilos[numHilos];
				omp_set_num_threads(numHilos);
				m = kernel / 2;
				segmento(imagenOriginal.cols, imagenOriginal.rows, numHilos, matrizHilos );
				#pragma omp parallel
				{
					int intOmp = omp_get_thread_num();
					calcularBlur((void *)&matrizHilos[intOmp]);
				}
				//cout<<"casi termina";
				char str[250];
				strcpy(str, "blur-");
				strcat(str, nombreImg);
				strcat(str, ", hilos: ");
				strcat(str, argv[3]);
				strcat(str, ", kernel: ");
				strcat(str, argv[2]);
				strcat(str, ".png");
				imwrite(str,imagenCopia);
				return 0;
			}else{
				return 0;
				exit(-1);
			}
		}