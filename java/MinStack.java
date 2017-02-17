package A1Q3;
import java.util.*;
/**
 * Specializes the stack data structure for comparable elements, and provides
 * a method for determining the minimum element on the stack in O(1) time.
 */

public class MinStack<E extends Comparable> extends Stack<E> {

    private Stack<E> minStack;
    private Stack<E> minimum = new Stack<>();

    public MinStack() {
        minStack = new Stack<>();
    }

    /* must run in O(1) time */
    public E push(E element) {
    	this.minStack.push(element);  
    	if (this.minimum.isEmpty() || this.minimum.peek().compareTo(element)>=0){ 
    		
    		this.minimum.push(element);
    	}
         return null;
    }  //Dummy return to satisfy compiler.  Remove once coded.
    

    /* @exception  EmptyStackException  if this stack is empty. */
    /* must run in O(1) time */
   public synchronized E pop() {
	   if(this.minStack.isEmpty()){
           throw new EmptyStackException();
	   }
	   if (this.minimum.peek().compareTo(this.minStack.peek())>=0){
           this.minimum.pop(); 
       } 
       return this.minStack.pop(); 
	 
		  //Dummy return to satisfy compiler.  Remove once coded.
    }

    /* Returns the minimum value currenctly on the stack. */
    /* @exception  EmptyStackException  if this stack is empty. */
    /* must run in O(1) time */
    public synchronized E min() {
        return this.minimum.peek(); //Dummy return to satisfy compiler.  Remove once coded.
    }
}
