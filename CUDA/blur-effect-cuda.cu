#include "cuda_runtime.h"
#include <iostream>
#include <ctime>
#include <stdio.h>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/opencv.hpp>
#include <math.h>
#include <iostream>
#include <pthread.h>
#include <unistd.h>



/* COMPILAR nvcc blur-effect-cuda.cu -o blur-effect-cuda `pkg-config opencv --cflags --libs`*/

__global__ void blurEffect3(uchar *DataIn,uchar *DataOut, int w, int h, int hilos, int bloques  )
{
    //int kernel[9]={2,3,2 };
    int d=7;
    //Fila actual
    int intervalo=w*h/(hilos*bloques);
    int idx = blockIdx.x* blockDim.x + threadIdx.x;
    for (int i = intervalo*idx; i < (intervalo*idx)+intervalo; i+=1) {

      //Indices de los pixeles vecinos

      int idu = i-w;
      int idd = i+w;

      //Valores RGB de cada pixel
      int b = DataIn[3*i]*3;
      int g = DataIn[3*i+1]*3;
      int r = DataIn[3*i+2]*3;


      int bu = DataIn[3*idu]*2;
      int gu = DataIn[3*idu+1]*2;
      int ru = DataIn[3*idu+2]*2;

      int bd = DataIn[3*idd]*2;
      int gd = DataIn[3*idd+1]*2;
      int rd = DataIn[3*idd+2]*2;



      //Promedio de cada valor RGB
      int promR= (r+ru+rd)/d;
      int promG= (g+gu+gd)/d;
      int promB= (b+bu+bd)/d;


      //Asignacion en nueva imagen
      DataOut[3*i] = (unsigned char)(promB);

      DataOut[3*i+1] = (unsigned char)(promG);

      DataOut[3*i+2] = (unsigned char)(promR);

    }


}


__global__ void blurEffect5(uchar *DataIn,uchar *DataOut, int w, int h, int hilos, int bloques  )
{
    //int kernel[9]={ ,2,
      //             2,3,2,
        //             2, };
    int d=11;
    //Fila actual

    int intervalo=w*h/(hilos*bloques);
    int idx = blockIdx.x* blockDim.x + threadIdx.x;
    for (int i = intervalo*idx; i < (intervalo*idx)+intervalo; i+=1) {

      //Indices de los pixeles vecinos
      int idu = i-w;
      int idr = i+3;
      int idl = i-3;
      int idd = i+w;


      //Valores RGB de cada pixel
      int b = DataIn[3*i]*3;
      int g = DataIn[3*i+1]*3;
      int r = DataIn[3*i+2]*3;

      int bu = DataIn[3*idu]*2;
      int gu = DataIn[3*idu+1]*2;
      int ru = DataIn[3*idu+2]*2;

      int bd = DataIn[3*idd]*2;
      int gd = DataIn[3*idd+1]*2;
      int rd = DataIn[3*idd+2]*2;

      int bl = DataIn[3*idl]*2;
      int gl = DataIn[3*idl+1]*2;
      int rl = DataIn[3*idl+2]*2;

      int br = DataIn[3*idr]*2;
      int gr = DataIn[3*idr+1]*2;
      int rr = DataIn[3*idr+2]*2;



      //Promedio de cada valor RGB
      int promR= (r+ru+rd+rl+rr)/d;
      int promG= (g+gu+gd+gl+gr)/d;
      int promB= (b+bu+bd+bl+br)/d;


      //Asignacion en nueva imagen
      DataOut[3*i] = (unsigned char)(promB);

      DataOut[3*i+1] = (unsigned char)(promG);

      DataOut[3*i+2] = (unsigned char)(promR);

    }


}


