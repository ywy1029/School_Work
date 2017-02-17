package A4Q1;
import java.util.*;

/**
 *
 * Provides two static methods for sorting Integer arrays (heapSort and mergeSort)
 */
public class YorkArrays {

    /* Sorts the input array of Integers a using HeapSort.  Result is returned in a.
     * Makes use of java.util.PriorityQueue.  
       Sorting is NOT in place - PriorityQueue allocates a separate heap-based priority queue. 
       Not a stable sort, in general.  
       Throws a null pointer exception if the input array is null.  */
	 public static void heapSort(Integer[] a) throws NullPointerException {
	       //implement this method.
	    	PriorityQueue sort = new PriorityQueue();
	    	for(int i = 0;  i < a.length; i++){
	    		sort.add(a[i]);
	    	}
	    	for(int i = 0 ; i < a.length; i++){
	    		a[i] = (Integer)sort.poll();
	    	}
	    }
    
    /* Sorts the input array of Integers a using mergeSort and returns result.
     * Sorting is stable.
       Throws a null pointer exception if the input array is null. */
    public static Integer[] mergeSort(Integer[] a)  throws NullPointerException {
        return(mergeSort(a, 0, a.length-1));
    }
    
    /* Sorts the input subarray of Integers a[p...q] using MergeSort and returns result.
     * Sorting is stable.
     */
    private static Integer[] mergeSort(Integer[] a, int p, int q) {
        //implement this method.
    	if(a == null){
    		throw new NullPointerException();
    	}
    	if(a.length == 1)
    		return a;
    	int k=0,j=0;
    	Integer[] first = new Integer[(q-p+1)/2] ;
    	Integer[] second = new Integer[q-p+1-(q-p+1)/2] ;
    	for(int i =p; i <= q ;i++){
    		if(i<p+(q-p+1)/2){
    			first[j]=a[i];
    			j++;
    		}
    		else {
    			second[k]=a[i];
    			k++;
    		}
    	}
    	
    	first = mergeSort(first,0,first.length-1);
    	second = mergeSort(second,0,second.length-1);
    	
    	Integer[] total = merge(first,second);
		return total;
    	
    	
    }
    
    /* Merges two sorted arrays of Integers into a single sorted array.  Given two
     * equal elements, one in a and one in b, the element in a precedes the element in b.
     */
    private static Integer[] merge(Integer[] a, Integer[] b) {
        //implement this method.
    	Integer[] total = new Integer[a.length + b.length];
    	int i = 0, j = 0, k = 0;
    	while ((i < a.length)&&( j < b.length)){
    		if(a [i] <= b[j]){
    			total [k] =a[i];
    			i++;
    			k++;
    		}
    		else{
    			total[k]=b[j];
    			j++;
    			k++;
    		}
    	}
    	while (i < a.length){
    	total[k] = a[i];
            i++;
            k++;
        }

        while (j < b.length){
            total[k] = b[j];
            j++;
            k++;
        }
        
        return total;
    }
    	
  
}

