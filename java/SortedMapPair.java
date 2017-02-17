package A3Q2;
/**
 * Stores a pair of sorted arrays.  The arrays are assumed to
 * be disjoint, i.e., none of the elements are repeated, either within or between
 * the arrays.  Elements within each array are strictly increasing in value.
 * A method is provided to find the kth smallest value in the union of the two
 * arrays, in O(log k) time.
 */

public class SortedMapPair<E extends Comparable<E>> {
    E[] A1, A2;
    /* Note that the constructor assumes the arrays to be pre-sorted.*/
    public SortedMapPair(E[] array1, E[] array2)
            throws NullPointerException {
        if (array1 == null || array2 == null) {
            throw new NullPointerException();
        }
        A1 = array1;
        A2 = array2;
    }

public E kthSmallestOfUnion(int k) throws RankOutOfRangeException {
//implement this method
	if((k<1)||(k > (this.A1.length + this.A2.length))){
		throw new RankOutOfRangeException("");
	}
	if (this.A1.length == 0){
		return this.A2[k-1];
	}
	else if (this.A2.length == 0){
		return this.A1[k-1];
	}
	else if(k==1){
		if((this.A1[k-1].compareTo(this.A2[k-1]))>0){
			return this.A2[k-1];
		}
		 return this.A1[k-1];
	}
	else{
			int a = 0;
			int b = 0;
			int c = 0;
			while(k > 1){
				c = k/2;
				if((this.A1.length-a >= c)&& (this.A1[a+c-1].compareTo(this.A2[b+c-1])<0)){
					a = a + c;
				}
				else{
					b = b + c;
				}
				k = k - c;
			}
			if ((this.A1.length - a > 0)&&(this.A1[a].compareTo(this.A2[b]) < 0)){
				return this.A1[a];
			}
			else{
				return this.A2[b];
			
	}

	
	}}
	
	
	
	
}