__global__ void blurEffect7(uchar *DataIn,uchar *DataOut, int w, int h, int hilos, int bloques  )
{
    //int kernel[9]={ ,2,1,
      //             2,3,2,
        //           1,2, };
    int d=13;
    //Fila actual

    int intervalo=w*h/(hilos*bloques);
    int idx = blockIdx.x* blockDim.x + threadIdx.x;
    for (int i = intervalo*idx; i < (intervalo*idx)+intervalo; i+=1) {

      //Indices de los pixeles vecinos
      int idu = i-w;
      int idr = i+3;
      int idl = i-3;
      int idd = i+w;
      int idul = (i-3)-w;
      int iddr = (i+3)+w;

      //Valores RGB de cada pixel
      int b = DataIn[3*i]*3;
      int g = DataIn[3*i+1]*3;
      int r = DataIn[3*i+2]*3;

      int bu = DataIn[3*idu]*2;
      int gu = DataIn[3*idu+1]*2;
      int ru = DataIn[3*idu+2]*2;


      int bul = DataIn[3*idul]*1;
      int gul = DataIn[3*idul+1]*1;
      int rul = DataIn[3*idul+2]*1;

      int bd = DataIn[3*idd]*2;
      int gd = DataIn[3*idd+1]*2;
      int rd = DataIn[3*idd+2]*2;

      int bdr = DataIn[3*iddr]*1;
      int gdr = DataIn[3*iddr+1]*1;
      int rdr = DataIn[3*iddr+2]*1;


      int bl = DataIn[3*idl]*2;
      int gl = DataIn[3*idl+1]*2;
      int rl = DataIn[3*idl+2]*2;

      int br = DataIn[3*idr]*2;
      int gr = DataIn[3*idr+1]*2;
      int rr = DataIn[3*idr+2]*2;



      //Promedio de cada valor RGB
      int promR= (r+ru+rd+rl+rr+rul+rdr)/d;
      int promG= (g+gu+gd+gl+gr+gul+gdr)/d;
      int promB= (b+bu+bd+bl+br+bul+bdr)/d;


      //Asignacion en nueva imagen
      DataOut[3*i] = (unsigned char)(promB);

      DataOut[3*i+1] = (unsigned char)(promG);

      DataOut[3*i+2] = (unsigned char)(promR);

    }


}

__global__ void blurEffect9(uchar *DataIn,uchar *DataOut, int w, int h, int hilos, int bloques  )
{
    //int kernel[9]={1,2,1,
      //             2,3,2,
        //           1,2,1};
    int d=15;
    //Fila actual

    int intervalo=w*h/(hilos*bloques);
    int idx = blockIdx.x* blockDim.x + threadIdx.x;
    for (int i = intervalo*idx; i < (intervalo*idx)+intervalo; i+=1) {

      //Indices de los pixeles vecinos
      int idu = i-w;
      int idr = i+3;
      int idl = i-3;
      int idd = i+w;

      int idul = (i-3)-w;
      int idur = (i+3)-w;
      int iddl = (i-3)+w;
      int iddr = (i+3)+w;

      //Valores RGB de cada pixel
      int b = DataIn[3*i]*3;
      int g = DataIn[3*i+1]*3;
      int r = DataIn[3*i+2]*3;

      int bu = DataIn[3*idu]*2;
      int gu = DataIn[3*idu+1]*2;
      int ru = DataIn[3*idu+2]*2;


      int bul = DataIn[3*idul]*1;
      int gul = DataIn[3*idul+1]*1;
      int rul = DataIn[3*idul+2]*1;


      int bur = DataIn[3*idur]*1;
      int gur = DataIn[3*idur+1]*1;
      int rur = DataIn[3*idur+2]*1;


      int bd = DataIn[3*idd]*2;
      int gd = DataIn[3*idd+1]*2;
      int rd = DataIn[3*idd+2]*2;


      int bdl = DataIn[3*iddl]*1;
      int gdl = DataIn[3*iddl+1]*1;
      int rdl = DataIn[3*iddl+2]*1;

      int bdr = DataIn[3*iddr]*1;
      int gdr = DataIn[3*iddr+1]*1;
      int rdr = DataIn[3*iddr+2]*1;


      int bl = DataIn[3*idl]*2;
      int gl = DataIn[3*idl+1]*2;
      int rl = DataIn[3*idl+2]*2;

      int br = DataIn[3*idr]*2;
      int gr = DataIn[3*idr+1]*2;
      int rr = DataIn[3*idr+2]*2;



      //Promedio de cada valor RGB
      int promR= (r+ru+rd+rl+rr+rur+rul+rdl+rdr)/d;
      int promG= (g+gu+gd+gl+gr+gur+gul+gdl+gdr)/d;
      int promB= (b+bu+bd+bl+br+bur+bul+bdl+bdr)/d;


      //Asignacion en nueva imagen
      DataOut[3*i] = (unsigned char)(promB);

      DataOut[3*i+1] = (unsigned char)(promG);

      DataOut[3*i+2] = (unsigned char)(promR);

    }


}

