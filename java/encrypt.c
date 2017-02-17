/**
 * Family Name: yao
 * Given Name: wenyan
 * Student Number: 213303359
 * CSE Login: ywy1029
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <time.h>

#define TEN_MILLIS_IN_NANOS 10000000

/* declare global variables */
FILE	*file_in;
FILE	*file_out;
int	bufSize = 0;
int	KEY;
int	countInThreads;
int	countWorkThreads;

/* declare all mutex variables */
pthread_mutex_t mutexIN;
pthread_mutex_t mutexOUT;
pthread_mutex_t mutexWORK;

/* common things in buffer */
typedef  struct {
	char	data;
	off_t	offset;
	char	state;
} BufferItem;

/* array */
BufferItem *result;

/* nanosleep */
void na_sleep()
{
	struct timespec t;
	int		seed = 0;
	t.tv_sec	= 0;
	t.tv_nsec	= rand_r( (unsigned int *) &seed ) % (TEN_MILLIS_IN_NANOS + 1);
	nanosleep( &t, NULL );
}


/* get the first empty item in buffer */
int FirstItem()
{
	int i = 0;
	while ( i < bufSize )
	{
		if ( result[i].state == 'i' )
		{
			return(i);
		}
		i++;
	}
	return(-1);
}


/* get the first work item in buffer */
int FirstWork()
{
	int i = 0;
	while ( i < bufSize )
	{
		if ( result[i].state == 'w' )
		{
			return(i);
		}
		i++;
	}
	return(-1);
}


/* get the first finish item in buffer */
int FirstFinsh()
{
	int i = 0;
	while ( i < bufSize )
	{
		if ( result[i].state == 'o' )
		{
			return(i);
		}
		i++;
	}
	return(-1);
}


/* IN thread */
void *In_Thread( void *argu )
{
	int	index;
	char	current;
	off_t	offset;


	do
	{
		na_sleep();
		pthread_mutex_lock( &mutexWORK );
		index = FirstItem();

		/* the buffer is not full */
		if ( index >= 0 )
		{
			/* lock in mutex */
			pthread_mutex_lock( &mutexIN );
			offset	= ftell( file_in );
			current = fgetc( file_in );
			pthread_mutex_unlock( &mutexIN );

			if ( current == EOF )
			{
				/* unlock work mutex */
				pthread_mutex_unlock( &mutexWORK );
				break;
			}else {
				/* store character to the buffer */
				result[index].offset	= offset;
				result[index].data	= current;
				result[index].state	= 'w';
			}
		}else { /* if the buffer is full, unlock work mutex */
			pthread_mutex_unlock( &mutexWORK );
			continue;
		}
		pthread_mutex_unlock( &mutexWORK );
	}
	while ( 1 );

	/* decrease Inthread counter, lock in work mutex to decrease */
	pthread_mutex_lock( &mutexWORK );
	countInThreads--;
	pthread_mutex_unlock( &mutexWORK );
	pthread_exit( NULL );
}


void *Work_Thread( void *argu )
{
	int	index;
	char	current;
	int	key = atoi( argu );

	do
	{
		na_sleep();
		pthread_mutex_lock( &mutexWORK );
		index = FirstWork();
		if ( index >= 0 )
		{
			current = result[index].data;

			/* encrypt or decrypt the currentent character */
			if ( key >= 0 && current > 31 && current < 127 )
			{
				current = ( ( (int) current - 32) + 2 * 95 + key) % 95 + 32;
			} else if ( key < 0 && current > 31 && current < 127 )
			{
				current = ( ( (int) current - 32) + 2 * 95 - (-1 * key) ) % 95 + 32;
			}

			result[index].data	= current;
			result[index].state	= 'o';
		} else {
			/* if in thread still has character, it continues work, and unlock work mutex and break */
			if ( countInThreads != 0 )
			{
				pthread_mutex_unlock( &mutexWORK );
				continue;
			} else {
				/* it finished,break */
				pthread_mutex_unlock( &mutexWORK );
				break;
			}
		}
		pthread_mutex_unlock( &mutexWORK );
	}
	while ( 1 );

	/* decrease work counter, lock in work mutex to decrease */
	pthread_mutex_lock( &mutexWORK );
	countWorkThreads--;
	pthread_mutex_unlock( &mutexWORK );

	pthread_exit( NULL );
}


