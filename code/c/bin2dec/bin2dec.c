#include<stdio.h>
#include<math.h>

#define NBITS 21

// Function to print an int array
void print_vec(int* b){
	int i;
	for(i=0; i < NBITS; i++){
		printf("%d,",b[i]);
	}
	printf("\n");
}

// Binary to decimal converter
int bin2dec(int* b){
	int i, sum=0;
	for(i=0; i < NBITS; i++){
		sum += pow(2,i)*b[i];
	}
	return sum;
}

// Decimal to Binary Converter
void dec2bin(int d, int b[NBITS]){
	int i;
	for(i=NBITS-1;i >= 0;i--){

		if ((float)d - pow(2,i) >= 0){
			b[i] = 1;
			d -= pow(2,i);
		}else{
			b[i] = 0;
		}
	}
}

// Main
int main(){
	int b[NBITS];
	int i;
	int sum=0;
	
	for(i=0; i < pow(2,NBITS); i++){
		dec2bin(i, b);
		sum = bin2dec(b);	
		if (sum != i)
			printf("not equal, %d\n",i);
	}

	printf("Complete!\n");
	return 0;
}
