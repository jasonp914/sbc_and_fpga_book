#include<stdio.h>
#include<math.h>

#define LINESIZE 255

void alpha_init(char alpha[26]){
	alpha[0] = 'a';
	alpha[1] = 'b';
	alpha[2] = 'c';
	alpha[3] = 'd';
	alpha[4] = 'e';
	alpha[5] = 'f';
	alpha[6] = 'g';
	alpha[7] = 'h';
	alpha[8] = 'i';
	alpha[9] = 'j';
	alpha[10] = 'k';
	alpha[11] = 'l';
	alpha[12] = 'm';
	alpha[13] = 'n';
	alpha[14] = 'o';
	alpha[15] = 'p';
	alpha[16] = 'q';
	alpha[17] = 'r';
	alpha[18] = 's';
	alpha[19] = 't';
	alpha[20] = 'u';
	alpha[21] = 'v';
	alpha[22] = 'w';
	alpha[23] = 'x';
	alpha[24] = 'y';
	alpha[25] = 'z';
}
void print_string(char buff[LINESIZE]){
	int i;
	for(i=0; i < LINESIZE; i++){
		printf("%c",buff[i]);
		if(buff[i] == '\n'){
			break;
		}
	}
}


int count_vowels(char buff[LINESIZE]){
	int nv = 0;
	int i = 0;

	for(i=0; i<LINESIZE; i++){
		printf("%c",buff[i]);
		if( buff[i] == '\n'){
			break;
		}else if(buff[i] == 'a'){
			nv++;
		}else if(buff[i] == 'e'){
			nv++;
		}else if(buff[i] == 'i'){
			nv++;
		}else if(buff[i] == 'o'){
			nv++;
		}else if(buff[i] == 'u'){
			nv++;
		}
	}
	return nv;
}

void caesar_cipher(char buff[LINESIZE], 
                   char cc[LINESIZE], 
                   int key){
	int i, a, eol;
	char alpha[26];
	int alpha_index;

	eol = 0;
	alpha_init(alpha);
	for(i=0; i < LINESIZE; i++){
        if(buff[i] == '\n' || 
            eol == 1 || 
            buff[i] == '.'){
            cc[i] = '\n';
            eol = 1;
        }else if(buff[i] == ' '){
            cc[i] = ' ';		
        }else{
            for(a=0; a < 26; a++){
                if(buff[i] == alpha[a]){
                    alpha_index = (a+key) % 26;
                    cc[i] = alpha[alpha_index];		
                }
            }
        }		
    }
}

int main(int argc, char* argv[]){
    FILE *fp;	
    char buff[LINESIZE];
    char cc[LINESIZE];
    int nv = 0;
    
    
    fp = fopen(argv[1],"r");
    
    while (fgets(buff,
                 sizeof(buff),
                (FILE*)fp) != NULL){
        nv += count_vowels(buff);
        printf("%s",buff);
        printf("\n");
        caesar_cipher(buff,cc,1);
        printf("\n");
        print_string(cc);
        printf("\n");
    }
    
    printf("\nNumber of vowels : %d\n",nv);
    
    fclose(fp);
}