__global__ void blurEffect11(unsigned char *DataIn, unsigned char *DataOut, int w, int h, int hilos, int bloques)
{
    //int kernel[9]={1,2,1,
      //             2,3,2,1
        //           1,2,1
                   //  1};

    int d=17;

    int intervalo=w*h/(hilos*bloques);
    int idx = blockIdx.x* blockDim.x + threadIdx.x;
    for (int i = intervalo*idx; i < (intervalo*idx)+intervalo; i+=1){

      //Piexeles alrededor
      int idu = i-w;
      int idr = i+3;
      int idl = i-3;
      int idd = i+w;

      int idul = (i-3)-w;
      int idur = (i+3)-w;
      int iddl = (i-3)+w;
      int iddr = (i+3)+w;


      int idd2 = i+w+w;
      int idr2 = i+6;


      //obtencion RGB de cada pixel y multiplicacion por el valor del kernel gaussiano

      int b = DataIn[3*i]*3;
      int g = DataIn[3*i+1]*3;
      int r = DataIn[3*i+2]*3;

      int bu = DataIn[3*idu]*2;
      int gu = DataIn[3*idu+1]*2;
      int ru = DataIn[3*idu+2]*2;


      int bul = DataIn[3*idul]*1;
      int gul = DataIn[3*idul+1]*1;
      int rul = DataIn[3*idul+2]*1;


      int bur = DataIn[3*idur]*1;
      int gur = DataIn[3*idur+1]*1;
      int rur = DataIn[3*idur+2]*1;


      int bd = DataIn[3*idd]*2;
      int gd = DataIn[3*idd+1]*2;
      int rd = DataIn[3*idd+2]*2;


      int bdl = DataIn[3*iddl]*1;
      int gdl = DataIn[3*iddl+1]*1;
      int rdl = DataIn[3*iddl+2]*1;

      int bdr = DataIn[3*iddr]*1;
      int gdr = DataIn[3*iddr+1]*1;
      int rdr = DataIn[3*iddr+2]*1;


      int bl = DataIn[3*idl]*2;
      int gl = DataIn[3*idl+1]*2;
      int rl = DataIn[3*idl+2]*2;

      int br = DataIn[3*idr]*2;
      int gr = DataIn[3*idr+1]*2;
      int rr = DataIn[3*idr+2]*2;


      int br2=DataIn[3*idr2];
      int gr2=DataIn[3*idr2+1];
      int rr2=DataIn[3*idr2+2];


      int bd2=DataIn[3*idd2];
      int gd2=DataIn[3*idd2+1];
      int rd2=DataIn[3*idd2+2];




      //Promedio de cada valor R G y B de cada pixel

      int promR= (r+ru+rd+rl+rr+rur+rul+rdl+rdr+rr2+rd2)/d;
      int promG= (g+gu+gd+gl+gr+gur+gul+gdl+gdr+gr2+gd2)/d;
      int promB= (b+bu+bd+bl+br+bur+bul+bdl+bdr+br2+bd2)/d;

      //Asignacion en la salida

      DataOut[3*i] = (unsigned char)(promB);

      DataOut[3*i+1] = (unsigned char)(promG);

      DataOut[3*i+2] = (unsigned char)(promR);
    }

}


