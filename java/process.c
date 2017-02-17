
/*
# Family Name:yao

# Given Name:wenyan

# Section:Z

# Student Number:213303359

# CSE Login:ywy1029
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
#include <sys/types.h>


struct word{
        char name[30];
        double vector[1000];
};
struct similarity{
        struct word* w1;
        struct word* w2;
        double s;
};

struct word word_copy[5000];

//calucate the similarity
double calucate_similarity( struct word w1, struct word w2, int count )
{
                int i = 0;
        double result = 0.0;
        double numerator = 0.0;
        double denominator = 0.0;
        double denominator_1 = 0.0;
        double denominator_2 = 0.0;
        for( i = 0; i < count;i++){
                numerator = numerator + w1.vector[i] * w2.vector[i];
                denominator_1 = denominator_1 + w1.vector[i]*w1.vector[i];
                denominator_2 = denominator_2 + w2.vector[i]*w2.vector[i];
        }
        denominator = sqrt( denominator_1)   * sqrt(denominator_2)  ;
        result = numerator / denominator;
        return result;
}


int cmp( const void *a, const void *b )
{
        return((((struct similarity*) a)->s) >(((struct similarity*) b)->s)?-1:1) ;
}

//count the number of vector
int getDimension( FILE *fp)
{
        int i = 0, d = 0;
        char str[100000];
        //read a line from the file
        fgets(str, 100000, fp);
        while(i < 100000){
                if(str[i] == '\0'){
                        break;
                }
                //count the dimension
                if(str[i] == ' '){
                        d++;
                }
                i++;
        }
        //reset the file
        rewind(fp)  ;
        return(d)  ;
}


//create a similarity array
void create_similarity_array(struct similarity** similarity_array, struct word* word_f, int word_count, int vector_count, int simi_count)  {
        int i,j,k=0;
        double s_result;

        //dynamic allocation
        *similarity_array =(struct similarity*)  calloc(simi_count, sizeof(struct similarity)  )  ;

        for(i=0; i<word_count; i++){
                for(j=i+1; j<word_count; j++){
                        //get similarity of two words,put words and similarity
                        s_result = calucate_similarity(word_f[i], word_f[j], vector_count)  ;
                        (*similarity_array) [k].w1 = &(word_f[i])  ;
                        (*similarity_array) [k].w2 = &(word_f[j])  ;
                        (*similarity_array) [k].s = s_result;
                        k++;
                }
        }
}

//search the top 3 most similar word pairs in the data set
void top_similar( char* file, struct similarity* similarity,char* rt )
{
        int i = 0;
        char temp[300];
        sprintf(temp, "%s ", file);
        strcat(rt, temp);
        for ( i = 0; i < 3; i++ )
        {
                sprintf(temp, "%s %s %lf  ", similarity[i].w1,similarity[i].w2, similarity[i].s );
                strcat(rt, temp);
        }

        sprintf(temp, " \n" );
        strcat(rt, temp);
}



int main( int argc, char *argv[] )
{
        int p =-1,pp[argc-1][2];
        pid_t pid=1;
        char put[300];
        memset(put, 0, 300);

        struct word word;
        int i,j,word_count=0,vector_count=0,simi_count=0;
        struct similarity* simi_point=NULL;
        FILE *fp;

        while(pid > 0 && p < argc -2){

        		p++;
        		pipe(pp[p]);
        		pid = fork();

        }

       if(pid < 0){

                printf("ERROR IN FORK!\n");
                exit(1);

        }
        /* child process */
        else if(pid == 0) { 
                close(pp[pid][0]);
                char rs[300];
                memset(rs, 0, 300);

                fp = fopen( argv[p+1], "r" );  //open the file

                //check for file
                if(fp == NULL){
                        printf("Cannot Open the File: %s", *argv);
                        return(1) ;
                }

                // Reset and get the number of vector
                word_count=0;
                simi_count=0;
                vector_count = getDimension(fp)  ;

                //put word and its vector in struct
                while(EOF != fscanf( fp, "%s", word.name)){
                        //put all vector in struct in for loop
                        for(i = 0; i < vector_count; i++){
                                //check for word whether is a vector
                                if(fscanf( fp, " %lf", &word.vector[i]) == 0){
                                        word.vector[i] = 0;
                                }
                        }

                        //put all word in an array
                        word_copy[word_count] = word;
                        //count the number of word
                        word_count++;
                }

                //count the number of couting similarity
                simi_count = (word_count*(word_count-1)) / 2;


                //put the similarity in an array
                create_similarity_array(&simi_point, word_copy, word_count, vector_count, simi_count);

                //qsort the similarity
                qsort(simi_point, simi_count, sizeof(struct similarity),cmp);

                top_similar(argv[p+1], simi_point, rs);

                if(simi_point != NULL){
                        free(simi_point);
                        simi_point=NULL;
                }
                write(pp[p][1],rs,300);

                close(pp[p][1]);
        }

        /* parent process */
        else{ 
                close(pp[p][1]);
                for(p=0;p<argc-1; p++){
                	if(read(pp[p][0], put, 300) > 0){
                		printf("%s", put);
                	}

                }
                close(pp[p][0]);

        }

        return 0;



}
	
