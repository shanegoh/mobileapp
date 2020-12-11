package com.example.activeandfit;

import androidx.appcompat.app.AppCompatActivity;
import android.content.Intent;
import android.os.Bundle;

public class SplashScreen extends AppCompatActivity
{

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        //Intent
        Intent intent = new Intent( SplashScreen.this, MainActivity.class);
        //Start activity
        startActivity(intent);
        finish ();


    }
}