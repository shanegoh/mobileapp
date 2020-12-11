package com.example.activeandfit;

import java.util.ArrayList;

import android.content.Intent;
import android.media.Image;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.app.Activity;

public class MainActivity extends Activity
{

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //ImageViews reference by its ID
        ImageView poolView = (ImageView) findViewById(R.id.Pool);
        ImageView tennisView = (ImageView) findViewById(R.id.Tennis);
        ImageView squashView = (ImageView) findViewById(R.id.Squash);
        ImageView yogaView = (ImageView) findViewById(R.id.Yoga);
        ImageView funcView = (ImageView) findViewById(R.id.Functional);

        //pool
        poolView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                BookInfo book_Pool = new BookInfo("Pool", 0, "0", "0", "0", R.drawable.pool);
                //Add data, (Key, value)
                Intent intent = new Intent(MainActivity.this, BookActivity.class);
                //Pass data to next activity
                intent.putExtra("BookInfo", book_Pool);
                startActivity(intent);
            }
        });

        //tennis
        tennisView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                BookInfo book_Tennis = new BookInfo("Tennis Court", 0, "0", "0", "0", R.drawable.tennis);
                //Add data, (Key, value)
                Intent intent = new Intent(MainActivity.this, BookActivity.class);
                //Pass data to next activity
                intent.putExtra("BookInfo", book_Tennis);
                startActivity(intent);
            }
        });

        //squash
        squashView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                BookInfo book_Squash = new BookInfo("Squash Court", 0, "0", "0", "0", R.drawable.squash);
                //Add data, (Key, value)
                Intent intent = new Intent(MainActivity.this, BookActivity.class);
                //Pass data to next activity
                intent.putExtra("BookInfo", book_Squash);
                startActivity(intent);
            }
        });

        //yoga
        yogaView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                BookInfo book_Yoga = new BookInfo("Yoga Room", 0, "0", "0", "0", R.drawable.yoga);
                //Add data, (Key, value)
                Intent intent = new Intent(MainActivity.this, BookActivity.class);
                //Pass data to next activity
                intent.putExtra("BookInfo", book_Yoga);
                startActivity(intent);
            }
        });

        //func
        funcView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                BookInfo book_Func = new BookInfo("Functional Fitness", 0, "0", "0", "0", R.drawable.func);
                //Add data, (Key, value)
                Intent intent = new Intent(MainActivity.this, BookActivity.class);
                //Pass data to next activity
                intent.putExtra("BookInfo", book_Func);
                startActivity(intent);
            }
        });


    }
}




