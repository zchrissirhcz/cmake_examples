package droid;

public class HelloWorld
{
    static {
        System.loadLibrary("hello");
    }

    private native void print();

    public static void main(String[] args){
        new HelloWorld().print();
        new Thread().start();
    }
}