#include <bits/stdc++.h>

using namespace std;

int main()
{
    /*
    int b[] = {23,45,67,89,12,37};
    int a[] = {1,2,3,4,5};
    int temp = a[0]; //remember first element
    for(int i=0;i<4;i++)
    {
        a[i] = a[i+1]; //move all element to the left except first one
    }
    a[4] = temp;

    for(int i=0;i<5;i++)
        cout << a[i] << " ";
    cout << endl;
    */
    
    int array[10];
    for(int i = 0; i < 10; i++)
    {
        array[i] = i+1;
    }
    int nums[] = {1,56,34,67,23,8,234,8327,32,576,345,78,234,12,879,123,345,123,678,8327,983,2334,345,123,4567,3345,547,237,845,9,12,567,23,9,23,7,123,67,84};
    for(int i = 0; i < 40; i++)
    {
        if(nums[i] > array[0])
        {
            array[0] = nums[i];
        }
        sort(array,array+10);
    }

    for(int i = 0; i < 10; i++)
        cout << array[i] << " ";
    cout << endl;
    sort(nums,nums+40);
    for(int i = 30; i < 40; i++)
        cout << nums[i] << " ";
    cout << endl;
    
    return 0;
}