__global__ void blurEffect13(unsigned char *DataIn, unsigned char *DataOut, int w, int h, int hilos, int bloques)
{
    //int kernel[9]={1,2,1,1
      //             2,3,2,1
        //           1,2,1
      //             1 1    };

    int d=19;

    int intervalo=w*h/(hilos*bloques);
    int idx = blockIdx.x* blockDim.x + threadIdx.x;
    for (int i = intervalo*idx; i < (intervalo*idx)+intervalo; i+=1){

      //Piexeles alrededor
      int idu = i-w;
      int idr = i+3;
      int idl = i-3;
      int idd = i+w;

      int idul = (i-3)-w;
      int idur = (i+3)-w;
      int iddl = (i-3)+w;
      int iddr = (i+3)+w;


      int idd2 = i+w+w;
      int iddl2 = (i-3)+w+w;

      int idur2 = (i+6)-w;
      int idr2 = i+6;

      //obtencion RGB de cada pixel y multiplicacion por el valor del kernel gaussiano

      int b = DataIn[3*i]*3;
      int g = DataIn[3*i+1]*3;
      int r = DataIn[3*i+2]*3;

      int bu = DataIn[3*idu]*2;
      int gu = DataIn[3*idu+1]*2;
      int ru = DataIn[3*idu+2]*2;


      int bul = DataIn[3*idul]*1;
      int gul = DataIn[3*idul+1]*1;
      int rul = DataIn[3*idul+2]*1;


      int bur = DataIn[3*idur]*1;
      int gur = DataIn[3*idur+1]*1;
      int rur = DataIn[3*idur+2]*1;


      int bd = DataIn[3*idd]*2;
      int gd = DataIn[3*idd+1]*2;
      int rd = DataIn[3*idd+2]*2;


      int bdl = DataIn[3*iddl]*1;
      int gdl = DataIn[3*iddl+1]*1;
      int rdl = DataIn[3*iddl+2]*1;

      int bdr = DataIn[3*iddr]*1;
      int gdr = DataIn[3*iddr+1]*1;
      int rdr = DataIn[3*iddr+2]*1;


      int bl = DataIn[3*idl]*2;
      int gl = DataIn[3*idl+1]*2;
      int rl = DataIn[3*idl+2]*2;

      int br = DataIn[3*idr]*2;
      int gr = DataIn[3*idr+1]*2;
      int rr = DataIn[3*idr+2]*2;



      int bur2=DataIn[3*idur2];
      int gur2=DataIn[3*idur2+1];
      int rur2=DataIn[3*idur2+2];


      int br2=DataIn[3*idr2];
      int gr2=DataIn[3*idr2+1];
      int rr2=DataIn[3*idr2+2];

      int bdl2=DataIn[3*iddl2];
      int gdl2=DataIn[3*iddl2+1];
      int rdl2=DataIn[3*iddl2+2];

      int bd2=DataIn[3*idd2];
      int gd2=DataIn[3*idd2+1];
      int rd2=DataIn[3*idd2+2];





      //Promedio de cada valor R G y B de cada pixel

      int promR= (r+ru+rd+rl+rr+rur+rul+rdl+rdr+rur2+rr2+rdl2+rd2)/d;
      int promG= (g+gu+gd+gl+gr+gur+gul+gdl+gdr+gur2+gr2+gdl2+gd2)/d;
      int promB= (b+bu+bd+bl+br+bur+bul+bdl+bdr+bur2+br2+bdl2+bd2)/d;

      //Asignacion en la salida

      DataOut[3*i] = (unsigned char)(promB);

      DataOut[3*i+1] = (unsigned char)(promG);

      DataOut[3*i+2] = (unsigned char)(promR);
    }

}


