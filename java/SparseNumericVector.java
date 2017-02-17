package A1Q1;
import java.util.*;


/**
 * Represents a sparse numeric vector. Elements are comprised of a (long)
 * location index an a (double) value.  The vector is maintained in increasing
 * order of location index, which facilitates numeric operations like
 * inner products (projections).  Note that location indices can be any integer
 * from 1 to Long.MAX_VALUE.  The representation is based upon a
 * singly-linked list.
 * The following methods are supported:  iterator, getSize, getFirst,
 * add, remove, and project, which projects the vector onto a second vector
 * passed as a parameter.
 */
public class SparseNumericVector implements Iterable {

    protected SparseNumericNode head = null;
    protected SparseNumericNode tail = null;
    protected long size;

  /**
     * Iterator
     */
    @Override
    public Iterator<SparseNumericElement> iterator() { //iterator
        return new SparseNumericIterator(this);
    }

    /**
     * @return number of non-zero elements in vector
     */
   public long getSize() {
        return size;
    }

     /**
     * @return the first node in the list.
     */
    public SparseNumericNode getFirst() {
        return head;
    }
    
    /**
     * Add the element to the vector.  It is inserted to maintain the
     * vector in increasing order of index.  If an element with the same
     * index already exists, its value is updated. 
     * If an element with 0 value is passed, it is ignored.
     * @param e element to add
     */
  public void add(SparseNumericElement e) {
       //implement this method
	  if((this.head == null)||(e.getIndex()<this.head.getElement().getIndex())){
		  this.addtohead(e);
	  }
	  else if(e.getIndex()>this.tail.getElement().getIndex()){
		  this.addtotail(e);
	  }
	  else{
		  SparseNumericNode n = this.getNode(e.getIndex());
		  if(n.getNext().getElement().getIndex() == e.getIndex()){
			  n.getNext().getElement().setValue(e.getValue());
		  }
		  else{
			  SparseNumericNode nn = new SparseNumericNode(e,n.getNext());
			  n.setNext(nn);
			  this.size++;
			  this.tail = this.getnext();
		}
    }
  }

    /**
     * If an element with the specified index exists, it is removed and the
     * method returns true.  If not, it returns false.
     *
     * @param index of element to remove
     * @return true if removed, false if does not exist
     */
    public boolean remove(Long index) {
        //implement this method
        //this return statement is here to satisfy the compiler - replace it with your code.
    	SparseNumericNode n = this.getNode(index);
        if(n.getNext().getNext() == null){
        	n.setNext(null);
        	return true;
        }
        else if((n.getNext().getNext() != null)){
        	n.setNext(n.getNext().getNext());
        	return true;
        	}
        else 
        	return false;
    }
    /**
     * Returns the inner product of the vector with a second vector passed as a
     * parameter.  The vectors are assumed to reside in the same space.
     * Runs in O(m+n) time, where m and n are the number of non-zero elements in
     * each vector.
     * @param Y Second vector with which to take inner product
     * @return result of inner product
     */

    public double project(SparseNumericVector Y) {
        //implement this method
        //this return statement is here to satisfy the compiler - replace it with your code.
    	SparseNumericNode x = this.head;
    	SparseNumericNode y = Y.head;
    	double z = 0;
    	while(true){
    		if(x.getElement().getIndex() <y.getElement().getIndex()){
    			x = x.getNext();
    		}
    		if(x.getElement().getIndex() >y.getElement().getIndex()){
    			y = y.getNext();
    		}
    		if(x.getElement().getIndex()== y.getElement().getIndex()){
    			z += ((x.getElement().getValue())*(y.getElement().getValue()));
    			if(x == this.tail || y == Y.tail) {
                      break;
    			} 
    			else {
                      x = x.getNext();
                      y = y.getNext();
                      continue;
    			}
    		}
    		if(x == this.tail &&y == Y.tail) {
              break;
    		}
    	}
    	return z;
    		
   }

       /**
     * returns string representation of sparse vector
     */

    @Override
    public String toString() {
        String sparseVectorString = "";
        Iterator<SparseNumericElement> it = iterator();
        SparseNumericElement x;
        while (it.hasNext()) {
            x = it.next();
            sparseVectorString += "(index " + x.getIndex() + ", value " + x.getValue() + ")\n";
        }
        return sparseVectorString;
    }
    
    //private method
    private void addtohead(SparseNumericElement e){
    	SparseNumericNode n = new SparseNumericNode(e,this.head);
    	this.head = n;
    	this.size++;
    	this.tail = this.getnext();
    }
    
    private SparseNumericNode getnext(){
    	SparseNumericNode n = this.head;
    	while(n.getNext()!=null){
    		n = n.getNext();
    	}
    	return n;
    }
    
    private void addtotail(SparseNumericElement e){
    	SparseNumericNode n = new SparseNumericNode(e,null);
    	SparseNumericNode z = this.getnext();
    	z.setNext(n);
    	this.size++;
    	this.tail = this.getnext();
    	
    }
    
    private SparseNumericNode getNode(long index){
    	SparseNumericNode n = this.head;
    	while((n.getNext()!=null)&&(n.getNext().getElement().getIndex() < index)){
    			n=n.getNext();
    	}
    	return n;
    }
    
}