void *Out_Thread( void *argu )
{
	int	index;
	char	current;
	off_t	offset;

	do
	{
		na_sleep();
		pthread_mutex_lock( &mutexWORK );
		index = FirstFinsh();
		if ( index >= 0 )
		{
			offset	= result[index].offset;
			current = result[index].data;
			/* lock out mutex */
			pthread_mutex_lock( &mutexOUT );
			if ( fseek( file_out, offset, SEEK_SET ) == -1 )
			{
				fprintf( stderr, "error setting output file position to %u\n", (unsigned int) offset );
				exit( 1 );
			}
			if ( fputc( current, file_out ) == EOF )
			{
				fprintf( stderr, "error writing byte %d to output file\n", current );
				exit( 1 );
			}
			/* unlock mutex work */
			pthread_mutex_unlock( &mutexOUT );

			result[index].data	= '\0';
			result[index].state	= 'i';
			result[index].offset	= 0;
		}else { /* if the work thread still has work,it continue work ,and unlock work mutex */
			if ( countWorkThreads != 0 )
			{
				pthread_mutex_unlock( &mutexWORK );
				continue;
			} else {
				/* it finished,break */
				pthread_mutex_unlock( &mutexWORK );
				break;
			}
		}
		pthread_mutex_unlock( &mutexWORK );
	}
	while ( 1 );

	pthread_exit( NULL );
}


int main( int argc, char *argv[] )
{
	int	i = 0;
	int	nIN;
	int	nWORK;
	int	nOUT;

	/* initialize all mutexs */
	pthread_mutex_init( &mutexIN, NULL );
	pthread_mutex_init( &mutexWORK, NULL );
	pthread_mutex_init( &mutexOUT, NULL );

	/* read all arguments and print they errors when read and write a char and offset from to a file */
	if ( argc != 8 )
	{
		printf( "It will be invoked as follows: encrypt <KEY> <nIN> <nWORK> <nOUT> <file_in> <file_out> <bufSize>." );
		exit( 1 );
	}

	/* key */
	KEY = atoi( argv[1] );
	if ( KEY > 127 || KEY < -127 )
	{
		printf( "the key is not valid" );
		exit( 1 );
	}

	/* nin */
	nIN = atoi( argv[2] );
	if ( nIN < 1 )
	{
		printf( "the number of IN threads should be at least 1." );
		exit( 1 );
	}

	/* nwork */
	nWORK = atoi( argv[3] );
	if ( nWORK < 1 )
	{
		printf( "the number of WORK threads should be at least 1." );
		exit( 1 );
	}

	/* nout */
	nOUT = atoi( argv[4] );
	if ( nOUT < 1 )
	{
		printf( "the number of OUT threads should be at least 1." );
		exit( 1 );
	}

	/* filein */
	file_in = fopen( argv[5], "r" );
	if ( file_in == NULL )
	{
		printf( "could not open input file for reading" );
		exit( 1 );
	}

	/* fileout */
	file_out = fopen( argv[6], "w" );
	if ( file_out == NULL )
	{
		printf( "could not open output file for writing" );
		exit( 1 );
	}

	/* buffer size */
	bufSize = atoi( argv[7] );
	if ( bufSize < 1 )
	{
		printf( "This should be at least 1." );
		exit( 1 );
	}

	/* initialize value */
	countInThreads		= nIN;
	countWorkThreads	= nWORK;

	/* get all threads */
	pthread_t	InThreads[nIN];
	pthread_t	OutThreads[nOUT];
	pthread_t	WorkThreads[nWORK];

	pthread_attr_t attr;
	pthread_attr_init( &attr );

	result = calloc( bufSize, sizeof(BufferItem) );

	/* initialize the buffer */
	while ( i < bufSize )
	{
		result[i].state = 'i';
		i++;
	}

	/* create all threads */
	for ( i = 0; i < nIN; i++ )
	{
		pthread_create( &InThreads[i], &attr, (void *) In_Thread, file_in );
	}
	for ( i = 0; i < nWORK; i++ )
	{
		pthread_create( &WorkThreads[i], &attr, (void *) Work_Thread, (void *) (&KEY) );
	}
	for ( i = 0; i < nOUT; i++ )
	{
		pthread_create( &OutThreads[i], &attr, (void *) Out_Thread, file_out );
	}

	/* join all threads */
	for ( i = 0; i < nIN; i++ )
	{
		pthread_join( InThreads[i], NULL );
	}
	for ( i = 0; i < nWORK; i++ )
	{
		pthread_join( WorkThreads[i], NULL );
	}
	for ( i = 0; i < nOUT; i++ )
	{
		pthread_join( OutThreads[i], NULL );
	}

	/* destory all mutexs */
	pthread_mutex_destroy( &mutexIN );
	pthread_mutex_destroy( &mutexOUT );
	pthread_mutex_destroy( &mutexWORK );

	/* close all files */
	fclose( file_in );
	fclose( file_out );
	free( result );

	return(0);
}