__global__ void blurEffect15(unsigned char *DataIn, unsigned char *DataOut, int w, int h, int hilos, int bloques)
{
    //int kernel[9]={1,2,1,
      //             2,3,2,
        //           1,2,1};

    int d=21;

    int intervalo=w*h/(hilos*bloques);
    int idx = blockIdx.x* blockDim.x + threadIdx.x;
    for (int i = intervalo*idx; i < (intervalo*idx)+intervalo; i+=1){

      //Piexeles alrededor
      int idu = i-w;
      int idr = i+3;
      int idl = i-3;
      int idd = i+w;

      int idul = (i-3)-w;
      int idur = (i+3)-w;
      int iddl = (i-3)+w;
      int iddr = (i+3)+w;


      int idd2 = i+w+w;
      int iddl2 = (i-3)+w+w;
      int iddr2 = (i+3)+w+w;

      int idur2 = (i+6)-w;
      int idr2 = i+6;
      int iddrd2 = (i+3)+w+w;

      //obtencion RGB de cada pixel y multiplicacion por el valor del kernel gaussiano

      int b = DataIn[3*i]*3;
      int g = DataIn[3*i+1]*3;
      int r = DataIn[3*i+2]*3;

      int bu = DataIn[3*idu]*2;
      int gu = DataIn[3*idu+1]*2;
      int ru = DataIn[3*idu+2]*2;


      int bul = DataIn[3*idul]*1;
      int gul = DataIn[3*idul+1]*1;
      int rul = DataIn[3*idul+2]*1;


      int bur = DataIn[3*idur]*1;
      int gur = DataIn[3*idur+1]*1;
      int rur = DataIn[3*idur+2]*1;


      int bd = DataIn[3*idd]*2;
      int gd = DataIn[3*idd+1]*2;
      int rd = DataIn[3*idd+2]*2;


      int bdl = DataIn[3*iddl]*1;
      int gdl = DataIn[3*iddl+1]*1;
      int rdl = DataIn[3*iddl+2]*1;

      int bdr = DataIn[3*iddr]*1;
      int gdr = DataIn[3*iddr+1]*1;
      int rdr = DataIn[3*iddr+2]*1;


      int bl = DataIn[3*idl]*2;
      int gl = DataIn[3*idl+1]*2;
      int rl = DataIn[3*idl+2]*2;

      int br = DataIn[3*idr]*2;
      int gr = DataIn[3*idr+1]*2;
      int rr = DataIn[3*idr+2]*2;



      int bur2=DataIn[3*idur2];
      int gur2=DataIn[3*idur2+1];
      int rur2=DataIn[3*idur2+2];


      int br2=DataIn[3*idr2];
      int gr2=DataIn[3*idr2+1];
      int rr2=DataIn[3*idr2+2];

      int bdr2=DataIn[3*iddr2];
      int gdr2=DataIn[3*iddr2+1];
      int rdr2=DataIn[3*iddr2+2];


      int bdl2=DataIn[3*iddl2];
      int gdl2=DataIn[3*iddl2+1];
      int rdl2=DataIn[3*iddl2+2];

      int bd2=DataIn[3*idd2];
      int gd2=DataIn[3*idd2+1];
      int rd2=DataIn[3*idd2+2];



      int bdrd2=DataIn[3*iddrd2];
      int gdrd2=DataIn[3*iddrd2+1];
      int rdrd2=DataIn[3*iddrd2+2];




      //Promedio de cada valor R G y B de cada pixel

      int promR= (r+ru+rd+rl+rr+rur+rul+rdl+rdr+rur2+rr2+rdr2+rdl2+rd2+rdrd2)/d;
      int promG= (g+gu+gd+gl+gr+gur+gul+gdl+gdr+gur2+gr2+gdr2+gdl2+gd2+gdrd2)/d;
      int promB= (b+bu+bd+bl+br+bur+bul+bdl+bdr+bur2+br2+bdr2+bdl2+bd2+bdrd2)/d;

      //Asignacion en la salida

      DataOut[3*i] = (unsigned char)(promB);

      DataOut[3*i+1] = (unsigned char)(promG);

      DataOut[3*i+2] = (unsigned char)(promR);
    }

}





