using System;

public class MemTest
{
	static public void Main()
	{
		const int N = 813;
		Console.WriteLine("N = " + N);
		double[,,]A = new double[N,N,N];

		Console.WriteLine("Attempting to allocate " + (N*N*N) + " doubles");

		for(int i = 0; i < N; i++) {
			for(int j = 0; j < N; j++) { 
				for(int k = 0; k < N; k++) {
					A[i,j,k] = i*N*N+j*N+k+1;
				}
			}
		}
		
		Console.WriteLine("Last elements is " + A[N-1,N-1,N-1]);
	}
}
