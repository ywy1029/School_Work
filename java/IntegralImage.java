package A1Q2;

/**
 * Represents an integer integral image, which allows the user to query the mean
 * value of an arbitrary rectangular subimage in O(1) time.  Uses O(n) memory,
 * where n is the number of pixels in the image.
 *
 */
public class IntegralImage {

    private final int[][] integralImage;
    private final int imageHeight; // height of image (first index)
    private final int imageWidth; // width of image (second index)

    /**
     * Constructs an integral image from the given input image.  
     * @param image The image represented
     * @throws InvalidImageException Thrown if input array is not rectangular
     */
    public IntegralImage(int[][] image) throws InvalidImageException {
    	 //implement this method.
    	this.imageHeight = image.length;
    	this.imageWidth = image[0].length;
    	if(this.Rectangular(image)){
    		this.integralImage = new int[this.imageHeight][this.imageWidth];
    		this.integralImage[0][0] = image[0][0];
    		for(int i=1; i<this.imageWidth;i++){
    			this.integralImage [0][i] = image[0][i]+this.integralImage[0][i-1];
    			this.integralImage [i][0]= image[i][0]+this.integralImage[i-1][0];
    		}
    		for(int i= 1;i<this.imageHeight;i++){
    			for(int j= 1;j<this.imageWidth;j++){
    				this.integralImage[i][j] = image[i][j]+this.integralImage[i][j-1]+this.integralImage[i-1][j]-this.integralImage[i-1][j-1];
    				
    			}
    		}
    	}
    	else{
    		 throw new InvalidImageException("");
    	}
    }

    /**
     * Returns the mean value of the rectangular sub-image specified by the
     * top, bottom, left and right parameters. The sub-image should include
     * pixels in rows top and bottom and columns left and right.  For example,
     * top = 1, bottom = 2, left = 1,if(this.isRectangular(image)){ right = 2 specifies a 2 x 2 sub-image starting
     * at (top, left) coordinate (1, 1).  
     *
     * @param top top row of sub-image     * @param bottom bottom row of sub-image
     * @param left left column of sub-image
     * @param right right column of sub-image
     * @return 
     * @throws BoundaryViolationException if image indices are out of range
     * @throws NullSubImageException if top > bottom or left > right
     */
    public double meanSubImage(int top, int bottom, int left, int right) throws BoundaryViolationException, NullSubImageException {
        //implement this method
    	//dummy value - remove once coded.
    	int average = 0;
    	int sum = 0;
    	int height = bottom -top+1;
    	int width = right - left +1;
    	if(top>(this.imageHeight-1)||bottom>(this.imageHeight-1)||left>(this.imageWidth-1)||right>(this.imageWidth-1)){
    		throw new BoundaryViolationException("");
    	}
    	else if((top > bottom)||(left > right)){
    		throw new NullSubImageException("");
    	}
    	else{
    		sum = this.integralImage[bottom][right]-this.integralImage[bottom][left-1]-this.integralImage[top-1][right]+this.integralImage[top-1][left-1];
    	average = sum/(width*height);
    	}
    	return average;
    }
    
 	
    private boolean Rectangular(int[][] image){
        for(int i=0; i<(image.length-1);i++){
                if(image[i].length!=image[i+1].length)
                        return false;
        }
        return true;
    }
    
    public class InvalidImageException extends Exception{
        public InvalidImageException(String msg){
                super(msg);
        }
    }
    public class BoundaryViolationException extends Exception{
        public BoundaryViolationException(String msg){
                super(msg);
        }
    }

    public class NullSubImageException extends Exception{
        public NullSubImageException(String msg){
                super(msg);
        }
    }
    	
    public static void main(String[] args) {
            int[][] image1 = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
            int top,bottom,left,right;
            double mean;

            IntegralImage integralImage1;
            top = 1;
            bottom = 2;
            left = 1;
            right = 2;
            
            try {
                integralImage1 = new IntegralImage(image1);
            } catch (InvalidImageException iix) {
                System.out.println("Invalid Image Exception");
                return;
            }
           try {
                mean = integralImage1.meanSubImage(top, bottom, left, right); //should be 7.0
                System.out.println("The mean of the subimage from ("
                        + top + "," + left + ") to (" + bottom + "," + right + ") is " + mean);
            } catch (BoundaryViolationException bvx) {
                System.out.println("Index out of range.");
            } catch (NullSubImageException nsix) {
                System.out.println("Null sub-image.");
            }

        }
    	
   
}