int main(int argc, char** argv)
{
        cudaDeviceProp deviceProp;
        cudaGetDeviceProperties(&deviceProp, 0);

        int height,width;

        char *imgIN;
        imgIN = new char [1024];

        imgIN=argv[1];
        const char* filename1 = argv[2];
        int kernelSize=atoi(argv[3]);
        int NumThreadsX=atoi(argv[4]);

        //Imagen de entrada
        IplImage* image;
        image = cvLoadImage(imgIN, 1);

        height = image->height;
        width = image->width;

        int step = image->widthStep;
        int SizeIn = (step*height);
        printf("\nProcessing image\n");



        //imagen de salida

        IplImage *image2 = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 3);
        int step2 = image2->widthStep;
        int SizeOut = step2 * height;


        //GPU
        uchar4* DatIn = (uchar4*)image->imageData;
        unsigned char * DatOut = (unsigned char*)image2->imageData;
        unsigned char *datIndev;
        unsigned char *datOutdev;

        printf("Allocating memory on Device\n");

        // Reservar memoria en GPU


        cudaMalloc(&datIndev, SizeIn * sizeof(unsigned char));
        cudaMalloc(&datOutdev, SizeOut * sizeof(unsigned char));


        printf("Copy data on Device\n");


        // Copiar datos en GPU

        cudaMemcpy(datIndev, DatIn, SizeIn * sizeof(unsigned char), cudaMemcpyHostToDevice);
        cudaMemcpy(datOutdev, DatOut, SizeOut * sizeof(unsigned char), cudaMemcpyHostToDevice);


        //kernel CUDA

        //int NumThreadsX = deviceProp.maxThreadsPerBlock;
        int NumBlocksX =50;
        dim3 blocks(NumBlocksX);
        dim3 threads(NumThreadsX);


        switch(kernelSize){
            case 3:
              blurEffect3<<<blocks, threads>>>(datIndev, datOutdev, width,height,NumThreadsX,NumBlocksX);
              break;
            case 5:
              blurEffect5<<<blocks, threads>>>(datIndev, datOutdev, width,height,NumThreadsX,NumBlocksX);
              break;
            case 7:
              blurEffect7<<<blocks, threads>>>(datIndev, datOutdev, width,height,NumThreadsX,NumBlocksX);
              break;
            case 9:
              blurEffect9<<<blocks, threads>>>(datIndev, datOutdev, width,height,NumThreadsX,NumBlocksX);
              break;
            case 11:
              blurEffect11<<<blocks, threads>>>(datIndev, datOutdev, width,height,NumThreadsX,NumBlocksX);
              break;
            case 13:
              blurEffect13<<<blocks, threads>>>(datIndev, datOutdev, width,height,NumThreadsX,NumBlocksX);
              break;
            case 15:
              blurEffect15<<<blocks, threads>>>(datIndev, datOutdev, width,height,NumThreadsX,NumBlocksX);
              break;
        }



        //Obtener resultado de GPU a HOST

        cudaMemcpy(DatOut, datOutdev, SizeOut * sizeof(unsigned char), cudaMemcpyDeviceToHost);

        //Mostrar iamgen
        cvNamedWindow("Image original");
        cvShowImage("Image original", image);
        cvNamedWindow("Image blur");
        cvShowImage("Image blur", image2);

        //Guardar imagen


        cvSaveImage( filename1, image2 );

        //Liberar memoria en GPU
        cudaFree(datOutdev);
        cudaFree(datIndev);
        cvWaitKey(0);
        return 0;
}
