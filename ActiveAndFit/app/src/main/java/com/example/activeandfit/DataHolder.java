package com.example.activeandfit;

import java.util.ArrayList;

//A class to save the arrayList within current session app. Will be gone when off
class DataHolder
{
        //Declare a DataHolder object type name instance
        private static DataHolder instance;
        //final arraylist bookinfo
        final ArrayList<BookInfo> dataList = new ArrayList<>();

        //Default constructor
        private DataHolder() { }

        //check if array is null
        static DataHolder getInstance()
        {
                //If empty, create new
                if( instance == null )
                {
                        instance = new DataHolder();
                }

                //Else, return existing instance
                 return instance;
        }


}